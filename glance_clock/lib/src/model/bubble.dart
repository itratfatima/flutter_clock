// Copyright 2020 Itrat Fatima Khilonewala. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the glance_clock/LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

class Bubble {
  static final _rng = Random();

  double size;
  Color color;
  Alignment alignment;

  Bubble() {
    color = Color.fromARGB(
      _rng.nextInt(200),
      _rng.nextInt(255),
      _rng.nextInt(255),
      _rng.nextInt(255),
    );
    size = _rng.nextDouble() * 40 + 63;
    alignment = Alignment(
      _rng.nextDouble() * 2 - 1,
      _rng.nextDouble() * 2 - 1,
    );
  }
}
