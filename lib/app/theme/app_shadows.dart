import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const sm = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const md = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  static const lg = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  static const xl = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 25,
      offset: Offset(0, 20),
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 10,
      offset: Offset(0, 8),
      spreadRadius: -6,
    ),
  ];

  static const twoXl = <BoxShadow>[
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 50,
      offset: Offset(0, 25),
      spreadRadius: -12,
    ),
  ];

  static const primary = <BoxShadow>[
    BoxShadow(
      color: Color(0x332563EB),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x332563EB),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  static const selectedCard = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A2563EB),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1A2563EB),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];
}
