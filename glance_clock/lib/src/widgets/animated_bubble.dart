// Copyright 2020 Itrat Fatima Khilonewala. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the glance_clock/LICENSE file.

import 'package:flutter/material.dart';

import '../model/bubble.dart';

class AnimatedBubble extends StatelessWidget {
  const AnimatedBubble({
    Key key,
    @required this.disc,
  }) : super(key: key);

  final Bubble disc;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedAlign(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: disc.alignment,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: disc.color,
            shape: BoxShape.circle,
          ),
          height: disc.size,
          width: disc.size,
        ),
      ),
    );
  }
}
