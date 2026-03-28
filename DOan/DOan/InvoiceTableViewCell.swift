//
//  InvoiceTableViewCell.swift
//  DOan
//
//  Created by DoAnhKiet on 28/03/2026.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
