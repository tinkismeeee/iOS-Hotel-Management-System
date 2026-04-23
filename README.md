# Hotel Management System

## Giới thiệu

**Hotel Management System** là một ứng dụng iOS được xây dựng bằng **Swift + UIKit** nhằm hỗ trợ quy trình quản lý khách sạn trên thiết bị di động. Dự án tập trung vào ba nhóm người dùng chính:

- **Khách hàng**: đăng ký, đăng nhập, xem danh sách phòng, đặt phòng, áp dụng mã giảm giá, thanh toán qua QR, xem lịch sử đặt phòng và quản lý hồ sơ cá nhân.
- **Nhân viên**: đăng nhập theo vai trò nhân viên và truy cập khu vực điều hướng riêng.
- **Quản trị viên**: theo dõi dashboard và quản lý các thực thể quan trọng như nhân viên, khách hàng, phòng, loại phòng, dịch vụ, khuyến mãi, hóa đơn và doanh thu.

---

## Mục tiêu của project

Project được phát triển nhằm số hóa các tác vụ phổ biến trong vận hành khách sạn, bao gồm:

- Quản lý tài khoản người dùng và xác thực.
- Hiển thị danh sách phòng và thông tin chi tiết phòng.
- Hỗ trợ quy trình đặt phòng từ chọn phòng đến thanh toán.
- Quản lý lịch sử đặt phòng và thông tin hóa đơn.
- Quản trị dữ liệu khách sạn cho admin.
- Tăng trải nghiệm người dùng bằng hình ảnh phòng, giao diện trực quan và một số tiện ích như định vị, thông báo cục bộ và mã QR thanh toán.

---

## Công nghệ sử dụng

### Ngôn ngữ và nền tảng
- **Swift**

### Thư viện bên thứ ba
- **Alamofire**.
- **Kingfisher**

---

## Chức năng chính

## 1. Xác thực và tài khoản
Ứng dụng cung cấp các luồng xác thực cơ bản:

- **Đăng ký tài khoản** với các thông tin như tên, email, số điện thoại, username, mật khẩu, địa chỉ, ngày sinh.
- **Đăng nhập** cho người dùng thông thường.
- **Phân quyền** theo vai trò:
  - `admin/admin` sẽ vào khu vực quản trị.
  - Email thuộc danh sách nhân viên sẽ vào khu vực nhân viên.
  - Người dùng còn lại sẽ đi theo luồng khách hàng.
- **Quên mật khẩu** thông qua kiểm tra email và cập nhật mật khẩu mới.
- **OTP xác thực** qua một dịch vụ riêng để xác minh người dùng trong một số luồng đăng nhập/xác thực.

---

## 2. Khám phá phòng và đặt phòng
Người dùng có thể:

- Xem danh sách phòng từ API.
- Lọc phòng theo loại: **Standard**, **Family**, **Deluxe**, **Business**.
- Xem thông tin chi tiết của từng phòng như:
  - số phòng
  - tầng
  - loại phòng
  - số khách tối đa
  - số giường
  - mô tả
  - giá theo đêm
- Hiển thị ảnh phòng bằng cách lấy ảnh động từ Unsplash.
- Chọn ngày nhận/trả phòng và các dịch vụ đi kèm.
- Tính giá tiền, VAT, ưu đãi và tổng tiền tại màn hình checkout.
- Tạo booking sau khi thanh toán thành công.

---

## 3. Thanh toán và xác nhận booking
Luồng thanh toán hiện tại được xây dựng theo hướng đơn giản:

- Sinh **QR thanh toán** thông qua dịch vụ VietQR.
- Mở QR trên `WKWebView` để người dùng thực hiện thanh toán.
- Khi nhấn xác nhận đã thanh toán, app sẽ gọi API tạo booking.
- Sau khi đặt phòng thành công, hệ thống hiển thị thông báo local.

---

## 4. Khuyến mãi và ưu đãi
Ứng dụng có module làm việc với danh sách khuyến mãi:

- Lấy danh sách promotion từ API.
- Cho phép người dùng nhập mã giảm giá trong bước checkout.
- Tính toán mức giảm giá và tổng tiền sau ưu đãi.

---

## 5. Hồ sơ cá nhân và lịch sử
Project cũng hỗ trợ các tác vụ liên quan đến tài khoản người dùng:

- Xem thông tin hồ sơ cá nhân.
- Chỉnh sửa ảnh đại diện từ thư viện ảnh.
- Xem lịch sử đặt phòng của người dùng hiện tại.

---

## 6. Dashboard và quản trị viên
Khu vực admin là phần nổi bật của project, cho phép:

- Xem dashboard tổng quan với các chỉ số như:
  - doanh thu
  - số phòng còn trống / tổng phòng
  - số lượng khách hàng
- Tìm kiếm nhanh các chức năng trong dashboard.
- Điều hướng đến các màn hình:
  - Quản lý nhân viên
  - Quản lý khách hàng
  - Quản lý loại phòng
  - Quản lý phòng
  - Quản lý dịch vụ
  - Quản lý mã giảm giá
  - Quản lý hóa đơn / doanh thu

---

## Kiến trúc source code

Cấu trúc thư mục chính của project:

```text
hotel_management_system/
├── App/                  # AppDelegate, SceneDelegate
├── Assets.xcassets/      # Màu sắc, icon, hình ảnh
├── Base.lproj/           # Storyboard và LaunchScreen
├── Model/                # Các model dữ liệu và cell model
├── Network/              # Lớp service gọi API
├── Router/               # Router theo endpoint dùng Alamofire
├── ViewController/       # Màn hình chính của ứng dụng
├── ViewController/Admin/ # Các màn hình dành cho admin
└── Custom UI Components  # TextField, Button, Avatar, Icon...
