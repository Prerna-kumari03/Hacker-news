//
//  ViewController.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 01/04/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import UIKit

enum SearchCategory: String {
    case sports = "sports"
    case bollywood = "bollywood"
    case politics = "politics"
    case art = "art"
}

class ViewController: UIViewController {
    
    var searchCategory: SearchCategory = .sports

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }

    @IBAction func artsButtonTapped(_ sender: Any) {
        searchCategory = .art
        pushNewsTableViewController()
    }
    
    @IBAction func bollywoodButtonTapped(_ sender: Any) {
        searchCategory = .bollywood
        pushNewsTableViewController()
    }
    
    @IBAction func politicsButtonTapped(_ sender: Any) {
        searchCategory = .politics
        pushNewsTableViewController()
    }

    @IBAction func sportsButtonTapped(_ sender: Any) {
        searchCategory = .sports
        pushNewsTableViewController()
    }
    
    private func pushNewsTableViewController() {
        navigationController?.pushViewController(NewsTableViewController(searchCategory: searchCategory), animated: true)
    }
    
}

