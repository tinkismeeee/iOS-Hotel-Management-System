//
//  RoomManagementViewController.swift
//  DOan
//
//  Created by DoAnhKiet on 14/03/2026.
//

import UIKit

class RoomManagementViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var roomTableView: UITableView!
    
    var roomList: [Room] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTableView.dataSource = self
        roomTableView.delegate = self
        roomTableView.rowHeight = 100
        fetchRooms()
        
    }
    func fetchRooms() {
            
            guard let url = URL(string: "http://38.242.228.108:5000/api/rooms") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Lỗi kết nối: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // Ép kiểu dữ liệu JSON lấy về thành mảng [Room]
                    let rooms = try JSONDecoder().decode([Room].self, from: data)
                    
                    // Cập nhật giao diện phải làm trên Main Thread
                    DispatchQueue.main.async {
                        self.roomList = rooms
                        self.roomTableView.reloadData() // Lệnh yêu cầu bảng vẽ lại dữ liệu
                    }
                } catch {
                    print("Lỗi giải mã JSON: \(error)")
                }
            }
            
            task.resume() // Bắt đầu chạy request
        }
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Kiểm tra đúng cái segue mình cần
            if segue.identifier == "showRoomDetail" {
                // Lấy màn hình đích
                if let detailVC = segue.destination as? RoomDetailViewController {
                    // Tìm xem người dùng vừa bấm vào hàng (row) số mấy
                    if let indexPath = roomTableView.indexPathForSelectedRow {
                        // Lấy dữ liệu phòng ở hàng đó và "bắn" sang màn hình chi tiết
                        let selectedRoom = roomList[indexPath.row]
                        detailVC.roomData = selectedRoom
                        
                        // (Tuỳ chọn) Bỏ highlight màu xám sau khi bấm
                        roomTableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }


}

// MARK: - TableView DataSource & Delegate
extension RoomManagementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // 1. Gọi cái custom cell ra và "ép kiểu" nó thành RoomTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
            
            let roomData = roomList[indexPath.row]
            
            // 2. Gán chữ vào các Label
            cell.roomNameLabel.text = "Phòng \(roomData.roomNumber) - \(roomData.roomTypeName)"
            cell.detailLabel.text = "Tầng: \(roomData.floor) | Giường: \(roomData.bedCount) | Khách: \(roomData.maxGuests)"
            
            // Định dạng giá tiền
            if let priceDouble = Double(roomData.pricePerNight) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                cell.priceLabel.text = "\(formatter.string(from: NSNumber(value: priceDouble)) ?? roomData.pricePerNight) VNĐ"
            }
            
            // 3. Xử lý cái "Nhãn trạng thái" thần thánh
            cell.statusBadgeLabel.text = " \(roomData.status.uppercased()) " // Thêm dấu cách 2 bên cho nó mập mạp
            
            // Tô màu nền tùy theo trạng thái (Booked = Đỏ, Available = Xanh, Còn lại = Xám)
            switch roomData.status.lowercased() {
            case "booked":
                cell.statusBadgeLabel.backgroundColor = .systemRed
            case "available":
                cell.statusBadgeLabel.backgroundColor = .systemGreen
            default:
                cell.statusBadgeLabel.backgroundColor = .systemGray
            }
            
            return cell
        }
}
