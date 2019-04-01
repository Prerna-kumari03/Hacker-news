//
//  SingleNewsCell.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 31/03/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import UIKit

protocol SingleNewsCellTapDelegate: class {

    func cellTapped(_ model: NewsViewModel)
}


class SingleNewsCell: UITableViewCell {

    static let titleFont = UIFont(name: ".SFUIText-Semibold", size: 20.00)
    static let authorFont = UIFont(name: ".SFUIText", size: 16.00)
    static let titleLableTopSpacing: CGFloat = 8.0
    static let authorLabelTopSpacing: CGFloat = 4.0
    static let borderTopSpacing: CGFloat = 8.0
    static let borderHeight: CGFloat = 2.0

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var borderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorLabelTopConstraint: NSLayoutConstraint!
    

    var model: NewsViewModel? = nil
    weak var tapDelegate: SingleNewsCellTapDelegate?

    static var totalHeight: CGFloat {
        let totalSpacing = titleLableTopSpacing
            + authorLabelTopSpacing
            + borderTopSpacing
            + borderHeight
        let labelsHight = (titleFont?.lineHeight ?? 0.0) + (authorFont?.lineHeight ?? 0.0)
        return totalSpacing + labelsHight
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
    }

    private func initialSetup() {
        titleLabel.font = SingleNewsCell.titleFont
        authorLabel.font = SingleNewsCell.authorFont
        titleLabelTopConstraint.constant = SingleNewsCell.titleLableTopSpacing
        authorLabelTopConstraint.constant = SingleNewsCell.authorLabelTopSpacing
        borderViewHeightConstraint.constant = SingleNewsCell.borderHeight
    }
    
    func setup(with model: NewsViewModel, tapDelegate: SingleNewsCellTapDelegate) {
        titleLabel.text = model.title
        authorLabel.text = "Author: \(model.author)"
        self.model = model
        self.tapDelegate = tapDelegate
    }
    
    @objc
    func cellTapped() {
        guard let model = model else {
            return
        }
        tapDelegate?.cellTapped(model)
    }
    
}
