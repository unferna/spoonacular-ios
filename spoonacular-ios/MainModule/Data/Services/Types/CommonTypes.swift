//
//  CommonTypes.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol BasicView {
    func showError(_ error: Error?)
}

enum NetworkError: Error {
    case emptyToken
}

typealias CompletionBlock<T> = (_ data: T?, _ error: Error?) -> Void
