//
//  RecipeDetailsViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

private enum RecipeDetailsCellType: CaseIterable {
    case header
    case summary
    case ingredients
    case instructions
    case footer
    
    static func casesValidation(recipeDetails: RecipeDetails) -> [Self] {
        var cases = allCases
        
        let summary = recipeDetails.summary ?? ""
        if summary.isEmpty {
            cases.removeAll(where: { $0 == .summary })
        }
        
        if recipeDetails.ingredients.isEmpty {
            cases.removeAll(where: { $0 == .ingredients })
        }
        
        if recipeDetails.instructions.isEmpty {
            cases.removeAll(where: { $0 == .instructions })
        }
        
        return cases
    }
}

protocol RecipeDetailsTableHeaderViewDelegate: AnyObject {
    func didBackButtonTap()
}

class RecipeDetailsTableHeaderView: UIView {
    private lazy var backButton: UIButton = {
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        let iconImage = UIImage(systemName: "arrow.backward", withConfiguration: iconConfiguration)
        
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(iconImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        delegate?.didBackButtonTap()
    }
    
    weak var delegate: RecipeDetailsTableHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(backButton)
        let constraints = [
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 38),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

class RecipeDetailsViewController: BasicViewController {
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(RecipeDetailsHeaderTableViewCell.self)
        tableView.registerCell(RecipeDetailsTextItemTableViewCell.self)
        tableView.registerCell(RecipeDetailsFooterTableViewCell.self)
        
        var tablePadding = tableView.contentInset
        tablePadding.bottom = Theme.Layout.basicHorizontalSpacing
        
        let tableHeaderSize = CGSize(width: firstKeyWindowSize.width, height: 48)
        let tableHeader = RecipeDetailsTableHeaderView(frame: CGRect(origin: .zero, size: tableHeaderSize))
        tableHeader.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = tablePadding
        tableView.tableHeaderView = tableHeader
        tableView.backgroundColor = .clear
        tableView.sectionFooterHeight = .zero
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var presentation: RecipesPresenter?
    private var details: RecipeDetails?
    var cardItem: CardItem?
    var recipeId: String?
    var useIdInstead = false
    
    override func commonInit() {
        super.commonInit()
        presentation = RecipesPresenter(view: self)
        presentation?.registerPersistanceDelegate(persistanceDelegate: self)
        setupSubviews()
        if let recipeId = recipeId, useIdInstead {
            loadData(id: recipeId)
            
        } else {
            loadData()
        }
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: basicDeviceTopInset + Theme.Layout.basicInterItemSpacing),
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        guard let cardItem = cardItem else { return }
        let shouldUseOfflineVersion = !NetworkChecker.defaults.isConnected && cardItem.isSaved
        presentation?.recipeDetails(of: cardItem, shouldLoadOfflineVersion: shouldUseOfflineVersion)
    }
    
    private func loadData(id: String) {
        let useOfflineVersion = !NetworkChecker.defaults.isConnected
        presentation?.recipeDetails(id: id, shouldLoadOfflineVersion: useOfflineVersion)
    }
    
    private func updateButtonSections() {
        guard let recipeDetails = details else { return }
        
        let types = RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails)
        let sectionsToReload: [RecipeDetailsCellType] = [.header, .footer]
        
        let indices = types.enumerated().filter { sectionsToReload.contains($1) }.map { $0.offset }
        let indexSet = IndexSet(indices)
        
        contentTableView.reloadSections(indexSet, with: .automatic)
    }
    
    deinit {
        presentation?.unregisterPersistanceDelegate(persistanceDelegate: self)
    }
}

extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let recipeDetails = details else { return 0 }
        return RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipeDetails = details else { return 0 }
        let types = RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails)
        
        let sectionType = types[section]
        
        switch sectionType {
        case .ingredients:
            return details?.ingredients.count ?? 0
            
        case .instructions:
            return details?.instructions.count ?? 0
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeDetails = details else { return UITableViewCell() }
        let types = RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails)
        let sectionType = types[indexPath.section]
        
        switch sectionType {
        case .header:
            let cell = tableView.dequeueReusableCell(RecipeDetailsHeaderTableViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configureWith(title: details?.title, image: details?.image, cookingTime: details?.cookingTime, isSaved: details?.isSaved ?? false)
            return cell
            
        case .summary:
            let cell = tableView.dequeueReusableCell(RecipeDetailsTextItemTableViewCell.self, for: indexPath)
            cell.textViewURLDelegate = self
            cell.configureWith(text: details?.summary)
            return cell
            
        case .ingredients:
            let ingredient = details?.ingredients[safe: indexPath.row]
            
            let cell = tableView.dequeueReusableCell(RecipeDetailsTextItemTableViewCell.self, for: indexPath)
            cell.configureWith(text: ingredient)
            return cell
            
        case .instructions:
            let instruction = details?.instructions[safe: indexPath.row]
            
            let cell = tableView.dequeueReusableCell(RecipeDetailsTextItemTableViewCell.self, for: indexPath)
            cell.configureWith(text: instruction?.step, number: instruction?.number)
            return cell
            
        case .footer:
            let ctaText = (details?.isSaved ?? false) ? "Remove Recipe" : "Save Recipe"
            
            let cell = tableView.dequeueReusableCell(RecipeDetailsFooterTableViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configureWith(title: ctaText)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let recipeDetails = details else { return nil }
        let types =  RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails)
        
        let sectionType = types[section]
        let header: SectionHeaderView?
        
        switch sectionType {
        case .summary:
            header = SectionHeaderView()
            header?.configureWith(title: "Summary")
            return header
            
        case .ingredients:
            header = SectionHeaderView()
            header?.configureWith(title: "Ingredients")
            return header
            
        case .instructions:
            header = SectionHeaderView()
            header?.configureWith(title: "Instructions")
            return header
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let recipeDetails = details else { return .zero }
        let types = RecipeDetailsCellType.casesValidation(recipeDetails: recipeDetails)
        
        let sectionType = types[section]
    
        switch sectionType {
        case .summary, .ingredients, .instructions:
            return 40
            
        default:
            return .zero
        }
    }
}

extension RecipeDetailsViewController: TextViewURLDelegate {
    func shouldOpenURLOrArticle(url: URL) {
        let urlString = url.absoluteString
        let chops = urlString.split(separator: "-")
        guard let recipeIdChop = chops.last else { return }
        
        let recipeId = String(recipeIdChop)
        guard recipeId.isNumber else { return }
        
        let controller = RecipeDetailsViewController()
        controller.useIdInstead = true
        controller.recipeId = recipeId
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RecipeDetailsViewController: RecipeDetailsTableHeaderViewDelegate {
    func didBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeDetailsViewController: RecipeDetailsHeaderTableViewCellDelegate {
    func didFavoriteButtonTap() {
        guard let recipeDetails = details else { return }
        presentation?.toggleRecipe(details: recipeDetails)
    }
}

extension RecipeDetailsViewController: RecipeDetailsFooterTableViewCellDelegate {
    func didToggleRecipeTapped() {
        guard let recipeDetails = details else { return }
        presentation?.toggleRecipe(details: recipeDetails)
    }
}

extension RecipeDetailsViewController: RecipeDetailsView {
    func recipeDetailsLoaded(_ details: RecipeDetails) {
        self.details = details
        contentTableView.reloadData()
    }
}

extension RecipeDetailsViewController: ItemsPersistanceDelegate {
    func didItemSave(id: String) {
        guard let recipeDetails = details, recipeDetails.id == id else { return }
        details?.isSaved = true
        
        updateButtonSections()
    }
    
    func didItemRemove(id: String) {
        guard let recipeDetails = details, recipeDetails.id == id else { return }
        details?.isSaved = false
        
        updateButtonSections()
    }
}
