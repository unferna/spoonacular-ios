//
//  RecipesDataService.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

class RecipesDataService {
    private var dataSource: RecipesDataServiceType?
    private var itemsPersistance: RecipesPersistanceType?
    static let shared = RecipesDataService()
    
    private init() {}
    
    func initialize(dataSource: RecipesDataServiceType?) {
        self.dataSource = dataSource
    }
    
    func initialize(itemsPersistance: RecipesPersistanceType?) {
        self.itemsPersistance = itemsPersistance
    }
    
    private func validateDataSource() {
        if dataSource == nil {
            print("Data source was not initialized")
        }
    }
    
    func loadRecipes(query: String?, limit: Int, result: @escaping CompletionBlock<[CardItem]>) {
        validateDataSource()
        dataSource?.loadRecipes(query: query, limit: limit) { [weak self] items, error in
            guard let self = self, let items = items else {
                result(nil, error)
                return
            }
            
            let newItemCollection = items.map { cardItem in
                var item = cardItem
                item.isSaved = self.itemsPersistance?.isItemSaved(id: item.id) ?? false
                
                return item
            }
            
            result(newItemCollection, error)
        }
    }
    
    func loadRecipeDetails(id: String) {
        validateDataSource()
        
        dataSource?.loadRecipeDetails(id: id) { details, error in }
    }
    
    func saveRecipe(cardItem: CardItem) {
        itemsPersistance?.saveCardItem(cardItem)
    }
    
    func removeRecipe(id: String) {
        itemsPersistance?.removeItem(id: id)
    }
}
