import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'resources', icon: Icons.account_balance_rounded),
  Destination(label: 'manage', icon: Icons.account_tree_rounded),
  Destination(label: 'account', icon: Icons.account_circle_outlined),
];