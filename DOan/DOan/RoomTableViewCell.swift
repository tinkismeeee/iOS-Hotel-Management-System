//
//  RoomTableViewCell.swift
//  DOan
//
//  Created by DoAnhKiet on 28/03/2026.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    // Các Outlets của bạn (nhớ kiểm tra xem tên có khớp với lúc bạn kéo thả không nhé)
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusBadgeLabel: UILabel!

    // Chỉ giữ duy nhất MỘT hàm awakeFromNib() này
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Bo góc cho nhãn trạng thái
        statusBadgeLabel.layer.cornerRadius = 8
        statusBadgeLabel.layer.masksToBounds = true
    }

    // Hàm này Xcode tự động sinh ra, bạn cứ để nguyên không sao cả
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
