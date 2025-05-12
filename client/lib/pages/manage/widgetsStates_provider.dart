import 'package:flutter/material.dart';


class WidgetStatesProvider extends ChangeNotifier {
  Map states = {};

  setState(id, c_state) {
    states[id] = c_state;
    notifyListeners();
  }

  getState(id) {
    if (states.containsKey(id)){
      return states[id];
    } else {
      return null;
    }
  }

  deleteState(id) {
    if (states.containsKey(id)){
      states.remove(id);
    }
  }
}