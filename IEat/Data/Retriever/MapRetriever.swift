//
//  MapRetriever.swift
//  IEat
//
//  Created by Poseidon on 31/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//
//

import UIKit

protocol MapDelegate: class {
    func didFetch(shops: [Shop])
}

class MapRetriever {
    
    let urlBase = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    weak var delegate: MapDelegate?
    
    func getShop(latitude: Double, longitude: Double) {
        var urlString: String = ""
        urlString.append(urlBase)
        urlString.append("?location=\(latitude),\(longitude)&radius=10000&type=grocery_or_supermarket&key=")
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                let rawJSON = try? JSONSerialization.jsonObject(with: data)
                let json = rawJSON as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    var shops = [Shop]()
                    for var shop in results {
                        let newShop = Shop()
                        if let name = shop["name"] as? String {
                            newShop.title = name
                        }
                        if let geometry = shop["geometry"] as? [String: Any] {
                            newShop.geometry = Geometry(json: geometry)
                        }
                        if let icon = shop["icon"] as? String {
                            newShop.icon = icon
                        }
                        shops.append(newShop)
                    }
                    self?.delegate?.didFetch(shops: shops)
                } else {
                    assertionFailure()
                }
            }
        }
        task.resume()
    }
}





