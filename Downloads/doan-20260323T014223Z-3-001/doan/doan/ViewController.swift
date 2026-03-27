//
//  ViewController.swift
//  doan
//
//  Created by umtlab03im02 on 02/03/2026.
//

import UIKit

struct DashboardItem {
    let title: String
    let segueIdentifier: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    private let items: [DashboardItem] = [
        DashboardItem(title: "Quản lí nhân viên", segueIdentifier: "showStaff"),
        DashboardItem(title: "Quản lí khách hàng", segueIdentifier: "showCustomer"),
        DashboardItem(title: "Quản lí loại phòng", segueIdentifier: "showRoomTypes"),
        DashboardItem(title: "Quản lí phòng chi tiết", segueIdentifier: "showRooms"),
        DashboardItem(title: "Quản lí dịch vụ", segueIdentifier: "showServices"),
        DashboardItem(title: "Quản lí mã giảm giá", segueIdentifier: "showPromotions"),
        DashboardItem(title: "Quản lí doanh thu", segueIdentifier: "showInvoices"),
        DashboardItem(title: "Đăng xuất", segueIdentifier: "logout")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }

    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        cell.contentConfiguration = config
        cell.accessoryType = item.segueIdentifier == "logout" ? .none : .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]

        if item.segueIdentifier == "logout" {
            showLogoutAlert()
            return
        }

        performSegue(withIdentifier: item.segueIdentifier, sender: self)
    }

    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc muốn đăng xuất không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive) { _ in
            // TODO: Thêm logic đăng xuất nếu cần
        })
        present(alert, animated: true)
    }
}

