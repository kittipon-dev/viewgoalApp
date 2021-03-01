import 'package:flutter/material.dart';

class TopUp extends StatefulWidget {
  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Color(0xff707070)),
          ),
          title: Text(
            'เติมเงิน',
            style: TextStyle(
              color: Color(0xffF1771A),
              fontFamily: 'Segoe',
            ),
          ),
          centerTitle: true),
      body: Column(
        children: [
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 วัน',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '10 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '10 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 สัปดาห์',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '100 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '59 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 เดือน',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '100 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '199 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 ปี',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '8,000 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '1,990 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
        ],
      ),
    );
  }

// ListView _buildListView() {
//   return ListView.builder(
//       itemCount: 4,
//       itemBuilder: (_, index) {
//         return ListTile(
//           title: Text('HI'),
//         );
//       });
// }

}
