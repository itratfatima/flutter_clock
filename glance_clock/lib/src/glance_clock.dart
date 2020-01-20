// Copyright 2020 Itrat Fatima Khilonewala. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the glance_clock/LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/bubble.dart';
import 'widgets/animated_bubble.dart';
import 'widgets/frosted_glass.dart';

class GlanceClock extends StatefulWidget {
  const GlanceClock(this.model);

  final ClockModel model;

  @override
  _GlanceClockState createState() => _GlanceClockState();
}

class _GlanceClockState extends State<GlanceClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  var _temperature = '';
  var _condition = '';

  final _discs = <Bubble>[];

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(GlanceClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString;
      _temperature = _temperature.substring(0, 2) + _temperature.substring(4);
      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      _makeBubble();
    });
  }

  void _makeBubble() {
    _discs.clear();
    for (int i = 0; i < 25; i++) {
      _discs.add(Bubble());
    }
  }

  void _initializeAnimation() {
    _animationController = new AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.25, end: 0.92).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double scaleSize;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      scaleSize = height/2.3;
    }else{
      scaleSize = width / 3.7;
    }
    final glanceTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFF212121),
            highlightColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFFB9C1C6),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFB9C1C6),
            highlightColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFF212121),
          );
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final dayOftheWeek = DateFormat('EEEE').format(_dateTime);
    final month = DateFormat('MMM dd').format(_dateTime);

    final timeTextStyle = TextStyle(
        color: glanceTheme.primaryColor,
        fontSize: scaleSize,
        fontFamily: 'Calistoga',
        letterSpacing: 1.7);
    final infoTextStyle = TextStyle(
        fontSize: scaleSize / 3.7,
        fontFamily: 'Raleway',
        color: glanceTheme.highlightColor,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
              color: glanceTheme.primaryColor,
              offset: Offset(1, 1),
              blurRadius: 2.0)
        ]);

    var semantics = '$hour:$minute';

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Glance clock with time $semantics',
        value: semantics,
      ),
      child: Stack(
        children: <Widget>[
          ///Colorful Bubbles Animation
          for (final disc in _discs) AnimatedBubble(disc: disc),

          ///Frosted Backdrop Effect
          FrostedGlass(color: glanceTheme.backgroundColor),

          ///At the Glance
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///Weather
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('$_temperature', style: infoTextStyle),
                    SizedBox(
                      width: 6,
                    ),
                    Image.asset(
                      'assets/$_condition.png',
                      color: glanceTheme.primaryColor,
                      height: scaleSize / 3,
                      width: scaleSize / 3,
                    ),
                  ],
                ),
              ),

              ///Time
              DefaultTextStyle(
                style: timeTextStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(hour),
                    FadeTransition(
                        opacity: _animation,
                        child: Text(
                          ':',
                        )),
                    Text(minute),
                  ],
                ),
              ),

              ///Day & Date
              Text('$dayOftheWeek, $month', style: infoTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
