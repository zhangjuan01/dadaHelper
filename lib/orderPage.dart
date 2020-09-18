import 'package:flutter/material.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:learn/orderedList.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

Dio dio = Dio();

class OrderPage extends StatefulWidget {
  OrderPage({Key key, this.orderData}) : super(key: key);
  final dynamic orderData;

  @override
  _OrderPageState createState() => _OrderPageState();

// @override
// State<StatefulWidget> createState() {
//   // TODO: implement createState
//   throw UnimplementedError();
// }
}

class Question {
  final int id;
  final String type;
  final int transporterSkillId;

  const Question({
    this.id,
    this.type,
    this.transporterSkillId,
  });

  factory Question.fromMap(Map<String, dynamic> json) {
    if (json == null) return null;
    return Question(
      id: json["id"] as int,
      type: json["type"] as String,
      transporterSkillId: json["transporterSkillId"] as int,
    );
  }
}

class _OrderPageState extends State<OrderPage> {
  dynamic orderData = {};
  String icons = '';
  int _date;
  int demandTypeId;
  String demandDetail;
  String address;
  String memo;
  String needDadaCount;
  String orderTime;
  String price;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  // AmapController _controller;
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  void _orderParamsChange(type, value) {
    setState(() {
      orderData[type] = value;
    });
  }

  // 列表数据页
  Future<String> queryQuestionList() async {
    Response response;
    response =
        await dio.get("http://dftask-x5frwn.ndev.imdada.cn/hack/demandTyeDict");
    return convert.jsonEncode(response.data['content']);
  }

  // 用户下单
  void creatOrder()async {
    print('dateTIme => $_date');
    var data = {'address': address, 'demandDetail': demandDetail ?? '', 'memo': memo,
      'needDadaCount': needDadaCount, 'orderTime': _date, 'price': price, 'demandTypeId': demandTypeId};
    print('data => $data');
    Response response;
    response =
        await dio.post("http://dftask-x5frwn.ndev.imdada.cn/hack/createOrder",
        data: data);
    print(response);
    Fluttertoast.showToast(
        msg: "下单成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
    // return convert.jsonEncode(response.data['content']);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              leading:
              IconButton(
                icon: new Icon(Icons.person, color: Colors.black),
                // highlightColor: Colors.pink,
                onPressed: () {
                  // 导航到新路由
                  Navigator.pushNamed(
                      context, 'ordered_list');
                },
              ),
              title: new Center(
                child: TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.blue,
                    labelPadding: EdgeInsets.only(left: 0),
                    labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: '达达帮手'),
                      Tab(text: '京东快递'),
                    ]),
              ),
              actions: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child:
                      new Icon(Icons.message, size: 24.0, color: Colors.black),
                )
              ],
              backgroundColor: Colors.white,
            ),
            body: Container(
              height: 900,
              child:
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      child:  Column(
                        children: [
                          ListTile(
                            title: const Text('找人来帮忙', textAlign: TextAlign.center, style:TextStyle(
                                fontWeight:
                                FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  FutureBuilder(
                                    future: queryQuestionList(),
                                    initialData: '',
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData && snapshot.data != '') {
                                        List<Question> questions =
                                        ((json.decode(snapshot.data) ?? [])
                                        as List)
                                            .map<Question>(
                                              (dayMap) =>
                                              Question.fromMap(dayMap),
                                        )
                                            .toList();
                                        return DropdownButton(
                                          isExpanded: true,
                                          value: demandTypeId,
                                          hint: Text('请选择问题'),
                                          onChanged: (newValue) {
                                            //
                                            setState(() {
                                              demandTypeId = newValue;
                                            });
                                            print('newValue => $newValue');
                                          },
                                          items: questions.map((trouble) {
                                            return DropdownMenuItem(
                                              child: new Text(trouble.type),
                                              value: trouble.id,
                                            );
                                          }).toList(),
                                        );
                                      }
                                      return DropdownButton(
                                        isExpanded: true,
                                        hint: Text('请选择问题'),
                                        onChanged: (newValue) {
                                          print(newValue);
                                        },
                                        items: [],
                                      );
                                    },
                                  ),
                                  DateTimeField(
                                    format: format,
                                    onShowPicker: (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                      if (date != null) {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        return DateTimeField.combine(date, time);
                                      } else {
                                        return currentValue;
                                      }
                                    },
                                    onChanged: (date) {
                                      print('date => $date');
                                      print(date.toUtc().millisecondsSinceEpoch);
                                      //
                                      setState(() {
                                        _date = date.toUtc().millisecondsSinceEpoch;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        demandDetail = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "请输入问题描述详情",
                                      helperText: "问题描述",
                                    ),
                                    // obscureText: true,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        address = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "输入具体地址",
                                      helperText: "地址",
                                    ),
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "请输入具体人数",
                                      helperText: "需要人数",
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        needDadaCount = value;
                                      });
                                    },
                                  ),
                                  TextField(
                                      decoration: InputDecoration(
                                        hintText: "请输入价格",
                                        helperText: "价格",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          price = value;
                                        });
                                      }
                                  ),
                                  TextField(
                                      decoration: InputDecoration(
                                        hintText: "请输入备注",
                                        helperText: "备注",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          memo = value;
                                        });
                                      }
                                  ),
                                  // 登录按钮
                                  Padding(
                                    padding: const EdgeInsets.only(top: 28.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: RaisedButton(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text("快来帮我"),
                                            color: Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              // 导航到新路由
                                              creatOrder();
                                              //在这里不能通过此方式获取FormState，context不对
                                              //print(Form.of(context));

                                              // 通过_formKey.currentState 获取FormState后，
                                              // 调用validate()方法校验用户名密码是否合法，校验
                                              // 通过后再提交数据。
                                              // if ((_formKey.currentState as FormState)
                                              //     .validate()) {
                                              //   //验证通过提交数据
                                              // }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ),
            )
//         body: AmapView(
//           // 地图类型
//           mapType: MapType.Standard,
//           // 是否显示缩放控件
//           showZoomControl: true,
//           // 是否显示指南针控件
//           showCompass: true,
//           // 是否显示比例尺控件
//           showScaleControl: true,
//           // 是否使能缩放手势
//           zoomGesturesEnabled: true,
//           // 是否使能滚动手势
//           scrollGesturesEnabled: true,
//           // 是否使能旋转手势
//           rotateGestureEnabled: true,
//           // 是否使能倾斜手势
//           tiltGestureEnabled: true,
//           // 缩放级别
//           zoomLevel: 10,
//           // 中心点坐标
//           centerCoordinate: LatLng(39, 116),
//           // 标记
//           markers: <MarkerOption>[],
//           // 标识点击回调
// //      onMarkerClick: (Marker marker) {},
// //      // 地图点击回调
// //      onMapClick: (LatLng coord) {},
// //      // 地图拖动回调
// //      onMapDrag: (MapDrag drag) {},
//           // 地图创建完成回调
//           onMapCreated: (controller) async {
//             _controller = controller;
//             // requestPermission是权限请求方法, 需要你自己实现
//             // 如果不知道怎么处理, 可以参考example工程的实现, example过程依赖了`permission_handler`插件.
//             await _controller.requireAlwaysAuth();
//             await _controller.setZoomLevel(17.0);
//             // await controller.showMyLocation(true);
//           },
//         ),
            );
    // TODO: implement build
    throw UnimplementedError();
  }
}
