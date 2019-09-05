List server_trips = [
  {
    "tno": 12,
    "flights":[
      {
        "fno": 10,
        "depa_cno": 3,
        "depa_time": "2020-03-11 02:23",
        "depa_gmt":  "2020-03-11 02:23",
        "depa_iata": "CAN",
        "depa_port": "广州白云国际机场",
        "depa_city": "广州",
        "ariv_cno": 5,
        "ariv_time": "2020-03-11 10:50",
        "ariv_gmt": "2020-03-11 10:50",
        "ariv_iata": "NRT",
        "ariv_port": "成田国际机场",
        "ariv_city": "成田",
        "prefix": "LT4",
        "ptag": "A333",
        "passengers": [
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "10D",
            "passId": "1111111",
            "passName": "熊壮壮",
            "passNation": "CHN",
            "category": 3,
            "price": 1200.00,
            "valid": 0,
          },
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "15E",
            "passId": "22222222",
            "passName": "熊伟",
            "passNation": "CHN",
            "category": 1,
            "price": 10200.00,
            "valid": 0,
          },
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "10E",
            "passId": "33333333",
            "passName": "徐萌萌",
            "passNation": "CHN",
            "category": 3,
            "price": 1200.00,
            "valid": 0,
          },
        ],
      },
    ],
  },
  {
    "tno": 15,
    "flights":[
      {
        "fno": 12,
        "depa_cno": 7,
        "depa_time": "2020-04-11 05:20",
        "depa_gmt": "2020-04-11 05:20",
        "depa_iata": "LHR",
        "depa_port": "伦敦希思罗机场",
        "depa_city": "伦敦",
        "ariv_cno": 5,
        "ariv_time": "2020-04-11 10:50",
        "ariv_gmt": "2020-04-11 10:50",
        "ariv_iata": "NRT",
        "ariv_port": "成田国际机场",
        "ariv_city": "成田",
        "prefix": "LT20",
        "ptag": "T223",
        "passengers": [
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "10E",
            "passId": "33333333",
            "passName": "徐萌萌",
            "passNation": "CHN",
            "category": 3,
            "price": 1200.00,
            "valid": -1,
          },
          {
            "fno": 12,
            "prefix": "LT20",
            "sno": 12,                    //新增，为了方便删除
            "sname": "23A",
            "passId": "1111111",
            "passName": "熊壮壮",
            "passNation": "CHN",
            "category": 3,
            "price": 2500.00,
            "valid": 0,
          },
        ]
      },
      {
        "fno": 13,
        "depa_cno": 5,
        "depa_time": "2020-04-11 14:30",
        "depa_gmt": "2020-04-11 14:30",
        "depa_iata": "NRT",
        "depa_port": "成田国际机场",
        "depa_city": "成田",
        "ariv_cno": 3,
        "ariv_time": "2020-04-12 02:23",
        "ariv_gmt": "2020-04-12 02:23",
        "ariv_iata": "CAN",
        "ariv_port": "广州白云国际机场",
        "ariv_city": "广州",
        "prefix": "LT46",
        "ptag": "X23B",
        "passengers": [
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "15E",
            "passId": "22222222",
            "passName": "熊伟",
            "passNation": "CHN",
            "category": 1,
            "price": 10200.00,
            "valid": 0,
          },
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "10D",
            "passId": "1111111",
            "passName": "熊壮壮",
            "passNation": "CHN",
            "category": 3,
            "price": 1200.00,
            "valid": 0,
          },
          {
            "fno": 10,
            "prefix": "LT4",
            "sno": 12,                    //新增，为了方便删除
            "sname": "10E",
            "passId": "33333333",
            "passName": "徐萌萌",
            "passNation": "CHN",
            "category": 3,
            "price": 1200.00,
            "valid": 0,
          },
        ]
      }
    ],
  },
];

List<Map<String, dynamic>> server_flightRes = [
  {
    "flights": [
      {
        "fno": 70,
        "depa_iata": "CAN",
        "depa_port": "广州白云国际机场",
        "depa_time": "2020-05-09 18:00:00",
        "depa_gmt": "2020-05-09 18:00:00",
        "ariv_iata": "NRT",
        "ariv_port": "成田国际机场",
        "ariv_time": "2020-05-10 01:01:00",
        "ariv_gmt": "2020-05-10 01:01:00",
        "prefix": "LT70",
        "ptag": "A333",
        "first_class": 12,
        "business": 11,
        "economy": 10,
        "fprice": 10000.00,
        "bprice": 5000.00,
        "eprice": 100.00,
      },
      {
        "fno": 71,
        "depa_iata": "NRT",
        "depa_port": "成田国际机场",
        "depa_time": "2020-05-10 10:00:00",
        "depa_gmt": "2020-05-10 10:00:00",
        "ariv_iata": "LAX",
        "ariv_port": "洛杉矶国际机场",
        "ariv_time": "2020-05-10 12:00:00",
        "ariv_gmt": "2020-05-10 12:00:00",
        "prefix": "LT711",
        "ptag": "B444",
        "first_class": 9,
        "business": 8,
        "economy": 7,
        "fprice": 20000.00,
        "bprice": 10000.00,
        "eprice": 100.00,
      },
      {
        "fno": 72,
        "depa_iata": "LAX",
        "depa_port": "洛杉矶国际机场",
        "depa_time": "2020-05-11 11:00:00",
        "depa_gmt": "2020-05-11 11:00:00",
        "ariv_iata": "LHR",
        "ariv_port": "伦敦希思罗机场",
        "ariv_time": "2020-05-11 22:00:00",
        "ariv_gmt": "2020-05-11 22:00:00",
        "prefix": "LT722",
        "ptag": "C555",
        "first_class": 6,
        "business": 5,
        "economy": 4,
        "fprice": 10000.00,
        "bprice": 5000.00,
        "eprice": 100.00,
      },
    ],
  },
  {
    "flights": [
      {
        "fno": 73,
        "depa_iata": "CAN",
        "depa_port": "广州白云国际机场",
        "depa_time": "2020-05-09 18:00:00",
        "depa_gmt": "2020-05-09 18:00:00",
        "ariv_iata": "LHR",
        "ariv_port": "伦敦希思罗机场",
        "ariv_time": "2020-05-10 10:00:00",
        "ariv_gmt": "2020-05-10 10:00:00",
        "prefix": "LT73",
        "ptag": "D7777",
        "first_class": 5,
        "business": 5,
        "economy": 10,
        "fprice": 20000.00,
        "bprice": 3000.00,
        "eprice": 1500.00,
      },
    ]
  }
];

Map<String, dynamic> server_shopResult = {
  "price": 23000.00,
  "status": "无误",
};

List<Map<String, dynamic>> server_cityList = [
  {
    "cno": 1,
    "cityName": "广州"
  },
  {
    "cno": 2,
    "cityName": "乌鲁木齐"
  },
  {
    "cno": 3,
    "cityName": "深圳"
  },
  {
    "cno": 4,
    "cityName": "北京"
  },
  {
    "cno": 5,
    "cityName": "成田"
  },
  {
    "cno": 6,
    "cityName": "伦敦"
  },
  {
    "cno": 7,
    "cityName": "洛杉矶"
  },
  {
    "cno": 8,
    "cityName": "金边"
  },
  {
    "cno": 9,
    "cityName": "阿德莱德"
  },
  {
    "cno": 10,
    "cityName": "济南"
  }
];