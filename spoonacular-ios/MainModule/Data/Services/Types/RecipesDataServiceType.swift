//
//  RecipesDataServiceType.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

protocol RecipesDataServiceType: AnyObject {
    func loadRecipes(query: String?, limit: Int, result: @escaping CompletionBlock<[CardItem]>)
}
