//
//  RecipeDetailsTextItemTableViewCell.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 20/11/22.
//

import UIKit

protocol TextViewURLDelegate: AnyObject {
    func shouldOpenURLOrArticle(url: URL)
}

class RecipeDetailsTextItemTableViewCell: UITableViewCell {
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    weak var textViewURLDelegate: TextViewURLDelegate?
    
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
        contentView.addSubview(titleTextView)
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            titleTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureWith(text: String?, number: Int? = nil) {
        var formattedText = NSMutableAttributedString().text(text ?? "", style: .body)
        
        guard let number = number, number > 0 else {
            titleTextView.setHtmlText(text, theme: .body)
            return
        }
        
        let stringNumber = "\( String(number) ). "
        formattedText = NSMutableAttributedString()
            .text(stringNumber, style: .bodyBold)
            .text(text ?? "", style: .body)
        
        titleTextView.attributedText = formattedText
    }
}

extension RecipeDetailsTextItemTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        textViewURLDelegate?.shouldOpenURLOrArticle(url: URL)
        return false
    }
}
