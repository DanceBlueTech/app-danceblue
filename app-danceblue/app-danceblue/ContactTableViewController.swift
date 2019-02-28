//
//  ContactTableViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 11/5/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import SafariServices
import UIKit

class ContactTableViewController: UITableViewController {
    
    private var contactData: [[String]] = [["CONTACT US", Strings.Contact.general], ["FUNDRAISING", Strings.Contact.fundraising]]
    private var cellHeights: [CGFloat] = [CGFloat].init(repeating: 0, count: 3)
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.title = "Contact"
        Analytics.logEvent("Contact_Page_Did_Appear", parameters: nil)
    }
    
    func setupTableView() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
            if let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactDetailsTableViewCell.identifier, for: indexPath) as? ContactDetailsTableViewCell {
                contactCell.configureCell(title: contactData[indexPath.row][0], description: contactData[indexPath.row][1])
                contactCell.delegate = self
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = contactCell.sizeThatFits(CGSize(width: tableView.bounds.width - 40, height: .greatestFiniteMagnitude)).height
                }
                return contactCell
            }
        case 2:
            if let socialCell = tableView.dequeueReusableCell(withIdentifier: SocialMediaTableViewCell.identifier, for: indexPath) as? SocialMediaTableViewCell {
                socialCell.delegate = self
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = 96.0
                }
                return socialCell
            }
        default:
            return UITableViewCell()
        }

        return UITableViewCell()
    }
    
}

// MARK: - ContactDelegate

extension ContactTableViewController: ContactDelegate {
    
    func textView(didPresentSafariViewController url: URL) {
        if url.absoluteString.contains("networkforgood") {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            let svc = SFSafariViewController(url: url)
            svc.preferredControlTintColor = Theme.Color.main
            self.present(svc, animated: true, completion: nil)
        }
    }
    
}

// MARK: - SocialMediaDelegate

extension ContactTableViewController: SocialMediaDelegate {

    func didTapVimeo() {
        Analytics.logEvent("Vimeo_Icon_Tapped", parameters: nil)
        let url = URL(string: "https://vimeo.com/ukdanceblue")
        let svc = SFSafariViewController(url: url!)
        svc.preferredControlTintColor = Theme.Color.main
        self.present(svc, animated: true, completion: nil)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
