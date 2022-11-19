//
//  RecipeItemTableViewCell.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 18/11/22.
//

import UIKit

protocol RecipeItemTableViewCellDelegate: AnyObject {
    func didFavoriteStateToggle(at indexPath: IndexPath)
}

class RecipeItemTableViewCell: UITableViewCell {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Theme.Colors.primary
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Title"
        label.applyTextStyle(.cardTitle, color: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
        let bookmarkIconImage = UIImage(systemName: "bookmark", withConfiguration: imageConfiguration)
        let filledBookmarkIconImage = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfiguration)
        
        let button = UIButton()
        button.backgroundColor = Theme.Colors.accent
        button.tintColor = .white
        button.layer.cornerRadius = 19
        button.setImage(bookmarkIconImage, for: .normal)
        button.setImage(filledBookmarkIconImage, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        
        sender.isSelected = !sender.isSelected
        delegate?.didFavoriteStateToggle(at: indexPath)
    }
    
    weak var delegate: RecipeItemTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    private func setupSubviews() {
        selectionStyle = .none
        contentView.addSubview(mainContainerView)
        mainContainerView.addSubview(recipeImageView)
        mainContainerView.addSubview(titleLabel)
        mainContainerView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            mainContainerView.heightAnchor.constraint(equalTo: mainContainerView.widthAnchor, multiplier: 9 / 16),
            
            recipeImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: Theme.Layout.basicInterItemSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -Theme.Layout.basicInterItemSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -Theme.Layout.basicInterItemSpacing),
            
            favoriteButton.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: Theme.Layout.basicInterItemSpacing),
            favoriteButton.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -Theme.Layout.basicInterItemSpacing),
            favoriteButton.widthAnchor.constraint(equalToConstant: 38),
            favoriteButton.heightAnchor.constraint(equalToConstant: 38),
        ])
        
        let heightConstraint = mainContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Theme.Layout.basicInterItemSpacing)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    }
    
    func configureWith(item: CardItem) {
        titleLabel.text = item.title
        guard let imageUrlString = item.image else { return }
        let imageUrl = URL(string: imageUrlString)
        
        recipeImageView.setImage(from: imageUrl)
    }
}
