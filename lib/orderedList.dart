import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';

Dio dio = Dio();
class OrderedList extends StatefulWidget {
  OrderedList({Key key, this.orderData}) : super(key: key);
  final dynamic orderData;

  @override
  _OrderedListState createState() => _OrderedListState();

// @override
// State<StatefulWidget> createState() {
//   // TODO: implement createState
//   throw UnimplementedError();
// }
}

class DadaInfo {
  final int age;
  final String userName;
  final String hometown;
  final String skill;
  final String briefIntroduction;
  final String skillStrInfo;
  final String score;

  const DadaInfo({
    this.age,
    this.userName,
    this.hometown,
    this.skill,
    this.briefIntroduction,
    this.skillStrInfo,
    this.score,
  });

  factory DadaInfo.fromMap(Map<String, dynamic> json) {
    if (json == null) return null;
    return DadaInfo(
      age: json["age"] as int,
      userName: json["userName"] as String,
      hometown: json["hometown"] as String,
      skill: json["skill"] as String,
      briefIntroduction: json["briefIntroduction"] as String,
      skillStrInfo: json["skillStrInfo"] as String,
      score: json["score"] as String,
    );
  }
}
//
// 接单骑士列表
Future<String> queryDadaList() async {
  Response response;
  response =
  await dio.get("http://dftask-x5frwn.ndev.imdada.cn/hack/selectDadaList");
  print(response);
  return convert.jsonEncode(response.data['content']);
}
// 用户下单
Future<String> orderedDada ()async {
  Response response;
  response =
      await dio.post("http://dftask-x5frwn.ndev.imdada.cn/hack/determineDada");
  return '';
}

class _OrderedListState extends State<OrderedList> {
  @override
  Widget build(BuildContext context) {
    // print(json.decode(_orderedList));
    // List<Order> orders = ((json.decode(_orderedList) ?? []) as List)
    //     .map<Order>(
    //       (dayMap) => Order.fromMap(dayMap),
    // )
    //     .toList();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('接单帮手列表'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
              children: <Widget> [
                FutureBuilder(
                  future: queryDadaList(),
                  initialData: '',
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data != '' && snapshot.data != '[]') {
                      List<DadaInfo> dadaList = ((json.decode(snapshot.data) ?? []) as List)
                          .map<DadaInfo>((dayMap) => DadaInfo.fromMap(dayMap),)
                          .toList();
                      return Column(
                        children: dadaList.map<Widget>((order) => Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                              height: 280.0,
                              child: Column(
                                children: <Widget>[
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            height: 60,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, right: 20.0, top: 20),
                                              child: CircleAvatar(
                                                radius: 60,
                                                backgroundImage: NetworkImage(
                                                    "https://avatars2.githubusercontent.com/u/52148596?s=460&u=526a00afed0602f2c50f7fbb7d5445ae9ece0df1&v=4"),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 140.0,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20.0, top: 20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  //无效，内层Colum高度为实际高度
                                                  children: <Widget>[
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: 10.0),
                                                        child: Text(
                                                            "${order.userName} ${order.age} ${order.hometown}")),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          '职业技能：',
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              '${order.skillStrInfo}'),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: 10.0, top: 10,),
                                                        child: Text(
                                                            "用户评分：${order.score}")),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 20.0, left: 10.0),
                                          child: Text(
                                            '简介：${order.briefIntroduction}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  MaterialButton(
                                    color: Colors.green,
                                    minWidth: 150.0,
                                    onPressed: ()async {
                                      await orderedDada();
                                      Fluttertoast.showToast(
                                          msg: "下单成功",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    },
                                    child: Text('立即下单',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        )),
                                  )
                                ],
                              )),
                        )).toList(),
                      );
                    }
                    return Text('暂无帮手接单', textAlign: TextAlign.center);
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }
}
