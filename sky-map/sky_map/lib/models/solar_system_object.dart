class SolarSystemObject {
  final dynamic id;
  final dynamic name;
  final List<dynamic> cells;

  SolarSystemObject({
    required this.id,
    required this.name,
    required this.cells,
  });

  factory SolarSystemObject.fromJson(Map<String, dynamic> json) {
    return SolarSystemObject(
      id: json['entry']['id'],
      name: json['entry']['name'],
      cells: List<dynamic>.from(json['cells'].map((cell) => TableCell.fromJson(cell))),
    );
  }
}

class TableCell {
  final String date;
  final dynamic id;
  final dynamic name;
  final Distance distance;
  final ObPosition position;
  final ExtraInfo extraInfo;

  TableCell({
    required this.date,
    required this.id,
    required this.name,
    required this.distance,
    required this.position,
    required this.extraInfo,
  });

  factory TableCell.fromJson(Map<String, dynamic> json) {
    return TableCell(
      date: json['date'],
      id: json['id'],
      name: json['name'],
      distance: Distance.fromJson(json['distance']),
      position: ObPosition.fromJson(json['position']),
      extraInfo: ExtraInfo.fromJson(json['extraInfo']),
    );
  }
}

class Distance {
  final dynamic au;
  final dynamic km;

  Distance({
    required this.au,
    required this.km,
  });

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      au: json['fromEarth']['au'],
      km: json['fromEarth']['km'],
    );
  }
}

class ObPosition {
  final Horizontal horizontal;
  final Equatorial equatorial;
  final Constellation constellation;

  ObPosition({
    required this.horizontal,
    required this.equatorial,
    required this.constellation,
  });

  factory ObPosition.fromJson(Map<String, dynamic> json) {
    return ObPosition(
      horizontal: Horizontal.fromJson(json['horizontal']),
      equatorial: Equatorial.fromJson(json['equatorial']),
      constellation: Constellation.fromJson(json['constellation']),
    );
  }
}

class Horizontal {
  final dynamic altitude;
  final dynamic azimuth;

  Horizontal({
    required this.altitude,
    required this.azimuth,
  });

  factory Horizontal.fromJson(Map<String, dynamic> json) {
    return Horizontal(
      altitude: json['altitude']['degrees'],
      azimuth: json['azimuth']['degrees'],
    );
  }
}

class Equatorial {
  final dynamic rightAscension;
  final dynamic declination;

  Equatorial({
    required this.rightAscension,
    required this.declination,
  });

  factory Equatorial.fromJson(Map<String, dynamic> json) {
    return Equatorial(
      rightAscension: json['rightAscension']['hours'],
      declination: json['declination']['degrees'],
    );
  }
}

class Constellation {
  final dynamic id;
  final dynamic short;
  final dynamic name;

  Constellation({
    required this.id,
    required this.short,
    required this.name,
  });

  factory Constellation.fromJson(Map<String, dynamic> json) {
    return Constellation(
      id: json['id'],
      short: json['short'],
      name: json['name'],
    );
  }
}

class ExtraInfo {
  final dynamic elongation;
  final dynamic magnitude;

  ExtraInfo({
    required this.elongation,
    required this.magnitude,
  });

  factory ExtraInfo.fromJson(Map<String, dynamic> json) {
    return ExtraInfo(
      elongation: json['elongation'],
      magnitude: json['magnitude'],
    );
  }
}



