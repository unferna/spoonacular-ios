//
//  RecipesPresenter.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol RecipesView: BasicView {
    func recipesCardsLoaded(_ cards: [CardItem])
}

protocol RecipeDetailsView: BasicView {
    func recipeDetailsLoaded(_ details: RecipeDetails)
}

class RecipesPresenter {
    private var listView: RecipesView?
    private var detailsView: RecipeDetailsView?
    
    init(view: RecipesView?) {
        self.listView = view
        
    }
    
    init(view: RecipeDetailsView?) {
        self.detailsView = view
    }
    
    func registerPersistanceDelegate(persistanceDelegate: ItemsPersistanceDelegate?) {
        if let persistanceDelegate = persistanceDelegate {
            RecipesDataService.shared.addPersistanceDelegate(delegate: persistanceDelegate)
        }
    }
    
    func unregisterPersistanceDelegate(persistanceDelegate: ItemsPersistanceDelegate?) {
        if let persistanceDelegate = persistanceDelegate {
            RecipesDataService.shared.removePersistanceDelegate(delegate: persistanceDelegate)
        }
    }
    
    func findRecipes(searchText: String? = nil, limit: Int = 10, savedOnly: Bool = false) {
        RecipesDataService.shared.loadRecipes(query: searchText, limit: limit, savedOnly: savedOnly) { [weak self] data, error in
            guard let data = data else {
                if let error = error {
                    self?.listView?.showError(error)
                }
                
                return
            }
            
            self?.listView?.recipesCardsLoaded(data)
        }
    }
    
    func toggleRecipe(cardItem: CardItem) {
        if cardItem.isSaved {
            RecipesDataService.shared.removeRecipe(id: cardItem.id)
            
        } else {
            RecipesDataService.shared.saveRecipe(cardItem: cardItem)
        }
    }
    
    func toggleRecipe(details: RecipeDetails) {
        if details.isSaved {
            RecipesDataService.shared.removeRecipe(id: details.id)
            
        } else {
            RecipesDataService.shared.saveRecipe(recipeDetails: details)
        }
    }
    
    func recipeDetails(of item: CardItem) {
        RecipesDataService.shared.loadRecipeDetails(id: item.id) { [weak self] details, error in
            guard let self = self else { return }
            
            guard let details = details else {
                if let error = error {
                    self.detailsView?.showError(error)
                }
                
                return
            }
            
            self.detailsView?.recipeDetailsLoaded(details)
        }
    }
}
