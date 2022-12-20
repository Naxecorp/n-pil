import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

class EndCourses extends StatefulWidget {
  const EndCourses({super.key});

  @override
  EndCoursesState createState() => EndCoursesState();
}

const z_min = Colors.green;
const z_max = Colors.green;
const y_min = Colors.green;
const y_max = Colors.green;
const x_min = Colors.green;
const x_max = Colors.green;

class EndCoursesState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.orange,
        child: Center(
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: z_min,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              color: y_min,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              color: y_max,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: z_max,
                      )
                    ],
                  )),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: x_min,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: x_max,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
