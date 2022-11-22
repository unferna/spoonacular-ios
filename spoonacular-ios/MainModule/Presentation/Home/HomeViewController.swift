//
//  HomeViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

class HomeViewController: BasicViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Try ‘Mashed Potatoes’"
        searchBar.searchTextField.font = Theme.LabelStyle.input.textStyle.font
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshContentTableViewData), for: .valueChanged)
        return control
    }()
    
    private lazy var tableContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.roundCorners(.layerMinXMinYCorner, radius: 32)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(RecipeItemTableViewCell.self)
        var tablePadding = tableView.contentInset
        tablePadding.top = Theme.Layout.basicInterItemSpacing
        tablePadding.bottom = Theme.Layout.basicHorizontalSpacing
        tableView.contentInset = tablePadding
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var closeKeyboardGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector( dismissKeyboard ))
    }()
    
    @objc private func refreshContentTableViewData(_ sender: Any) {
        loadData()
    }
    
    private var presentation: RecipesPresenter?
    private var cardsDataSource: [CardItem] = []
    private var viewItemsCount = 10
    private var debounceSearchBarTimer: Timer?
    
    override func commonInit() {
        super.commonInit()
        
        presentation = RecipesPresenter(view: self)
        presentation?.registerPersistanceDelegate(persistanceDelegate: self)
        setupSubviews()
        loadData()
    }
    
    private func setupSubviews() {
        view.backgroundColor = Theme.Colors.primary
        
        view.addSubview(searchBar)
        view.addSubview(tableContainerView)
        tableContainerView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: basicDeviceTopInset + Theme.Layout.basicInterItemSpacing),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Layout.basicInterItemSpacing),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Layout.basicInterItemSpacing),
            
            tableContainerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Theme.Layout.basicInterItemSpacing),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            contentTableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
        ])
    }
    
    private func loadData() {
        presentation?.findRecipes(searchText: searchBar.text, limit: viewItemsCount)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        view.removeGestureRecognizer(closeKeyboardGesture)
    }
    
    private func reloadItemOf(id: String, isSaved: Bool) {
        guard let cardItemIndex = cardsDataSource.firstIndex(where: { $0.id == id }) else { return }
        cardsDataSource[cardItemIndex].isSaved = isSaved
        
        let target = IndexPath(row: cardItemIndex, section: 0)
        contentTableView.reloadRows(at: [target], with: .automatic)
    }
    
    deinit {
        presentation?.unregisterPersistanceDelegate(persistanceDelegate: self)
        view.removeGestureRecognizer(closeKeyboardGesture)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(closeKeyboardGesture)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceSearchBarTimer?.invalidate()
        debounceSearchBarTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.loadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cardItem = cardsDataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(RecipeItemTableViewCell.self, for: indexPath)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.configureWith(item: cardItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cardItem = cardsDataSource[safe: indexPath.row] else { return }
        
        let recipeDetailsViewController = RecipeDetailsViewController()
        recipeDetailsViewController.cardItem = cardItem
        if NetworkChecker.defaults.isConnected || cardItem.isSaved {
            navigationController?.pushViewController(recipeDetailsViewController, animated: true)
        }
    }
}

extension HomeViewController: RecipeItemTableViewCellDelegate {
    func didFavoriteStateToggle(at indexPath: IndexPath) {
        guard let cardItem = cardsDataSource[safe: indexPath.row] else { return }
        
        presentation?.toggleRecipe(cardItem: cardItem)
        cardsDataSource[indexPath.row].isSaved.toggle()
    }
}

extension HomeViewController: RecipesView {
    func recipesCardsLoaded(_ cards: [CardItem]) {
        cardsDataSource = cards
        contentTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension HomeViewController: ItemsPersistanceDelegate {
    func didItemSave(id: String) {
        reloadItemOf(id: id, isSaved: true)
    }
    
    func didItemRemove(id: String) {
        reloadItemOf(id: id, isSaved: false)
    }
}
