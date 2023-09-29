import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 5, top: 2, bottom: 2),
      // width: 72,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: (() {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            context: context,
            builder: (BuildContext context) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (() {
                  Navigator.pop(context);
                }),
                child: Container(
                  padding: EdgeInsets.all(12),
                  height: 215,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 145,
                            height: 55,
                            child: Card(
                              color: Color.fromARGB(255, 255, 221, 83),
                              elevation: 5,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Hola ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27,
                                        color: Colors.black),
                                  ),
                                  Icon(Icons.waving_hand_rounded,
                                      size: 28, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.2),
                          Container(
                            margin: EdgeInsets.only(left: 5.5, right: 5.5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                      "Introducing Savy's inaugural version!",
                                      style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white)),
                                ),
                                Text(
                                    "With this release, you can effortlessly monitor your daily expenses and get weekly spending summaries, making financial management a breeze. Plus, we've got some cool updates in the pipeline – stay tuned for more!",
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.8,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
        child: Card(
          color: Color(0xff393F44),
          child: Image.asset('images/meow.png', fit: BoxFit.cover),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
