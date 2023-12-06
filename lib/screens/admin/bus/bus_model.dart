class Bus {
  String busid;
  String busname;
  int seatcount;
  String route;

  Bus(
      {required this.busid,
      required this.busname,
      required this.seatcount,
      required this.route});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busid: json['busid'],
      busname: json['busname'],
      seatcount: json['seatcount'],
      route: json['route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busid': busid,
      'busname': busname,
      'seatcount': seatcount,
      'route': route,
    };
  }
}
