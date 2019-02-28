//
//  BlogDetailsViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/1/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import SafariServices
import UIKit

class BlogDetailsTableViewController: UITableViewController {

    var post: Blog?
    var chunks: [BCData]? {
        didSet {
            cellHeights = [CGFloat].init(repeating: 0, count: chunks?.count ?? 0)
        }
    }
    var shareImage: UIImage?
    var cellHeights: [CGFloat] = []

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        chunks = post?.chunks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        if navigationController?.isNavigationBarHidden ?? false {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        setUpNavigation(controller: navigationController, hidesBar: false)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        Analytics.logEvent("Blog_Post_Did_Appear", parameters: ["Title" : post?.details?.title ?? ""])
    }
    
    func setupTableView() {
        tableView.backgroundColor = Theme.Color.white
    }
    
    func share() {
        // TODO: Dynamic Links and sharing capability
        // Right now just an image
        
        let avc = UIActivityViewController(activityItems: ["Checkout this article on the DanceBlue Mobile App!", shareImage as Any], applicationActivities: [])
        present(avc, animated:  true)
    }
    
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bodyChunk = chunks?[indexPath.row] else { return UITableViewCell() }
        let type = bodyChunk.type
        
        switch type {
            case .headerImage:
                if let imageCell = tableView.dequeueReusableCell(withIdentifier: HeaderImageTableViewCell.identifier) as? HeaderImageTableViewCell {
                    guard let data = bodyChunk.headerData else { return UITableViewCell() }
                    imageCell.configureCell(with: data)
                    cellHeights[indexPath.row] = imageCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    return imageCell
                }
            
            case .details:
                if let detailsCell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as? DetailsTableViewCell {
                    guard let data = bodyChunk.detailsData else { return UITableViewCell() }
                    detailsCell.configureCell(with: data)
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = detailsCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    
                    return detailsCell
                }
            
            case .quote:
                if let quoteCell = tableView.dequeueReusableCell(withIdentifier: QuoteTableViewCell.identifier) as? QuoteTableViewCell {
                    guard let data = bodyChunk.quoteData else { return UITableViewCell() }
                    quoteCell.configureCell(with: data)
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = quoteCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    return quoteCell
                }
            
            case .bodyImage:
                if let bodyImageCell = tableView.dequeueReusableCell(withIdentifier: BodyImageTableViewCell.identifier) as? BodyImageTableViewCell {
                    guard let data = bodyChunk.bodyImageData else { return UITableViewCell() }
                    bodyImageCell.configureCell(with: data)
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = bodyImageCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    return bodyImageCell
                }
            
            case .bodyText:
                if let bodyTextCell = tableView.dequeueReusableCell(withIdentifier: BodyTextTableViewCell.identifier) as? BodyTextTableViewCell {
                    guard let data = bodyChunk.bodyTextData else { return UITableViewCell() }
                    bodyTextCell.configureCell(with: data)
                    bodyTextCell.delegate = self
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = bodyTextCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    return bodyTextCell
                }
            case .sectionTitle:
                if let sectionTitleCell = tableView.dequeueReusableCell(withIdentifier: SectionTitleTableViewCell.identifier) as? SectionTitleTableViewCell {
                    guard let data = bodyChunk.sectionTitleData else { return UITableViewCell() }
                    sectionTitleCell.configureCell(with: data)
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = sectionTitleCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    return sectionTitleCell
                }
        }
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chunks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    
    
}

// MARK: - BodyTextTableViewDelegate

extension BlogDetailsTableViewController: BodyTextTableViewDelegate {
    
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
