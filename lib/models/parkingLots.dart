import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Class used by the provider
class ParkingLots with ChangeNotifier {
  List<QueryDocumentSnapshot> _list;
  bool _ranking;
  List<QueryDocumentSnapshot> _initlist;

  get ranking {
    return _ranking;
  }

  set ranking(bool ranking) {
    this._ranking = ranking;
    notifyListeners();
  }

  get list {
    return _list;
  }

  set list(List<QueryDocumentSnapshot> list) {
    this._list = list;

    notifyListeners();
  }

  get initlist {
    return _initlist;
  }

  set initlist(List<QueryDocumentSnapshot> initlist) {
    this._initlist = initlist;

    notifyListeners();
  }

  bool notNull(List<QueryDocumentSnapshot> list) {
    if (list.isNotEmpty)
      return true;
    else
      return false;
  }
}
