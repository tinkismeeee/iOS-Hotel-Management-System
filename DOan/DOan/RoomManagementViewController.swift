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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        
        let roomData = roomList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        // Dòng chữ chính: Ví dụ "Phòng 101 - Family"
        content.text = "Phòng \(roomData.roomNumber) - \(roomData.roomTypeName)"
        
        // Dòng chữ phụ: Trạng thái và Giá tiền
        content.secondaryText = "Trạng thái: \(roomData.status.uppercased()) | Giá: \(roomData.pricePerNight) VNĐ"
        
        cell.contentConfiguration = content
        return cell
    }
}
