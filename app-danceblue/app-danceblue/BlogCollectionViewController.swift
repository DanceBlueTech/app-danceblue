//
//  BlogCollectionViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/31/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import FirebaseDatabase
import UIKit

class BlogCollectionViewController: UICollectionViewController {

    private var firebaseReference: DatabaseReference?
    private var blogAddHandle: DatabaseHandle?
    private var blogChangeHandle: DatabaseHandle?
    private var blogDeleteHandle: DatabaseHandle?
        
    @IBOutlet var blogCollectionView: UICollectionView!
    
    private var blogData: [Blog] = []
    private var blogMap: [String : Blog] = [:]
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogCollectionView.delegate = self
        blogCollectionView.allowsSelection = true
        blogCollectionView.contentInset = .init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        blogCollectionView.alwaysBounceVertical = true
        setupRefreshControl()
        setupFirebase()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.Color.black
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        blogCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshTable() {
        blogCollectionView.refreshControl?.beginRefreshing()
        blogCollectionView.reloadData()
        
        // Since the database is realtime, reloading isn't necessary. However, while testing
        // users enjoy being able to check for updates by pulling down and seeing the loading
        // indicator for a second or two.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.blogCollectionView.refreshControl?.endRefreshing()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.title = "Blog"
        blogCollectionView.reloadData()
        Analytics.logEvent("Blog_List_Did_Appear", parameters: nil)
    }
    
    // MARK: - Storyboard
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeaturedSegue" {
            if let destination = segue.destination as? BlogDetailsTableViewController,!blogData.isEmpty {
                destination.post = blogData[0]
            }
        } else if segue.identifier == "BlogSegue" {
            if let destination = segue.destination as? BlogDetailsTableViewController, let cell = sender as? BlogVerticalCollectionViewCell, let indexPath = self.blogCollectionView.indexPath(for: cell) {
                if blogData.count > indexPath.row + 1 {
                  destination.post = blogData[indexPath.row + 1]
                }
            }
            
            if let destination = segue.destination as? BlogDetailsTableViewController, let cell = sender as? BlogHorizontalCollectionViewCell, let indexPath = self.blogCollectionView.indexPath(for: cell) {
                if blogData.count > indexPath.row + 1 {
                    destination.post = blogData[indexPath.row + 1]
                }
            }
        }
    }

    // MARK: - Firebase
        
    func setupFirebase() {
        firebaseReference = Database.database().reference()
        
        blogAddHandle = firebaseReference?.child("blog").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let post = Blog(JSON: data) else { return }
            self.blogMap[post.id ?? ""] = post
            self.blogData.append(post)
            self.sortPosts()
            self.blogCollectionView.reloadData()
        })
        
        blogChangeHandle = firebaseReference?.child("blog").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let post = Blog(JSON: data) else { return }
            self.blogMap.updateValue(post, forKey: "\(post.id!)")
            self.blogData = Array(self.blogMap.values)
            self.sortPosts()
            self.blogCollectionView.reloadData()
        })
        
        blogDeleteHandle = firebaseReference?.child("blog").observe(.childRemoved, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let post = Blog(JSON: data) else { return }
            self.blogMap.removeValue(forKey: post.id!)
            self.blogData = Array(self.blogMap.values)
            self.sortPosts()
            self.blogCollectionView.reloadData()
        })
    }


    // MARK: UICollectionView Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if blogData.count > 1 {
                return blogData.count - 1
            }
            else {
                return 0
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let featuredCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as? FeaturedCollectionViewCell else
            { return FeaturedCollectionViewCell() }
            if !blogData.isEmpty {
                guard let details = blogData[0].details else { return UICollectionViewCell() }
                featuredCell.configureCell(with: details)
            }
            return featuredCell
            
        } else {
            if indexPath.row > 3 {
                guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogHorizontalCollectionViewCell.identifier, for: indexPath) as? BlogHorizontalCollectionViewCell else
                { return BlogHorizontalCollectionViewCell() }
                if blogData.count > indexPath.row + 1 {
                    guard let details = blogData[indexPath.row + 1].details else { return UICollectionViewCell() }
                    postCell.configureCell(with: details)
                    return postCell
                } else {
                    return BlogHorizontalCollectionViewCell()
                }
            } else {
                guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogVerticalCollectionViewCell.identifier, for: indexPath) as? BlogVerticalCollectionViewCell else
                { return BlogVerticalCollectionViewCell() }
                if blogData.count > indexPath.row + 1 {
                    guard let details = blogData[indexPath.row + 1].details else { return UICollectionViewCell() }
                    postCell.configureCell(with: details)
                    return postCell
                } else {
                    return BlogHorizontalCollectionViewCell()
                }
            }
        }
    }
    
    // MARK: - Utility
    
    func sortPosts() {
        blogData.sort(by: {
            guard let details1 = $0.details, let details2 = $1.details else { return true }
            return details1.timestamp ?? Date() > details2.timestamp ?? Date()
            })
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BlogCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.bounds.width, height: 448.0)
        } else {
            if indexPath.row > 3 {
                return CGSize(width: self.view.bounds.width - 40, height: 112.0)
            } else {
                return CGSize(width: self.view.bounds.width / 2 - 30, height: 216.0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        } else {
            return UIEdgeInsets(top: 8, left: 20, bottom: 20, right: 20)
        }
    }
    
}
