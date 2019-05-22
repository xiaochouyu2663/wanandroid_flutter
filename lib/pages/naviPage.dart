import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/navi_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class NaviPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NaviPageState();
  }
}

class _NaviPageState extends State<NaviPage> {
  List<NaviData> _datas = new List(); //一级分类集合
  List<NaviDataArticle> articles = new List(); //二级分类集合
  int index; //一级分类下标

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.NAVI);
      Map userMap = json.decode(response.toString());
      var naviEntity = new NaviEntity.fromJson(userMap);

      /// 初始化
      setState(() {
        _datas = naviEntity.data;
        index = 0;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
            flex: 2,
            child: Container(
              color: YColors.color_fff,
              child: new ListView.builder(
                  itemCount: _datas.length,
                  itemBuilder: (BuildContext context, int position) {
                    return getRow(position);
                  }),
            )),
        new Expanded(
            flex: 5,
            child: ListView(
              children: <Widget>[
                Container(
                  //height: double.infinity,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  color: YColors.color_f3f3f3,
                  child: getChip(index), //传入一级分类下标
                ),
              ],
            )),
      ],
    );
  }

  Color textColor = YColors.colorPrimary; //字体颜色

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        color: index == i ? YColors.color_f3f3f3 : Colors.white,
        child: new Text(_datas[i].name,
            style: TextStyle(
                color: index == i ? textColor : YColors.color_666,
                fontSize: 16)),
      ),
      onTap: () {
        setState(() {
          index = i; //记录选中的下标
          textColor = YColors.colorPrimary;
        });
      },
    );
  }

  Widget getChip(int i) {
    //更新对应下标数据
    _updateArticles(i);
    return Wrap(
      spacing: 10.0, //两个widget之间横向的间隔
      direction: Axis.horizontal, //方向
      alignment: WrapAlignment.start, //内容排序方式
      children: List<Widget>.generate(
        articles.length,
        (int index) {
          return ActionChip(
            //标签文字
            label: Text(articles[index].title,
                style: TextStyle(fontSize: 16, color: YColors.color_666)),
            //点击事件
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ArticleDetail(
                        title: articles[index].title,
                        url: articles[index].link)),
              );
            },
            elevation: 3,
          );
        },
      ).toList(),
    );
  }

  ///
  /// 根据一级分类下标更新二级分类集合
  ///
  List<NaviDataArticle> _updateArticles(int i) {
    setState(() {
      if (_datas.length != 0) articles = _datas[i].articles;
    });
    return articles;
  }
}
