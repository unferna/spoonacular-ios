//
//  MyRecipesViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

class MyRecipesViewControllerTitleView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Recipes"
        label.applyTextStyle(.screenTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ]
        
        constraints[2].priority = .defaultHigh
        NSLayoutConstraint.activate(constraints)
    }
}

class MyRecipesViewController: BasicViewController {
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(RecipeItemTableViewCell.self)
        
        var tablePadding = tableView.contentInset
        tablePadding.top = Theme.Layout.basicInterItemSpacing
        tablePadding.bottom = Theme.Layout.basicHorizontalSpacing
        
        let tableHeaderSize = CGSize(width: firstKeyWindowSize.width, height: 50)
        let tableHeader = MyRecipesViewControllerTitleView(frame: CGRect(origin: .zero, size: tableHeaderSize))
        
        tableView.contentInset = tablePadding
        tableView.tableHeaderView = tableHeader
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var presentation: RecipesPresenter?
    private var cardsDataSource: [CardItem] = []
    
    override func commonInit() {
        super.commonInit()
        presentation = RecipesPresenter(view: self)
        presentation?.registerPersistanceDelegate(persistanceDelegate: self)
        setupSubviews()
        loadData()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: basicDeviceTopInset + Theme.Layout.basicInterItemSpacing),
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadData() {
        presentation?.findRecipes(savedOnly: true)
    }
}

extension MyRecipesViewController: RecipesView {
    func recipesCardsLoaded(_ cards: [CardItem]) {
        cardsDataSource = cards
        contentTableView.reloadData()
    }
}

extension MyRecipesViewController: UITableViewDataSource, UITableViewDelegate {
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
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
    }
}

extension MyRecipesViewController: RecipeItemTableViewCellDelegate {
    func didFavoriteStateToggle(at indexPath: IndexPath) {
        guard let cardItem = cardsDataSource[safe: indexPath.row] else { return }
        
        presentation?.toggleRecipe(cardItem: cardItem)
    }
}

extension MyRecipesViewController: ItemsPersistanceDelegate {
    func didItemSave(id: String) {
        loadData()
        contentTableView.reloadData()
    }
    
    func didItemRemove(id: String) {
        loadData()
        contentTableView.reloadData()
    }
}
