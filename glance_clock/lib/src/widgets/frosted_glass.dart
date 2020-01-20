// Copyright 2020 Itrat Fatima Khilonewala. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the glance_clock/LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 11, sigmaY: 11),
        child: Container(color: color.withOpacity(0.63)),
      ),
    );
  }
}
