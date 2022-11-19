//
//  HomeViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
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
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RecipeItemTableViewCell.self, for: indexPath)
        cell.indexPath = indexPath
        
        return cell
    }
}
