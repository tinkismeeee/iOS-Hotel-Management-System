//
//  ServiceTableViewCell.swift
//  DOan
//
//  Created by DoAnhKiet on 28/03/2026.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusBadgeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusBadgeLabel.layer.cornerRadius = 8
        statusBadgeLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
