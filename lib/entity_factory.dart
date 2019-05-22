import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/navi_entity.dart';
import 'package:wanandroid_flutter/entity/tree_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ArticleEntity") {
      return ArticleEntity.fromJson(json) as T;
    } else if (T.toString() == "NaviEntity") {
      return NaviEntity.fromJson(json) as T;
    } else if (T.toString() == "TreeEntity") {
      return TreeEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}