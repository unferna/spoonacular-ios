//
//  SectionHeaderView.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

class SectionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Section Header"
        label.applyTextStyle(.headline, ignoreLineHeight: true, color: Theme.Colors.primaryText)
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
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configureWith(title: String?) {
        titleLabel.text = title
    }
}
