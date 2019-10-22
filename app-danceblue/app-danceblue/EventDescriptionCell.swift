//
//  EventDescriptionCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/21/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

protocol EventDescriptionDelegate: class {
    func textView(didPresentSafariViewController url: URL)
}

class EventDescriptionCell: UITableViewCell {
    
    static let identifier = "EventDescriptionCell"
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func geoFenceCheckin(_ sender: Any) {
        print("Checking IN!!")
    }
    
    private var event: Event?
    
    weak var delegate: EventDescriptionDelegate?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        underlineView.backgroundColor = Theme.Color.main
        descriptionTextView.font = Theme.Font.body
        titleLabel.font = Theme.Font.header
        titleLabel.text = "DESCRIPTION"
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
    
    func configureCell(with event: Event) {
        self.event = event
        descriptionTextView.text = event.description ?? ""
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 8.0 + titleLabel.frame.height + 2.0 +  underlineView.frame.height + 16.0
        adjustedHeight += descriptionTextView.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height + 16.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
}

// MARK: - UITextViewDelegate

extension EventDescriptionCell: UITextViewDelegate {
    
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
