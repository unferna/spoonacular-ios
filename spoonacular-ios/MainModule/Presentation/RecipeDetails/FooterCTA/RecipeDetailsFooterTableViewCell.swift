//
//  RecipeDetailsFooterTableViewCell.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

private enum ViewConfig {
    static let buttonHeight: CGFloat = 55
}

protocol RecipeDetailsFooterTableViewCellDelegate: AnyObject {
    func didToggleRecipeTapped()
}

class RecipeDetailsFooterTableViewCell: UITableViewCell {
    private lazy var ctaButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = ViewConfig.buttonHeight / 2
        button.backgroundColor = Theme.Colors.accent
        button.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func ctaButtonTapped(_ sender: UIButton) {
        delegate?.didToggleRecipeTapped()
    }
    
    weak var delegate: RecipeDetailsFooterTableViewCellDelegate?
    
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
        contentView.addSubview(ctaButton)
        
        NSLayoutConstraint.activate([
            ctaButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            ctaButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            ctaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            ctaButton.heightAnchor.constraint(equalToConstant: ViewConfig.buttonHeight),
            ctaButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    func configureWith(title: String?) {
        let text = NSMutableAttributedString().text(title ?? "", style: .largeButton, color: .white)
        ctaButton.setAttributedTitle(text, for: .normal)
    }
}
