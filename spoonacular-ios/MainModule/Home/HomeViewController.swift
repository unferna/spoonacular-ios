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
    
    private lazy var tableContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = .layerMinXMinYCorner
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
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var closeKeyboardGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector( dismissKeyboard ))
    }()
    
    private var presentation: RecipesPresenter?
    private var cardsDataSource: [CardItem] = []
    private var viewItemsCount = 10
    private var debounceSearchBarTimer: Timer?
    
    override func commonInit() {
        super.commonInit()
        
        presentation = RecipesPresenter(view: self)
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
        
        view.addGestureRecognizer(closeKeyboardGesture)
    }
    
    private func loadData() {
        presentation?.findRecipes(searchText: searchBar.text, limit: viewItemsCount)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        view.removeGestureRecognizer(closeKeyboardGesture)
    }
}

extension HomeViewController: UISearchBarDelegate {
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

extension HomeViewController: UITableViewDataSource {
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
    }
}
