//
//  DirectoryVC+Search.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 14/07/2021.
//

import UIKit

extension DirectoryVC: UISearchResultsUpdating {
    
    internal func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        // Fix constraint issues to do with custom keyboards.
        searchController.searchBar.inputAssistantItem.leadingBarButtonGroups = []
        searchController.searchBar.inputAssistantItem.trailingBarButtonGroups = []
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.placeholder = "Search for a document"
 
        // When a search is active make the results table interactive.
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Dismiss the search bar when seguing to another controller.
        self.definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
   internal func updateSearchResults(for searchController: UISearchController) {
    
    print("Search Text: \(searchController.searchBar.text)")
    print("All Documents Count: \(stateController.documentController.allDocuments.count)")
        if let searchText = searchController.searchBar.text {
            stateController.documentController.filteredDocuments = searchText.isEmpty ? stateController.documentController.allDocuments : stateController.documentController.allDocuments.filter() {
                
                
                print("SEARCH STUFF")
                print($0.title)
                return $0.title!.range(of: searchText) != nil
            }
            
            print("Filter Docs Count: \(stateController.documentController.filteredDocuments.count)")
            
            tableView.reloadData()
        }
    }
    
    internal func searchState() -> SearchState {
        if searchController.searchBar.text!.isEmpty {
            return .empty
        }
        
        else if stateController.documentController.filteredDocuments.count > 0 {
            return .hasResults
        }
        
        else {
            return .noResults
        }
    }
    
    enum SearchState {
        case empty
        case hasResults
        case noResults
    }
}
