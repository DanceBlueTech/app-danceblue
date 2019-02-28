//
//  FAQsTableViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/25/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import FirebaseDatabase
import UIKit

class FAQsTableViewController: UITableViewController {

    private var firebaseReference: DatabaseReference?
    private var FAQsAddHandle: DatabaseHandle?
    
    private var FAQData: [[String : String]] = [] {
        didSet {
            cellHeights = [CGFloat].init(repeating: 0, count: FAQData.count * 2)
        }
    }
    private var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.title = "FAQs"
        Analytics.logEvent("FAQs_Did_Appear", parameters: nil)
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
        return FAQData.count * 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row % 2 == 0 {
            if let questionCell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as? QuestionTableViewCell {
                questionCell.configureCell(with: FAQData[indexPath.row / 2])
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = questionCell.sizeThatFits(CGSize(width: tableView.bounds.width - 40, height: .greatestFiniteMagnitude)).height
                }
                return questionCell
            }
        } else {
            if let answerCell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as? AnswerTableViewCell {
                answerCell.configureCell(with: FAQData[indexPath.row / 2])
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = answerCell.sizeThatFits(CGSize(width: tableView.bounds.width - 40, height: .greatestFiniteMagnitude)).height
                }
                return answerCell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: - Firebase
    
    func setupFirebase() {
        
        firebaseReference = Database.database().reference()
        
        // This Week Handles
        
        FAQsAddHandle = firebaseReference?.child("FAQs").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : String]  else { return }
            self.FAQData.append(data)
            self.tableView.reloadData()
        })
    }
 

}
