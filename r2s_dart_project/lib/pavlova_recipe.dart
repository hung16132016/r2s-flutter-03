// Widget chính, không có trạng thái (UI tĩnh)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PavlovaRecipe extends StatelessWidget {
  const PavlovaRecipe({super.key});

  // Hàm build chính của widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Trang chính của ứng dụng
      home: buildHomePage(),
    );
  }

  // Xây dựng giao diện trang Home
  Widget buildHomePage() {
    // ====== TIÊU ĐỀ MÓN ĂN ======
    const titleText = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        'Strawberry Pavlova',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 25,
        ),
      ),
    );

    // ====== MÔ TẢ MÓN ĂN ======
    const subTitle = Text(
      'Pavlova is a meringue-based dessert named after the Russian ballerina '
          'Anna Pavlova. Pavlova features a crisp crust and soft, light inside, '
          'topped with fruit and whipped cream.',
      textAlign: TextAlign.center, // Căn giữa nội dung
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 20,
      ),
    );

    // ====== SAO ĐÁNH GIÁ ======
    var stars = Row(
      mainAxisSize: MainAxisSize.min, // Row chỉ chiếm vừa đủ kích thước
      children: [
        Icon(Icons.star, color: Colors.green[500]), // Sao sáng
        Icon(Icons.star, color: Colors.green[500]),
        Icon(Icons.star, color: Colors.green[500]),
        const Icon(Icons.star, color: Colors.black), // Sao tối
        const Icon(Icons.star, color: Colors.black),
      ],
    );

    // ====== KHU VỰC ĐÁNH GIÁ ======
    var ratings = Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Cách đều các phần tử
        children: [
          stars, // Hiển thị sao
          const Text(
            '170 Reviews',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );

    // ====== STYLE DÙNG CHUNG CHO ICON LIST ======
    const descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18,
      height: 2,
    );

    // ====== DANH SÁCH ICON THÔNG TIN ======
    final iconList = DefaultTextStyle.merge(
      style: descTextStyle, // Áp dụng style mặc định cho text con
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Thời gian chuẩn bị
            Column(
              children: [
                Icon(Icons.kitchen, color: Colors.green[500]),
                const Text('PREP:'),
                const Text('25 min'),
              ],
            ),
            // Thời gian nấu
            Column(
              children: [
                Icon(Icons.timer, color: Colors.green[500]),
                const Text('COOK:'),
                const Text('1 hr'),
              ],
            ),
            // Khẩu phần
            Column(
              children: [
                Icon(Icons.restaurant, color: Colors.green[500]),
                const Text('FEEDS:'),
                const Text('4-6'),
              ],
            ),
          ],
        ),
      ),
    );

    // ====== HÌNH ẢNH MÓN ĂN ======
    final mainImage = Image.asset(
      'images/pavlova.jpg', // Ảnh lấy từ thư mục assets
    );

    // ====== CỘT CHÍNH CHỨA TOÀN BỘ NỘI DUNG ======
    final mainColumn = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          titleText,   // Tiêu đề
          subTitle,    // Mô tả
          ratings,     // Đánh giá
          iconList,    // Thông tin món ăn
          Expanded(
            child: mainImage, // Ảnh chiếm phần không gian còn lại
          ),
        ],
      ),
    );

    // ====== KHUNG GIAO DIỆN CHÍNH ======
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pavlova Recipe'), // Thanh tiêu đề
      ),
      body: mainColumn, // Nội dung chính
    );
  }
}
