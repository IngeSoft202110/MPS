import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Class used by the provider
class ParkingLots with ChangeNotifier {
  List<QueryDocumentSnapshot> _list;

  get list {
    return _list;
  }

  set list(List<QueryDocumentSnapshot> list) {
    this._list = list;

    notifyListeners();
  }

  bool notNull(List<QueryDocumentSnapshot> list) {
    if (list.isNotEmpty)
      return true;
    else
      return false;
  }
}
