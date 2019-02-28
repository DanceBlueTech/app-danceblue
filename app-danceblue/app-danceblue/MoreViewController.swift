//
//  MoreViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/20/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import UIKit

class MoreViewController: UITableViewController {

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.title = "More"
        Analytics.logEvent("More_Page_Did_Appear", parameters: nil)
    }

    func setupTableView() {
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let donateCell = tableView.dequeueReusableCell(withIdentifier: DonateTableViewCell.identifier, for: indexPath) as? DonateTableViewCell {
                return donateCell
            }
        case 1:
            if let faqCell = tableView.dequeueReusableCell(withIdentifier: FAQsTableViewCell.identifier, for: indexPath) as? FAQsTableViewCell {
                return faqCell
            }
        case 2:
            if let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell {
                return contactCell
            }
        case 3:
            if let donateCell = tableView.dequeueReusableCell(withIdentifier: DonateTableViewCell.identifier, for: indexPath) as? DonateTableViewCell {
                return donateCell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        if indexPath.row == 0 {
            if let url = URL(string: "https://danceblue.networkforgood.com") {
                Analytics.logEvent("Donate_Tapped", parameters: nil)
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
