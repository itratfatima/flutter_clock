// Copyright 2020 Itrat Fatima Khilonewala. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the glance_clock/LICENSE file.

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'src/glance_clock.dart';

void main() {
  runApp(ClockCustomizer((ClockModel model) => GlanceClock(model)));
}
