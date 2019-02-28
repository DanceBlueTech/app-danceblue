//
//  SponsorsTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/16/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

protocol SponsorDelegate: class {
    func didSelectSponsor(item: Sponsor)
}

class SponsorsTableViewCell: UITableViewCell {

    static let identifier = "SponsorCell"
    
    fileprivate var sponsorData: [Sponsor]? {
        didSet {
            sponsorsCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
    
    weak var delegate: SponsorDelegate?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        titleLabel.text = "SPONSORS"
        titleLabel.font = Theme.Font.header
        underlineView.backgroundColor = Theme.Color.main
    }
    
    func setupCollectionView() {
        sponsorsCollectionView.delegate = self
        sponsorsCollectionView.dataSource = self
    }
    
    func configureCell(with data: [Sponsor]) {
        setupCollectionView()
        sponsorData = data
    }
    
}

// MARK: - UICollectionViewDelegate

extension SponsorsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sponsor = sponsorData?[indexPath.row] else { return }
        delegate?.didSelectSponsor(item: sponsor)
    }
}

// MARK: - UICollectionViewDataSource

extension SponsorsTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let sponsorCell = collectionView.dequeueReusableCell(withReuseIdentifier: SponsorCollectionViewCell.identifier, for: indexPath) as? SponsorCollectionViewCell {
            guard let data = sponsorData else { return UICollectionViewCell() }
            sponsorCell.configureCell(with: data[indexPath.row])
            return sponsorCell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SponsorsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 133.0)
    }
    
}
