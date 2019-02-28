//
//  BodyTextTableViewCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/1/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit

protocol BodyTextTableViewDelegate: class {
    func textView(didPresentSafariViewController url: URL)
}

class BodyTextTableViewCell: UITableViewCell {

    static let identifier = "BodyTextCell"

    @IBOutlet weak var bodyTextView: UITextView!
    
    private var data: BCBodyText?
    
    weak var delegate: BodyTextTableViewDelegate?
    
    // MARK: - Initialization
    
    func configureCell(with data: BCBodyText) {
        self.data = data
        setupViews()
    }
    
    func setupViews() {
        guard let text = data?.bodyText else { return }
        bodyTextView.delegate = self
        bodyTextView.dataDetectorTypes = [.link]
        bodyTextView.attributedText = NSAttributedString.stringFromHtml(text)
        bodyTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: Theme.Color.main])
        bodyTextView.isSelectable = true
        bodyTextView.isEditable = false
        bodyTextView.tintColor = Theme.Color.main
        bodyTextView.textContainerInset = .zero
        bodyTextView.contentInset = .zero
        bodyTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let adjustedHeight = 24.0 + bodyTextView.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
}

// MARK: - UITextViewDelegate

extension BodyTextTableViewCell: UITextViewDelegate {
    
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
