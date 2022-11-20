//
//  RecipesPersistanceType.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol RecipesPersistanceType {
    var savedCardItems: [CardItem] { get }
    var savedRecipesDetails: [RecipeDetails] { get }
    func saveCardItem(_ item: CardItem)
    func removeItem(id: String)
    func isItemSaved(id: String) -> Bool
    func saveRecipeDetails(_ recipeDetails: RecipeDetails)
}
