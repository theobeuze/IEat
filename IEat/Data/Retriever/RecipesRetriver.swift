//
//  ReceipesRetriver.swift
//  IEat
//
//  Created by etudiant on 31/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

protocol RecipesDelegate: class {
    func didFetch(recipes: [Recipe])
}

class RecipesRetriever {
    
    let urlString = "https://demo3877077.mockable.io/recipes"
    
    weak var delegate: RecipesDelegate?
    
    func getRecipes() {
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                let rawJSON = try? JSONSerialization.jsonObject(with: data)
                let json = rawJSON as? [[String: Any]]
                
                if let json = json {
                    var recipes = [Recipe]()
                    for var recipe in json {
                        let newRecipe = Recipe()
                        var newIngredients = [Ingredient]()
                        var newSteps = [Step]()
                        if let name = recipe["name"] as? String {
                            newRecipe.name = name
                        }
                        for case let ingredients in recipe["ingredients"] as! [[String: Any]] {
                            if let ingredient = Ingredient(json: ingredients) {
                                newIngredients.append(ingredient)
                            }
                        }
                        newRecipe.ingredients = newIngredients
                        for case let steps in recipe["steps"] as! [[String: Any]] {
                            if let step = Step(json: steps) {
                                newSteps.append(step)
                            }
                        }
                        newRecipe.steps = newSteps
                        recipes.append(newRecipe)
                    }
                    self?.delegate?.didFetch(recipes: recipes)
                }
            }
        }
        task.resume()
    }
}


