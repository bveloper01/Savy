import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class txList extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final Function deleteTx;
  final Function editnow;
  final ScrollController perfectScroll;
  txList(this.expenses, this.deleteTx, this.editnow, this.perfectScroll);
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> expense = expenses.reversed.toList();
    return Column(
      children: [
        Container(
          height: 46,
          padding: EdgeInsets.only(top: 11),
          child: Row(
            children: [
              Card(
                color: Color.fromARGB(255, 64, 68, 73),
                margin: EdgeInsets.only(left: 12),
                elevation: 1,
                shadowColor: Colors.black,
                /* another widget can be used here- return ListTile(leading: CircleAvator(radius :30, child: Text:'xyz'),),
                                    This can be used to add a circular shape just like a circluar card*/
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Container(
                  width: 180,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All Transactions ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.notes,
                        size: 22,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 11),
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Color.fromARGB(255, 69, 73, 77),
                        child: IconButton(
                            splashRadius: 0.1,
                            onPressed: (() {
                              expense.isEmpty
                                  ? null
                                  : perfectScroll.jumpTo(
                                      perfectScroll.position.minScrollExtent);
                            }),
                            icon: Icon(
                              Icons.expand_less_rounded,
                              size: 14,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Color.fromARGB(255, 69, 73, 77),
                        child: IconButton(
                            splashRadius: 0.1,
                            onPressed: (() {
                              expense.isEmpty
                                  ? null
                                  : perfectScroll.jumpTo(
                                      perfectScroll.position.maxScrollExtent);
                            }),
                            icon: Icon(
                              Icons.expand_more_rounded,
                              size: 14,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8.4, 7, 8.4, 0),
          height: MediaQuery.of(context).size.height - 300,
          child: expense.isEmpty
              ? Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 10, 115),
                  child: Image.asset(
                    'images/add_img.png',
                    /*fit: BoxFit
                        .cover*/
                  ),
                )
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  }, // here this is used to remove the overScrollGlow while ovre scrolling
                  child: ListView.builder(
                    controller: perfectScroll,
                    padding: const EdgeInsets.only(
                        bottom:
                            90), //this is a nice feature, using this you can add extra space at the end of your list view.
                    itemBuilder: ((ctx, index) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(3.2, 1, 3.2, 6),
                        elevation: 5.5,
                        shadowColor: Colors.black,
                        /* another widget can be used here- return ListTile(leading: CircleAvator(radius :30, child: Text:'xyz'),),
                                  This can be used to add a circular shape just like a circluar card*/
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                              extentRatio: 0.26,
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () {
                                  deleteTx(expense[index]['id']);
                                },
                              ),
                              children: [
                                SlidableAction(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  onPressed: (context) =>
                                      (deleteTx(expense[index]['id'])),
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ]),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onLongPress: () {
                              (editnow(expense[index]['id']));
                            },
                            onDoubleTap: () {
                              (editnow(expense[index]['id']));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff393F44),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Container(
                                  height: 59,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 25,
                                        child: FittedBox(
                                          child: Text(
                                            expense[index]['title'],
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.5,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 212, 212, 212)),
                                          DateFormat.yMMMMEEEEd().format(
                                            DateTime.parse(
                                                expense[index]['chosenDate']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                trailing:
                                    /* decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1.65),
                                                   ),
                                                  padding: EdgeInsets.all(5),*/

                                    Container(
                                  alignment: Alignment.centerRight,
                                  width: 123,
                                  height: 90,
                                  child: FittedBox(
                                    child: Text(
                                        style: const TextStyle(
                                          fontFamily: 'OpenSans',
                                          color:
                                              Color.fromARGB(255, 255, 221, 83),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        '₹${expense[index]['amount'].toStringAsFixed(2)} '),
                                  ),
                                ),

                                //String interpolation method used,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    itemCount: expense
                        .length, //renders to the length of the reversed expense list
                  ),
                ),
        ),
      ],
    );
  }
}
