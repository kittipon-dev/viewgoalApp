import 'package:flutter/material.dart';
import 'package:viewgoal/settings/Account/top_up.dart';

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
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
            'Balance',
            style: TextStyle(
              color: Color(0xffF1771A),
              fontFamily: 'Segoe',
            ),
          ),
          centerTitle: true),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: ListView(
          children: [
            Text('จำนวนเหรียญ'),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.attach_money),
                Text(
                  '199',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopUp(),
                      ),
                    );
                  },
                  child: Text(
                    'เติมเงิน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  color: Color(0xFFff0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'โปรโมชั่น',
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'กิจกรรม',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
