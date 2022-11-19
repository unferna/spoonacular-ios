//
//  RecipeDetails.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

struct RecipeDetails: Codable {
    var id: String
    var title: String?
    var image: String?
    var isSaved = false
    var cookingTime: Int?
    var summary: String?
    var ingredients: [String] = []
    var instructions: [RecipeDetailsInstructionStep] = []
}

struct RecipeDetailsInstructionStep: Codable {
    var number: Int
    var step: String
}
