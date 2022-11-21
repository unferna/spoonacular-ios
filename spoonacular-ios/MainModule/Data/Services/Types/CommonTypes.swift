//
//  CommonTypes.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol BasicView {
    func showError(_ error: CommonError)
}

enum CommonError: Error {
    case emptyApiKey
    case titled(title: String, message: String)
    case plain(message: String)
}

typealias CompletionBlock<T> = (_ data: T?, _ error: CommonError?) -> Void
