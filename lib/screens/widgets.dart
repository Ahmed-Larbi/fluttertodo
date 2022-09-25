// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String? title;
  final String? desc;
  TaskCard({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
                color: Color(0xFF211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              desc ?? "No Description Added",
              style: TextStyle(
                  color: Color(0xFF86829D),
                  fontSize: 16.0,
                  height: 1.5,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;

  const TodoWidget({
    this.text,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Container(
                width: 25.0,
                height: 26.0,
                margin: EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: isDone
                    ? Icon(Icons.check_box)
                    : Icon(Icons.hourglass_empty)),
            Flexible(
              child: Text(
                text ?? "(unnamed todo)",
                style: TextStyle(
                    color: isDone ? Color(0xFF86829D) : Color(0xFF211551),
                    fontSize: 16.0,
                    fontWeight: isDone ? FontWeight.w500 : FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}

class ScrollBehaviorr extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
