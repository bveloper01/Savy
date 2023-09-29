// import 'package:expensetracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bars.dart';

class Chart extends StatelessWidget {
  final List<Map<String, dynamic>>
      recentTX; // it is all transactions of the last week
  Chart(this.recentTX);

  List<Map<String, Object>> get groupedTxValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(
        days: index,
      ));
      double totalSumOfTx = 0.0;
      for (var i = 0; i < recentTX.length; i++) {
        final transactionDate = DateTime.parse(recentTX[i]['chosenDate']);
        if (transactionDate.day == weekDay.day &&
            transactionDate.month == weekDay.month &&
            transactionDate.year == weekDay.year) {
          totalSumOfTx += recentTX[i]['amount'];
        }
      }
      return {
        'Day': DateFormat('EEEE', 'en_US').format(weekDay),
        'amount': totalSumOfTx,
      };
    });
  }

// this recentTx is being used to get the transactions of that day, to fetch the data from the list
  double get totalSpending {
    // this function gives us the total sum of the entire week
    return groupedTxValues.fold(0.0, (sum, item) {
      //here sum is the total amount and item is element we are looking at
      return sum +
          (item['amount']
              as double); // this will give all the totals for each day also here we telling dart that this value here will be of type double
    }); // here sum and element are being passed
  } //0.0 is the starting value

  @override
  Widget build(BuildContext context) {
    // print(groupedTxValues);
    return Container(
      color: Colors.black26,
      height: 175,
      //do not change card to const constructor
      padding: EdgeInsets.fromLTRB(9, 7, 9, 0), //left, top, right, bottom
      // color: Color.fromARGB(255, 251, 251,212), //arguments like color should be defined outside of the SizedBOx
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        }, // here this is used to remove the overScrollGlow while ovre scrolling
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: groupedTxValues.map((txData) {
                    /*Flexible and Expanded(
                    flex: 1,
                    fit: FlexFit.tight,), - fit to flexfit type in Expanded widget 
              Flexible widget allows to set constraints to the column or row and space aroung it*/
                    return chartBartx(
                        (txData['Day'] as String),
                        (txData['amount'] as double),
                        totalSpending == 0.0
                            ? 0.0
                            : (txData['amount'] as double) / totalSpending);
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.more_horiz_rounded)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
