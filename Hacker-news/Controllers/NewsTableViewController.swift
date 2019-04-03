//
//  NewsTableViewController.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 01/04/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    static let maximumResponseCount = 15
    
    private let urlString = "​https://hn.algolia.com/api/v1/search"
    private let searchCategory: SearchCategory
    
    var newsViewModels = [NewsViewModel]()

    private var currentPageIndex = 0

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        indicatorView.center = view.center
        view.addSubview(indicatorView)
        indicatorView.bringSubviewToFront(view)
        return indicatorView
    }()
    
    init(searchCategory: SearchCategory) {
        self.searchCategory = searchCategory
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News for \(searchCategory.rawValue)"
        tableView.register(UINib(nibName: "SingleNewsCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        makeNetworkCallIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if newsViewModels.count == 0 {
            loadingIndicator.startAnimating()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SingleNewsCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        cell.setup(with: newsViewModels[indexPath.item], tapDelegate: self)
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SingleNewsCell.totalHeight
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewHeight = tableView.bounds.height
        let contentHeight = tableView.contentSize.height
        let currentYOffset = scrollView.contentOffset.y
        if currentYOffset >= (contentHeight - tableViewHeight) - 100 {
            makeNetworkCallIfNeeded()
        }
    }

    // MARK: - Private helper methods

    private func makeNetworkCallIfNeeded() {
        guard newsViewModels.count % NewsTableViewController.maximumResponseCount == 0,
            !NeworkRequestHelper.sharedInstance.requestInPRogress else {
            return
        }
        NeworkRequestHelper.sharedInstance.makeNetworkCall(for: searchCategory.rawValue, page: currentPageIndex) { [weak self] dataElements in
            guard let strongSelf = self else {
                return
            }

            let previousModelCount = strongSelf.newsViewModels.count

            for element in dataElements {
                guard let title = element["title"] as? String,
                    let author = element["author"] as? String,
                    let url = element["url"] as? String else {
                        print("guard else block")
                        continue
                }
                strongSelf.newsViewModels.append(NewsViewModel(title: title, author: author, url: url))

            }

            if strongSelf.newsViewModels.count > previousModelCount {
                strongSelf.currentPageIndex += 1
            }

            DispatchQueue.main.async { [weak strongSelf] in
                strongSelf?.loadingIndicator.stopAnimating()
                strongSelf?.tableView.reloadData()
            }
        }
    }

}

// SingleNewsCellTapDelegate

extension NewsTableViewController: SingleNewsCellTapDelegate {

    func cellTapped(_ model: NewsViewModel) {
        let webViewController = NewsWebViewerViewController(urlString: model.url)
        let navController = UINavigationController(rootViewController: webViewController)
        present(navController, animated: true, completion: nil)

    }
}
