//
//  RecipeDetailsHeaderTableViewCell.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

protocol RecipeDetailsHeaderTableViewCellDelegate: AnyObject {
    func didFavoriteButtonTap()
}

class RecipeDetailsHeaderTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Title"
        label.applyTextStyle(.screenTitle, ignoreLineHeight: true, color: Theme.Colors.primaryText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Theme.Colors.primary
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
        let bookmarkIconImage = UIImage(systemName: "bookmark", withConfiguration: imageConfiguration)
        let filledBookmarkIconImage = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfiguration)
        
        let button = UIButton()
        button.backgroundColor = Theme.Colors.accent
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.setImage(bookmarkIconImage, for: .normal)
        button.setImage(filledBookmarkIconImage, for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cookingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready in 5 Mins"
        label.applyTextStyle(.smallInformation, alignment: .right, color: Theme.Colors.primaryText?.withAlphaComponent(0.5))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didFavoriteButtonTap()
    }
    
    weak var delegate: RecipeDetailsHeaderTableViewCellDelegate?
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(recipeImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(cookingTimeLabel)
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            
            recipeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            recipeImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor, multiplier: 9 / 16),
            
            favoriteButton.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            favoriteButton.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            cookingTimeLabel.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor),
            cookingTimeLabel.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureWith(title: String?, image: String?, cookingTime: Int?, isSaved: Bool) {
        titleLabel.text = title
        cookingTimeLabel.text = "Ready in " + String(cookingTime ?? 0) + " Mins"
        favoriteButton.isSelected = isSaved
        
        guard let imageUrlString = image else { return }
        let imageUrl = URL(string: imageUrlString)
        
        recipeImageView.setImage(from: imageUrl)
    }
}
