import 'package:flutter/material.dart';

IconData categoryIcon(String key) {
  switch (key) {
    case 'restaurant':
      return Icons.restaurant;
    case 'commute':
      return Icons.directions_bus;
    case 'home':
      return Icons.home;
    case 'bolt':
      return Icons.bolt;
    case 'health':
      return Icons.health_and_safety;
    case 'movie':
      return Icons.movie;
    default:
      return Icons.more_horiz;
  }
}
