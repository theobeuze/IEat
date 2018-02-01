//
//  FirstViewController.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, RecipesDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var table: UITableView?
    
    let source = RecipesRetriever()
    var recipes: [Recipe]?
    var recipesDictionary = [String: [String]]()
    var recipesSectionTitles = [String]()
    var serachingArray: [String]!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRecipes = [Recipe]()
    var test = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.dataSource = self
        source.delegate = self
        source.getRecipes()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.pushCreateButton))
    }
    
    func didFetch(recipes: [Recipe]) {
        for recipe in recipes {
            let recipeKey = String(recipe.name!.prefix(1))
            if var recipeValues = recipesDictionary[recipeKey] {
                recipeValues.append(recipe.name!)
                recipesDictionary[recipeKey] = recipeValues
            } else {
                recipesDictionary[recipeKey] = [recipe.name!]
            }
            test.append(recipe)
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
        if isFiltering() {
            return filteredRecipes.count
        } else {
            return (recipesDictionary[recipeKey]?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let recipeKey = recipesSectionTitles[indexPath.section]
        let recipe: Recipe
        
        if isFiltering() {
            recipe = filteredRecipes[indexPath.row]
            cell.textLabel?.text = recipe.name
        } else {
            cell.textLabel?.text = recipesDictionary[recipeKey]?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipesSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return recipesSectionTitles
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRecipes = test.filter({( recipe : Recipe) -> Bool in
            return recipe.name!.contains(searchText)
        })
        table?.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @objc func pushCreateButton() {
        performSegue(withIdentifier: "CreateRecipe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CreateRecipe") {
            let secondController = segue.destination as! CreateRecipeController
        }
    }


}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

