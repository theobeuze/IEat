//
//  ViewController.swift
//  IEat
//
//  Created by Poseidon on 31/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var ingredientListText: UITextView!
    @IBOutlet weak var stepListText: UITextView!
    
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = recipe?.name
        var ingredients = String()
        if let ingredientList = recipe?.ingredients {
            for ingredient in ingredientList {
                if let q = ingredient.quantity, let n = ingredient.name {
                    ingredients.append("- \(q)g de \(n)\n")
                }
            }
            ingredientListText.text = ingredients
        }
        var steps = String()
        if let stepList = recipe?.steps {
            for step in stepList {
                if let d = step.description {
                    steps.append("- \(d)\n")
                }
            }
            stepListText.text = steps
        }
        
    }

    

}
