import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../test.dart';

class Html {
  final html;
  Html({this.html});
  main() {
    List list = new List();
    Document document = parse(test);
    document.nodes[0].nodes[1].nodes
        .forEach((value) => list.add(nodesSplit(value.nodes)));
    print(list);
  }

  nodesSplit(nodes) {
    List list = new List();

    factorial(value) {
      value.forEach((v) {
        if (v.nodeType == 3) {
          Map node = {v.localName: v};
          list.add(node);
        } else if (v.localName == 'img') {
          list.add(CachedNetworkImage(
            imageUrl: v.attributes['src'],
          ));
        } else if (v.localName == 'h1') {
          list.add(Flutter.Text(v, style: TextStyle(fontSize: 22.0)));
        } else if (v.localName == 'h2') {
          list.add(Flutter.Text(v, style: TextStyle(fontSize: 20.0)));
        } else if (v.localName == 'h3') {
          list.add(Flutter.Text(v, style: TextStyle(fontSize: 18.0)));
        } else if (v.localName == 'h3') {
          list.add(Flutter.Text(v, style: TextStyle(fontSize: 18.0)));
        } else {
          factorial(v.nodes);
        }
      });
    }

    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].nodeType == 3) {
        Map node = {nodes[i].localName: nodes[i]};
        list.add(node);
      } else if (nodes[i].localName == 'img') {
        list.add(CachedNetworkImage(
          imageUrl: nodes[i].attributes['src'],
        ));
      } else if (nodes[i].localName == 'h1') {
        list.add(Flutter.Text(nodes[i], style: TextStyle(fontSize: 22.0)));
      } else if (nodes[i].localName == 'h2') {
        list.add(Flutter.Text(nodes[i], style: TextStyle(fontSize: 20.0)));
      } else if (nodes[i].localName == 'h3') {
        list.add(Flutter.Text(nodes[i], style: TextStyle(fontSize: 18.0)));
      } else if (nodes[i].localName == 'h3') {
        list.add(Flutter.Text(nodes[i], style: TextStyle(fontSize: 18.0)));
      } else {
        factorial(nodes[i].nodes);
      }
    }

    return list;
  }
}
