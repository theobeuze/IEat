//
//  FirstViewController.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, RecipesDelegate, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet var table: UITableView?
    
    let source = RecipesRetriever()
    var recipes: [Recipe]?
    var recipesDictionary = [String: [Recipe]]()
    var recipesSectionTitles = [String]()
    var serachingArray: [String]!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRecipes = [Recipe]()
    var test = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.dataSource = self
        table?.delegate = self
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
                recipeValues.append(recipe)
                recipesDictionary[recipeKey] = recipeValues
            } else {
                recipesDictionary[recipeKey] = [recipe]
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
        if isFiltering() {
            return 1
        } else {
            return recipesSectionTitles.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredRecipes.count
        } else {
            let recipeKey = recipesSectionTitles[section]
            return (recipesDictionary[recipeKey]?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let recipe: Recipe
        
        if isFiltering() {
            recipe = filteredRecipes[indexPath.row]
            cell.textLabel?.text = recipe.name
        } else {
            let recipeKey = recipesSectionTitles[indexPath.section]
            cell.textLabel?.text = recipesDictionary[recipeKey]?[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         if isFiltering() {
            return nil
        } else {
            return recipesSectionTitles[section]
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering() {
            return nil
        } else {
            return recipesSectionTitles
        }
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
            _ = segue.destination as! CreateRecipeController
        }
        if segue.identifier == "homeToDetail" {
            let destinationVC = segue.destination as? DetailViewController
            let recipe = sender as? Recipe
            destinationVC?.recipe = recipe
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            let recipe = filteredRecipes[indexPath.row]
            self.performSegue(withIdentifier: "homeToDetail", sender: recipe)
        } else {
            let recipeKey = recipesSectionTitles[indexPath.section]
            self.performSegue(withIdentifier: "homeToDetail", sender: recipesDictionary[recipeKey]?[indexPath.row])
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

