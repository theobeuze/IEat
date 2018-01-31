//
//  Step.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

class Step {
    
    var description: String?
    
    init?(json: [String: Any]) {
        guard let description = json["description"] as? String
            else {
                return nil
        }
        self.description = description
    }
}
