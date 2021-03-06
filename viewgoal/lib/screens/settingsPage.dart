import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/settings/About/community_guideliness.dart';
import 'package:viewgoal/settings/About/copyright_policy.dart';
import 'package:viewgoal/settings/About/privacy_policy.dart';
import 'package:viewgoal/settings/Account/balance.dart';
import 'package:viewgoal/settings/Account/manage_my_account.dart';
import 'package:viewgoal/settings/Account/privacy_and_safety.dart';
import 'package:viewgoal/settings/Account/share_profile.dart';
import 'package:viewgoal/settings/General/accessibility.dart';
import 'package:viewgoal/settings/General/data_saver.dart';
import 'package:viewgoal/settings/General/digital_wellbeing.dart';
import 'package:viewgoal/settings/General/language.dart';
import 'package:viewgoal/settings/General/map.dart';
import 'package:viewgoal/settings/General/push_notification.dart';
import 'package:viewgoal/settings/Support/help_center.dart';
import 'package:viewgoal/settings/Support/report_a_problem.dart';
import 'package:viewgoal/settings/add_account.dart';
import 'package:viewgoal/settings/free_up_space.dart';
import 'package:viewgoal/settings/log_out.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:viewgoal/settings/Support/safe_center.dart';

import '../settings/About/terms_of_use.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

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
            'Settings and privacy',
            style: TextStyle(
              color: Color(0xffF1771A),
              fontFamily: 'Segoe',
            ),
          ),
          centerTitle: true),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "ACCOUNT",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xffF1771A)),
            ), //Account
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageMyAccount(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Manage my account",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Manage my account
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyAndSafety(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Privacy and safety",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Privacy and safety
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Balance(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Balance",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Balance
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareProfile(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.shareOutline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Share profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Share profile

            Divider(
              height: 50,
              thickness: 2,
            ),

            Text(
              "GENERAL",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xffF1771A)),
            ), //GENERAL
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PushNotification(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Push Notifications",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Push Notifications
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Language(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.translate_outlined,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Language",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Language
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DigitalWellbeing(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.smartphone,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Digital Wellbeing",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Digital Wellbeing
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Accessibility(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.accessibility,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Accessibility",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Accessibility
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataSaver(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.databaseCheckOutline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Data Saver",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Data Saver
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Map(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Map",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Map

            Divider(
              height: 50,
              thickness: 2,
            ),

            Text(
              "SUPPORT",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xffF1771A)),
            ), //SUPPORT
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportAProblem(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.clipboardTextOutline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Report a Problem",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Report a Problem
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpCenter(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Help center",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Help center
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SafeCenter(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 15),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.shieldCheckOutline,
                      size: 27,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Safe Center",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ), //Safe Center

            Divider(
              height: 50,
              thickness: 2,
            ),

            Text(
              "ABOUT",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xffF1771A)),
            ), //ABOUT
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermOfUse(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.bookOutline,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Terms of Use",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Term of Use
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityGuidelines(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.googleCirclesCommunities,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Community Guidelines",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Community Guidelines
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicy(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.sd,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Privacy Policy
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CopyrightPolicy(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.alphaCCircleOutline,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Copyright Policy",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Copyright Policy

            Divider(
              height: 50,
              thickness: 2,
            ),

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreeUpSpace(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.trashCanOutline,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Free up space",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Free up space
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAccount(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.plus,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Add account",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Add account
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                logout();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 10),
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.logout,
                        size: 27,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Log out",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ), //Log out
            SizedBox(
              height: 380,
            ),
          ],
        ),
      ),
    );
  }
}
