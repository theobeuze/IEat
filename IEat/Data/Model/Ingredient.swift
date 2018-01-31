//
//  Ingredient.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

class Ingredient {
    
    var quantity: Int?
    var name: String?
    var picture: String?
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let quantity = json["quantity"] as? Int,
            let picture = json["picture"] as? String
            else {
                return nil
        }
        
        self.name = name
        self.quantity = quantity
        self.picture = picture
    }
}
