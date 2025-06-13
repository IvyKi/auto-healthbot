class RoomBox {
  final String room;
  final double left;
  final double top;
  final double width;
  final double height;

  RoomBox({
    required this.room,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  factory RoomBox.fromJson(Map<String, dynamic> json) {
    return RoomBox(
      room: json['room'],
      left: double.parse(json['left']),
      top: double.parse(json['top']),
      width: double.parse(json['width']),
      height: double.parse(json['height']),
    );
  }

  bool contains(double dxRatio, double dyRatio) {
    return dxRatio >= left &&
        dxRatio <= (left + width) &&
        dyRatio >= top &&
        dyRatio <= (top + height);
  }
}
