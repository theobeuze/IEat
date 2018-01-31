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
                    for var fav in json {
                        let newFav = Recipe()
                        if let name = fav["name"] as? String {
                            newFav.name = name
                        }
                        if let ingredients = fav["ingredients"] as? [Ingredient] {
                            newFav.ingredients = ingredients
                        }
                        if let steps = fav["steps"] as? [Step] {
                            newFav.steps = steps
                        }
                        recipes.append(newFav)
                    }
                    self?.delegate?.didFetch(recipes: recipes)
                }
            }
        }
        task.resume()
    }
}


