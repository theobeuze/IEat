//
//  FavRetriever.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

protocol FavDelegate: class {
    func didFetch(favs: [Recipe])
}

class FavRetriever {
    
    let urlString = "https://demo3877077.mockable.io/recipes"
    
    weak var delegate: FavDelegate?
    
    func getFav() {
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                let rawJSON = try? JSONSerialization.jsonObject(with: data)
                let json = rawJSON as? [[String: Any]]
                
                if let json = json {
                    var favs = [Recipe]()
                    for var fav in json {
                        let newFav = Recipe()
                        var newIngredients = [Ingredient]()
                        var newSteps = [Step]()
                        if let name = fav["name"] as? String {
                            newFav.name = name
                        }
                        for case let ingredients in fav["ingredients"] as! [[String: Any]] {
                            if let ingredient = Ingredient(json: ingredients) {
                                newIngredients.append(ingredient)
                            }
                        }
                        newFav.ingredients = newIngredients
                        for case let steps in fav["steps"] as! [[String: Any]] {
                            if let step = Step(json: steps) {
                                newSteps.append(step)
                            }
                        }
                        newFav.steps = newSteps
                        favs.append(newFav)
                    }
                    self?.delegate?.didFetch(favs: favs)
                }
            }
        }
        task.resume()
    }
}
