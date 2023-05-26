# ichat-flutter v0.1
Ứng dụng nhắn tin được viết bằng Flutter, State management Riverpod và Firebase.
# Chức năng
	- Đăng nhập, đăng xuất ứng dụng sử dụng số điện thoại
	- Xác thực SMS OTP
	- Chỉnh sửa thông tin cá nhân (Hình đại diện, tên)
	- Hiển thị danh sách tin nhắn 
	- Chọn người nhắn tin qua danh bạ trong điện thoại
	- Nhắn tin realtime
	- Gửi thông báo khi có tin nhắn đến

# Hạn chế
Firebase giới hạn lượng sms code được gửi đến 1 thiết bị (để tránh spam), khi thiết bị request sms code nhiều lần sẽ bị Firebase chặn trong thời gian ngắn.

# Cài đặt
	- Bằng cmd:
		+ flutter pub get
		+ flutter run
	- Bằng build.cmd: 
		+ Chạy build.cmd trong thư mục dự án