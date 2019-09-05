
class mainPageArgs {
  final int uno;
  final String uname;

  mainPageArgs(this.uno, this.uname);

  String toString() {
    return "uno: $uno, uname: $uname";
  }
}

class searchFlightArgs {
  final int uno;
  final String uname;
  final int tno;
  final int depaCno;
  final String depaCity;
  final int arivCno;
  final String arivCity;
  final String depaDate;

  searchFlightArgs(this.uno, this.uname, this.tno, this.depaCno, this.depaCity, this.arivCno,
      this.arivCity, this.depaDate);

  String toString() {
    return "uno: $uno, uname: $uname, tno: $tno, depaCno: $depaCno, depaCity: $depaCity, \n"
        "arivCno: $arivCno, arivCity: $arivCity, depaDate: $depaDate";
  }
}

class returnTicketArgs {
  final int uno;
  final int tno;
  Map flight;         //见serverExperMap.dart中的server_trips,给出的是一个flight

  returnTicketArgs(this.uno, this.tno, this.flight);

  String toString() {
    return "uno: $uno, tno: $tno, flight: $flight";
  }
}

class flightDetailsArgs {
  final int uno;
  final int tno;
  final String uname;
  final List details;     //见serverExperMap.dart中的server_flightRes,给出的是一个行程里面的flights数组，其他附加的属性没有再给

  flightDetailsArgs(this.uno, this.tno, this.uname, this.details);

  String toString() {
    return "uno: $uno, tno: $tno, uname: $uname, details: $details";
  }
}

//因为passForm页采用带参构造器，formNavigArgs类已被废弃
class formNavigArgs {
  final int order;

  formNavigArgs(this.order);

  String toString() {
    return "order: $order";
  }
}

//搜索框页面的城市列表：从服务器获得的数据需要解析
class cityPairArgs {
  final int cno;
  final String cityName;

  cityPairArgs(this.cno, this.cityName);

  cityPairArgs.fromJson(Map<String, dynamic> json): cno = json["cno"], cityName = json["cityName"];

  Map<String, dynamic> toJson() => {'cno': cno, 'cityName': cityName, };
}