import 'package:flutter/material.dart';
import 'package:viewgoal/screens/giftPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';

//final String hostname = "http://192.168.2.14:2311";
final String hostname = "http://52.77.11.127:2311";


List<BottomNavigationBarItem> bnb = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.map),
    label: "Map",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.inbox),
    label: "Inbox",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.card_giftcard),
    label: "Gift",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    label: "Me",
  ),
];
