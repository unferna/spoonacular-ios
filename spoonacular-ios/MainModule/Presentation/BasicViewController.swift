//
//  BasicViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

class BasicViewController: UIViewController {
    private lazy var networkConnectionContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.alpha = 0
        view.backgroundColor = Theme.Colors.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var networkTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You are offline"
        label.applyTextStyle(.body, alignment: .center, color: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(networkConnectionContainerView)
    }
    
    func commonInit() {
        setupSubviews()
        NetworkChecker.defaults.registerDelegate(delegate: self)
    }
    
    private func setupSubviews() {
        view.addSubview(networkConnectionContainerView)
        networkConnectionContainerView.addSubview(networkTitleLabel)
        
        let tabbarViewHeight: CGFloat = tabBarController?.tabBar.bounds.height ?? 90
        NSLayoutConstraint.activate([
            networkConnectionContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarViewHeight),
            networkConnectionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkConnectionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            networkTitleLabel.leadingAnchor.constraint(equalTo: networkConnectionContainerView.leadingAnchor, constant: Theme.Layout.basicHorizontalSpacing),
            networkTitleLabel.trailingAnchor.constraint(equalTo: networkConnectionContainerView.trailingAnchor, constant: -Theme.Layout.basicHorizontalSpacing),
            networkTitleLabel.bottomAnchor.constraint(equalTo: networkConnectionContainerView.bottomAnchor, constant: -2),
            networkTitleLabel.topAnchor.constraint(equalTo: networkConnectionContainerView.topAnchor, constant: 2)
        ])
    }
    
    func showNetworkBadge() {
        networkConnectionContainerView.backgroundColor = Theme.Colors.primary
        networkTitleLabel.text = "You are offline"
        
        UIView.animate(withDuration: 1.2) { [weak self] in
            guard let self = self else { return }
            self.networkConnectionContainerView.alpha = 1
        }
    }
    
    func hideNetworkBadge() {
        networkConnectionContainerView.backgroundColor = Theme.Colors.success
        networkTitleLabel.text = "Connection restored"
        
        UIView.animate(withDuration: 1.2) { [weak self] in
            guard let self = self else { return }
            self.networkConnectionContainerView.alpha = 0
        }
    }
}

extension BasicViewController: BasicView {
    func showError(_ error: CommonError) {
        
        let errorTitle: String
        let errorDescription: String
        
        switch error {
        case .emptyApiKey:
            errorTitle = "Error"
            errorDescription = "You are not authorized to see this information!"
            
        case .titled(let title, let message):
            errorTitle = title
            errorDescription = message
            
        case .plain(let message):
            errorTitle = "Error"
            errorDescription = message
        }
        
        let modalData = ModalData(title: errorTitle, description: errorDescription)

        let modalController = ModalViewController()
        modalController.configureWith(modalData: modalData)
        modalController.modalPresentationStyle = .overCurrentContext
       
        guard !(tabBarController?.presentedViewController is ModalViewController) else { return }
        tabBarController?.present(modalController, animated: true)
    }
}

extension BasicViewController: NetworkCheckerDelegate {
    func networkConnection(connected: Bool, wasUnconnected: Bool) {
        if !NetworkChecker.defaults.isShowingMessage && !connected {
            let error = CommonError.titled(title: "Internet Error", message: "You're not connected!\nPlease check your connection and try again.")
            DispatchQueue.main.async { [weak self] in
                self?.showNetworkBadge()
                
                self?.showError(error)
                NetworkChecker.defaults.isShowingMessage = true
            }
            
        
        } else if connected && wasUnconnected {
            DispatchQueue.main.async { [weak self] in
                NetworkChecker.defaults.isShowingMessage = false
                self?.hideNetworkBadge()
            }
        }
    }
}
