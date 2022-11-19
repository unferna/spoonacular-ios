//
//  RecipesDataService.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

class RecipesDataService {
    private var dataSource: RecipesDataServiceType?
    static let shared = RecipesDataService()
    
    private init() {}
    
    func initialize(dataSource: RecipesDataServiceType?) {
        self.dataSource = dataSource
    }
    
    private func validateDataSource() {
        if dataSource == nil {
            print("Data source was not initialized")
        }
    }
    
    func loadRecipes(limit: Int, result: @escaping CompletionBlock<[CardItem]>) {
        validateDataSource()
        dataSource?.loadRecipes(limit: limit, result: result)
    }
}
