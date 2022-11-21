//
//  ModalViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 21/11/22.
//
import UIKit

private enum ViewConfig {
    static let containerWidth: CGFloat = 287
    static let iconSize: CGSize = CGSize(width: 32, height: 32)
    // #333
    static let overlayColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
    static let closeButtonTopSpace: CGFloat = 22
    static let closeButtonBottomSpace: CGFloat = -15
}

struct ModalData {
    var title: String?
    var description: String?
    var closeText: String?
}

class ModalViewController: UIViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 6
        view.addShadow(
            radius: 4,
            color: .black,
            offset: CGSize(width: 0, height: 6),
            opacity: 0.16
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerIconImageView: UIImageView = {
        let iconImage = UIImage(named: ImageResources.modalIcon)?
            .withRenderingMode(.alwaysTemplate)
        
        let imageView = UIImageView()
        imageView.image = iconImage
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.Colors.primaryText
        label.applyTextStyle(.bodyBold, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.Colors.primaryText
        label.applyTextStyle(.body, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private var modalData: ModalData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.backgroundColor = ViewConfig.overlayColor
        view.addSubview(containerView)
        containerView.addSubview(containerIconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: ViewConfig.containerWidth),
            
            containerIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Theme.Layout.basicInterItemSpacing),
            containerIconImageView.widthAnchor.constraint(equalToConstant: ViewConfig.iconSize.width),
            containerIconImageView.heightAnchor.constraint(equalToConstant: ViewConfig.iconSize.height),
            containerIconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerIconImageView.bottomAnchor, constant: Theme.Layout.mediumVerticalSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Theme.Layout.mediumVerticalSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: ViewConfig.closeButtonTopSpace),
            closeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: ViewConfig.closeButtonBottomSpace)
        ])
    }
    
    func configureWith(modalData: ModalData) {
        self.modalData = modalData
        titleLabel.text = modalData.title
        descriptionLabel.text = modalData.description
        
        let closeText = NSMutableAttributedString().text(modalData.closeText ?? "Close", style: .input, color: .red, underlined: true)
        closeButton.setAttributedTitle(closeText, for: .normal)
    }
}

