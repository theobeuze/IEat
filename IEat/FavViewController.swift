//
//  SecondViewController.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

class FavViewController: UIViewController, FavDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView?
    
    var refreshControl: UIRefreshControl!
    
    let source = FavRetriever()
    var favs: [Recipe]?
    var orderedFavs = [Recipe]()
    var recipesDictionary = [String: [Recipe]]()
    var recipesSectionTitles = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        table?.dataSource = self
        table?.delegate = self
        source.delegate = self
        source.getFav()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        table?.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        orderedFavs.removeAll()
        recipesDictionary.removeAll()
        source.getFav()
        refreshControl.endRefreshing()
    }
    
    func didFetch(favs: [Recipe]) {
        for fav in favs {
            let recipeKey = String(fav.name!.prefix(1))
            if var recipeValues = recipesDictionary[recipeKey] {
                recipeValues.append(fav)
                recipesDictionary[recipeKey] = recipeValues
            } else {
                recipesDictionary[recipeKey] = [fav]
            }
            orderedFavs.append(fav)
        }
        
        recipesSectionTitles = [String](recipesDictionary.keys)
        recipesSectionTitles = recipesSectionTitles.sorted(by: { $0 < $1 })
    
        DispatchQueue.main.sync {
            table?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipesSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recipeKey = recipesSectionTitles[section]
        return (recipesDictionary[recipeKey]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let recipeKey = recipesSectionTitles[indexPath.section]
        cell.textLabel?.text = recipesDictionary[recipeKey]?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipesSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return recipesSectionTitles
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeKey = recipesSectionTitles[indexPath.section]
        self.performSegue(withIdentifier: "FavToDetail", sender: recipesDictionary[recipeKey]?[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavToDetail" {
            let destinationVC = segue.destination as? DetailViewController
            let fav = sender as? Recipe
            destinationVC?.recipe = fav
        }
    }
}

