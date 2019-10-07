//
//  HomeViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/13/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import FirebaseDatabase
import UIKit

import SafariServices

protocol HomeDelegate: class {
    func tableDidLoad()
}

class HomeViewController: UITableViewController {
    
    private var cellHeights: [CGFloat] = [0.0, 56.0, 120.0, 325.0, 365.0, 240.0]
    
    private var announcementData: [Announcement] = []
    private var announcementMap: [String : Announcement] = [:]
    
    private var countdownDate: Date?
    private var countdownTitle: String?
    private var countdownImage: String?
    
    private var sponsorsData: [Sponsor] = []
    
    private var moraleCupData: [MoraleTeam] = []
    private var moraleCupMap: [String : MoraleTeam] = [:]
    
    weak var delegate: HomeDelegate?
    
    private var firebaseReference: DatabaseReference?
    private var addHandle: DatabaseHandle?
    private var changeHandle: DatabaseHandle?
    private var deleteHandle: DatabaseHandle?
    private var countdownAddHandle: DatabaseHandle?
    private var countdownChangeHandle: DatabaseHandle?
    private var countdownDeleteHandle: DatabaseHandle?
    private var sponsorsAddHandle: DatabaseHandle?
    private var moraleCupAddHandle: DatabaseHandle?
    private var moraleCupChangeHandle: DatabaseHandle?
    private var moraleCupDeleteHandle: DatabaseHandle?
    
    private var GeoLocationData: [GeoLocation] = []
    private var geoLocationHandle: DatabaseHandle?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Home"
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        setUpNavigation(controller: self.navigationController, hidesBar: false)
        Analytics.logEvent("Home_Screen_Did_Appear", parameters: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Rave"), style: .plain, target: self, action: #selector(presentRave))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "qrcode"), style: .plain, target: self, action: #selector(presentScanner))
    }
    
    @objc func presentScanner() {
        performSegue(withIdentifier: "ScannerSegue", sender: self)
    }
    
    @objc func presentRave() {
        performSegue(withIdentifier: "RaveSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RaveSegue", let raveVC = segue.destination as? RaveHourViewController {
            raveVC.delegate = self as? RaveDelegate
        }
        
        if segue.identifier == "FloorPlanSegue", let ivc = segue.destination as? ImageViewController {
            ivc.setupMap()
        }
    }
    
    func setupTableView() {
        tableView.allowsSelection = true
        tableView.backgroundColor = Theme.Color.white
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let countdownCell = tableView.dequeueReusableCell(withIdentifier: CountdownTableViewCell.identifier, for: indexPath) as? CountdownTableViewCell {
                countdownCell.configureCell(with: countdownDate, title: countdownTitle, image: countdownImage)
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = countdownCell.sizeThatFits(CGSize(width: tableView.bounds.width - 40.0, height: .greatestFiniteMagnitude)).height
                }
                return countdownCell
            }
        case 1:
            if let announcementsTitleCell = tableView.dequeueReusableCell(withIdentifier: AnnouncementsTitleTableViewCell.identifier, for: indexPath) as? AnnouncementsTitleTableViewCell {
                return announcementsTitleCell
            }
        case 2:
            if let announcementCell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as? AnnouncementTableViewCell {
                announcementCell.configureCell(with: announcementData[indexPath.row])
                
                return announcementCell
            }
        case 3:
            if let moraleCupCell = tableView.dequeueReusableCell(withIdentifier: MoraleCupTableViewCell.identifier, for: indexPath) as? MoraleCupTableViewCell {
                moraleCupCell.configureCell(with: moraleCupData)
                return moraleCupCell
            }
        case 4:
            if let floorPlanCell = tableView.dequeueReusableCell(withIdentifier: FloorPlanTableViewCell.identifier, for: indexPath) as? FloorPlanTableViewCell {
                return floorPlanCell
            }
        case 5:
            if let sponsorsCell = tableView.dequeueReusableCell(withIdentifier: SponsorsTableViewCell.identifier, for: indexPath) as? SponsorsTableViewCell {
                sponsorsCell.configureCell(with: sponsorsData)
                sponsorsCell.delegate = self
                return sponsorsCell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return announcementData.count
        } else {
            return 1
        }
    }
    
    func sortAnnouncements() {
        announcementData.sort(by: {$0.timestamp ?? Date() > $1.timestamp ?? Date()})
    }
    
    // MARK: - Firebase
    
    func setupFirebase() {
        setupAnnouncementsReference()
        setupCountdownReference()
        setupSponsorsReference()
        setupMoraleCupReference()
        setupGeoLocationReference()
    }
    
    // MARK: - Announcements
    
