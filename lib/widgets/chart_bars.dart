import 'package:flutter/material.dart';

class chartBartx extends StatelessWidget {
  final String label; // this hold the weekDay
  final double spendingAmount;
  final double spendingPctOfTotal;

  chartBartx(this.label, this.spendingAmount, this.spendingPctOfTotal);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 259,
      margin: EdgeInsets.fromLTRB(0.5, 4, 9.5, 0), //left, top, right, bottom
      child: Card(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        elevation: 5,
        color: Color(0xff393F44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 210,
              margin: EdgeInsets.fromLTRB(2, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      '₹${spendingAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 0.1,
            ),
            Container(
              height: 12,
              width: 210,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.0),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 221, 83),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            FittedBox(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'QSuicksand',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
