import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

void main() => runApp(new PathFinderApp());

///
/// App.
///
class PathFinderApp extends StatelessWidget {
  // ------------------------------- METHODS ------------------------------

  ///
  /// Builds this widget.
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

///
/// Main page.
///
class MainPage extends StatelessWidget {
  // ------------------------------- FIELDS -------------------------------

  final List<WallDefinition> _walls = <WallDefinition>[
    //
    // Outer border.
    WallDefinition(origin: Point(0.0, 0.0), direction: Vector2(1500.0, 0.0)),
    WallDefinition(origin: Point(1500.0, 0.0), direction: Vector2(0.0, 500.0)),
    WallDefinition(
        origin: Point(1500.0, 500.0), direction: Vector2(-1500.0, 0.0)),
    WallDefinition(origin: Point(0.0, 500.0), direction: Vector2(0.0, -500.0)),

    //
    //
    WallDefinition(origin: Point(50.0, 175.0), direction: Vector2(650.0, 0.0)),
    WallDefinition(origin: Point(800.0, 175.0), direction: Vector2(650.0, 0.0)),
    WallDefinition(origin: Point(50.0, 325.0), direction: Vector2(650.0, 0.0)),
    WallDefinition(origin: Point(800.0, 325.0), direction: Vector2(650.0, 0.0)),
  ];

  // ------------------------------- METHODS ------------------------------

  ///
  /// Builds this widget.
  ///
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Path Finder'),
      ),
      body: Center(
        child: SizedBox(
            width: width - 24.0,
            height: 300.0,
            child: BuildingMap(walls: _walls)),
      ),
    );
  }
}

class WallDefinition {
  // ------------------------------- FIELDS -------------------------------

  final Point origin;
  final Vector2 direction;

  // ---------------------------- CONSTRUCTORS ----------------------------

  WallDefinition({@required this.origin, @required this.direction});
}

///
/// Building map.
///
class BuildingMap extends StatefulWidget {
  // ------------------------------- FIELDS -------------------------------

  /// Definition of walls in vector.
  final List<WallDefinition> walls;

  // ---------------------------- CONSTRUCTORS ----------------------------

  ///
  /// Create new [BuildingMap].
  ///
  BuildingMap({@required this.walls});

  // ------------------------------- METHODS ------------------------------

  ///
  /// Creates state for this widget.
  ///
  @override
  State<StatefulWidget> createState() {
    return _BuildingMapState();
  }
}

///
/// State for [BuildingMap].
///
class _BuildingMapState extends State<BuildingMap> {
  // ------------------------------- METHODS ------------------------------

  ///
  /// Builds this widget.
  ///
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(walls: widget.walls),
    );
  }
}

class _MapPainter extends CustomPainter {
  // ------------------------------- FIELDS -------------------------------

  /// Definition of walls in vector.
  final List<WallDefinition> walls;

  // ---------------------------- CONSTRUCTORS ----------------------------

  ///
  /// Create new [_MapPainter].
  ///
  _MapPainter({@required this.walls}) : assert(walls != null);

  // ------------------------------- METHODS ------------------------------

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (final WallDefinition wall in walls) {
      final originX = _map(wall.origin.x, 0.0, 1500.0, 0.0, size.width);
      final originY = _map(wall.origin.y, 0.0, 500.0, 0.0, size.height);
      final destX =
          _map(wall.origin.x + wall.direction.x, 0.0, 1500.0, 0.0, size.width);
      final destY =
          _map(wall.origin.y + wall.direction.y, 0.0, 500.0, 0.0, size.height);

      final Offset origin = Offset(originX, originY);
      final Offset destination = Offset(destX, destY);
      canvas.drawLine(origin, destination, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double _map(double value, double oldMin, double oldMax, double newMin,
      double newMax) {
    return newMin + (newMax - newMin) * ((value - oldMin) / (oldMax - oldMin));
  }
}
