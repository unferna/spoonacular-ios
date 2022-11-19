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

class RecipesPresenter {
    private var view: RecipesView?
    
    init(view: RecipesView?) {
        self.view = view
    }
    
    func findRecipes(searchText: String? = nil, limit: Int = 10) {
        RecipesDataService.shared.loadRecipes(query: searchText, limit: limit) { [weak self] data, error in
            guard let data = data else {
                self?.view?.showError(error)
                return
            }
            
            self?.view?.recipesCardsLoaded(data)
        }
    }
    
    func toggleRecipe(cardItem: CardItem) {
        if cardItem.isSaved {
            RecipesDataService.shared.removeRecipe(id: cardItem.id)
            
        } else {
            RecipesDataService.shared.saveRecipe(cardItem: cardItem)
        }
    }
    
    func recipeDetails(of item: CardItem) {
        RecipesDataService.shared.loadRecipeDetails(id: item.id)
    }
}
