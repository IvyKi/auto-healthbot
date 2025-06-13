class RoomBox {
  final String room;
  final double left;
  final double top;
  final double width;
  final double height;
  final double x;
  final double y;

  RoomBox({
    required this.room,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
  });

  factory RoomBox.fromJson(Map<String, dynamic> json) {
    return RoomBox(
      room: json['room'],
      left: double.parse(json['left']),
      top: double.parse(json['top']),
      width: double.parse(json['width']),
      height: double.parse(json['height']),
      x: double.parse(json['x']),
      y: double.parse(json['y']),
    );
  }

  bool contains(double dxRatio, double dyRatio) {
    return dxRatio >= left &&
        dxRatio <= (left + width) &&
        dyRatio >= top &&
        dyRatio <= (top + height);
  }
}
