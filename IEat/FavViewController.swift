//
//  SecondViewController.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

class FavViewController: UIViewController, FavDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView?
    
    let source = FavRetriever()
    var favs: [Recipe]?

    override func viewDidLoad() {
        super.viewDidLoad()
        table?.dataSource = self
       // table?.delegate = self
        source.delegate = self
        source.getFav()
    }
    
    func didFetch(favs: [Recipe]) {
        self.favs = favs
        DispatchQueue.main.sync {
            table?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = favs?[indexPath.row].name ?? ""
        return cell
    }
}

