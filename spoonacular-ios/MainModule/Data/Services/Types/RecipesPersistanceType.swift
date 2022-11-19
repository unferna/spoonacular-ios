//
//  RecipesPersistanceType.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol RecipesPersistanceType {
    var savedCardItems: [CardItem] { get }
    func saveCardItem(_ item: CardItem)
    func removeItem(id: String)
    func isItemSaved(id: String) -> Bool
}