    func setupAnnouncementsReference() {
        firebaseReference = Database.database().reference()
        addHandle = firebaseReference?.child("announcements").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            let announcement = Announcement(JSON: data)
            
            if let id = announcement?.id, let announcement = announcement {
                self.announcementMap[id] = announcement
                self.announcementData.append(announcement)
            }
            self.sortAnnouncements()
            self.tableView.reloadData()
            self.delegate?.tableDidLoad()
        })
        
        changeHandle = firebaseReference?.child("announcements").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            let announcement = Announcement(JSON: data)
            
            if let id = announcement?.id, let announcement = announcement {
                self.announcementMap.updateValue(announcement, forKey: id)
                self.announcementData = Array(self.announcementMap.values)
            }
            
            self.sortAnnouncements()
            self.tableView.reloadData()
        })
        
        deleteHandle = firebaseReference?.child("announcements").observe(.childRemoved, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            let announcement = Announcement(JSON: data)
            
            if let id = announcement?.id {
                self.announcementMap.removeValue(forKey: id)
                self.announcementData = Array(self.announcementMap.values)
            }
            
            self.sortAnnouncements()
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Countdown
    
    func setupCountdownReference() {
        firebaseReference = Database.database().reference()
        countdownAddHandle = firebaseReference?.child("countdown").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : String] else { return }
            self.countdownTitle = data["title"]
            self.countdownImage = data["image"]
            let dateString = data["date"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            self.countdownDate = dateFormatter.date(from: dateString ?? "")
            self.tableView.reloadData()
            self.delegate?.tableDidLoad()
        })

        countdownChangeHandle = firebaseReference?.child("countdown").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : String] else { return }
            self.countdownTitle = data["title"]
            self.countdownImage = data["image"]
            let dateString = data["date"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            self.countdownDate = dateFormatter.date(from: dateString ?? "")
            self.tableView.reloadData()

        })
    }
    
    // MARK: - Sponsors
    
    func setupSponsorsReference() {
        firebaseReference = Database.database().reference()
        sponsorsAddHandle = firebaseReference?.child("sponsors").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            guard let sponsor = Sponsor(JSON: data) else { return }
            self.sponsorsData.append(sponsor)
            self.tableView.reloadData()
            self.delegate?.tableDidLoad()
        })
    }
    
    // MARK: - Morale Cup
    
    func setupMoraleCupReference() {
        
        firebaseReference = Database.database().reference()
        
        moraleCupAddHandle = firebaseReference?.child("marathon").child("moraleCup").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let team = MoraleTeam(JSON: data) else { return }
            self.moraleCupData.append(team)
            self.moraleCupMap["\(team.number ?? 0)"] = team
            
            self.sortTeams()
            self.tableView.reloadData()
            
        })
        
        moraleCupChangeHandle = firebaseReference?.child("marathon").child("moraleCup").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let team = MoraleTeam(JSON: data) else { return }
            self.moraleCupMap.updateValue(team, forKey: "\(team.number ?? 0)")
            self.moraleCupData = Array(self.moraleCupMap.values)
            self.sortTeams()
            self.tableView.reloadData()
        })
        
        moraleCupDeleteHandle = firebaseReference?.child("marathon").child("moraleCup").observe(.childRemoved, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let team = MoraleTeam(JSON: data) else { return }
            self.moraleCupMap.removeValue(forKey: "\(team.number ?? 0)")
            self.moraleCupData = Array(self.moraleCupMap.values)
            self.sortTeams()
            self.tableView.reloadData()
        })
    }
    
    func sortTeams() {
        moraleCupData.sort(by: {$0.standing ?? 0 < $1.standing ?? 0})
    }

    // MARK: - GeoLocation
    
    func setupGeoLocationReference(){
        firebaseReference = Database.database().reference()
        geoLocationHandle = firebaseReference?.child(kGeoLocationTableName).observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : String] else { return }
            guard let geolocation = GeoLocation(JSON: data) else { return }
            self.GeoLocationData.append(geolocation)
            
            #warning("TODO: store these location into local storage for calling later on")
            //self.tableView.reloadData()
            //self.delegate?.tableDidLoad()
        })
    }
}

// MARK: - SponsorDelegate

extension HomeViewController: SponsorDelegate {
    
    func didSelectSponsor(item: Sponsor) {
        guard let url = URL(string: item.link ?? "") else { return }
        let svc = SFSafariViewController(url: url)
        svc.preferredControlTintColor = Theme.Color.main
        self.present(svc, animated: true, completion: nil)
    }
    
}

// MARK: RaveDelegate
extension HomeViewController: RaveDelegate {
    
    func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
