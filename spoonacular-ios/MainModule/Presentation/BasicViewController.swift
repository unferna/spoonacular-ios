//
//  BasicViewController.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import UIKit

class BasicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func setupSubviews() { }
    
    func commonInit() {
        setupSubviews()
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
        tabBarController?.present(modalController, animated: true)
    }
}
