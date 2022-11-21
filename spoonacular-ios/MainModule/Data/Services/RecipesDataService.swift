//
//  RecipesDataService.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol ItemsPersistanceDelegate: AnyObject {
    func didItemSave(id: String)
    func didItemRemove(id: String)
}

class RecipesDataService {
    private var dataSource: RecipesDataServiceType?
    private var itemsPersistance: RecipesPersistanceType?
    static let shared = RecipesDataService()
    
    private var persistanceDelegates = MulticastDelegate<ItemsPersistanceDelegate>()
    
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
    
    func loadRecipes(query: String?, limit: Int, savedOnly: Bool, result: @escaping CompletionBlock<[CardItem]>) {
        validateDataSource()
        
        if savedOnly {
            guard let items = itemsPersistance?.savedCardItems else {
                result(nil, CommonError.plain(message: "No saved recipes found"))
                return
            }
            
            result(items, nil)
            
        } else {
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
    }
    
    func loadRecipeDetails(id: String, result: @escaping CompletionBlock<RecipeDetails>) {
        validateDataSource()
        dataSource?.loadRecipeDetails(id: id) { [weak self] details, error in
            guard let self = self, var details = details else {
                result(nil, error)
                return
            }
            
            details.isSaved = self.itemsPersistance?.isItemSaved(id: details.id) ?? false
            result(details, error)
        }
    }
    
    func saveRecipe(cardItem: CardItem) {
        itemsPersistance?.saveCardItem(cardItem)
        loadRecipeDetails(id: cardItem.id) { [weak self] details, error in
            guard let self = self, let details = details else { return }
            self.itemsPersistance?.saveRecipeDetails(details)
        }
        
        persistanceDelegates.invokeDelegates {
            $0.didItemSave(id: cardItem.id)
        }
    }
    
    func saveRecipe(recipeDetails: RecipeDetails) {
        itemsPersistance?.saveRecipeDetails(recipeDetails)
        persistanceDelegates.invokeDelegates {
            $0.didItemSave(id: recipeDetails.id)
        }
    }
    
    func removeRecipe(id: String) {
        itemsPersistance?.removeItem(id: id)
        persistanceDelegates.invokeDelegates {
            $0.didItemRemove(id: id)
        }
    }
    
    func addPersistanceDelegate(delegate: ItemsPersistanceDelegate) {
        persistanceDelegates.addDelegate(delegate)
    }
    
    func removePersistanceDelegate(delegate: ItemsPersistanceDelegate) {
        persistanceDelegates.removeDelegate(delegate)
    }
}
