//
//  ContactDetailsTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 11/5/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

protocol ContactDelegate: class {
    func textView(didPresentSafariViewController url: URL)
}

class ContactDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "ContactDetailsCell"
    
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    weak var delegate: ContactDelegate?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = Theme.Font.header
        descriptionTextView.font = Theme.Font.body
        setupTextView()
    }
    
    func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.dataDetectorTypes = [.link]
        descriptionTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: Theme.Color.main])
        descriptionTextView.isSelectable = true
        descriptionTextView.isEditable = false
        descriptionTextView.tintColor = Theme.Color.main
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    func configureCell(title: String, description: String) {
        titleLabel.text = title
        descriptionTextView.text = description
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 8.0 + titleLabel.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude)).height + 16.0 + descriptionTextView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude)).height + 8.0)
    }
    
}

// MARK: - UITextViewDelegate

extension ContactDetailsTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString.contains("mailto:") {
            return true
        }
        
        delegate?.textView(didPresentSafariViewController: URL)
        return false
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
