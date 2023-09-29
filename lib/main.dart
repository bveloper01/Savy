import './widgets/sql_helper.dart';
import './widgets/appbar.dart';
import 'package:intl/intl.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import './widgets/list.dart';

void main() async {
  // Preserve the splash screen.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());

  // Wait for 2 seconds.
  await Future.delayed(Duration(seconds: 1, milliseconds: 130));

  // Remove the splash screen.
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Savy',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _usertxs = [];
  DateTime? chosenDate; // Initialize with the current date
  ScrollController _controller = ScrollController();
  bool _isLoading = true;
  void _addnewTxs() async {
    final txs = await SQLHelper.getTransactions();
    setState(() {
      _usertxs = txs;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _addnewTxs();
  }

  List<Map<String, dynamic>> get _recentTX {
    // Filter transactions that have a valid chosenDate and happened in the last week
    return _usertxs.where((tx) {
      final chosenDateStr = tx['chosenDate'];

      if (chosenDateStr == null) {
        // Handle cases where chosenDate is missing
        return false;
      }

      final chosenDate = DateTime.tryParse(chosenDateStr);

      if (chosenDate == null) {
        // Handle cases where chosenDate is not a valid DateTime
        return false;
      }

      return chosenDate.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  final titlecontroller = TextEditingController();
  final amountcontroller = TextEditingController();

  Future<void> addItem() async {
    double enteredAmount = double.parse(amountcontroller.text);
    await SQLHelper.createTransaction(
        enteredAmount, chosenDate!, titlecontroller.text);
    _addnewTxs();
  }

  Future<void> updateItem(int id) async {
    double enteredAmount = double.parse(amountcontroller.text);
    await SQLHelper.edittx(
        id, enteredAmount, chosenDate!, titlecontroller.text);
    _addnewTxs();
  }

  void deletetrx(int id) async {
    await SQLHelper.deletetx(id);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.black87,
      duration: Duration(seconds: 1, milliseconds: 70),
      content: Center(
        child: Text(
          "Succesfully deleted a transaction",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
    _addnewTxs();
  }

  void startAddNewTx(int? id) async {
    if (id != null) {
      final extusertxs = _usertxs.firstWhere((element) => element['id'] == id);
      titlecontroller.text = extusertxs['title'];
      amountcontroller.text = extusertxs['amount'].toString();
      chosenDate = DateTime.parse(extusertxs['chosenDate']);
    } else {
      // Clear the data when adding a new transaction
      titlecontroller.text = '';
      amountcontroller.text = '';
      chosenDate = null;
    }
    final picking = MediaQuery.of(context).size.height;
    FocusNode _titleFocusNode = FocusNode();

    void presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2008),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(255, 255, 221, 83), // <-- SEE HERE
                onPrimary: Colors.black, // <-- SEE HERE
                onSurface: Colors.white, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Color.fromARGB(255, 255, 221, 83), // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      ).then((pickedDate) {
        //adding custom date to the transactions
        if (pickedDate == null) {
          return;
        }
        setState(() {
          chosenDate = pickedDate;
        });
        // Request focus on the Title TextField
        Future.delayed(Duration(milliseconds: 130), () {
          _titleFocusNode.requestFocus();
        });
      }); //furture can also be used in http requests where you wait for response from the user
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      //showModalBottomSheet is available in staterfulwidget
      builder: (_) => Container(
        height: picking - 94,
        padding: EdgeInsets.fromLTRB(
            9, 23, 9, MediaQuery.of(context).viewInsets.bottom + 14),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      autofocus: true,
                      maxLength: 12,
                      textAlign: TextAlign.center,
                      cursorColor: Color.fromARGB(255, 255, 221, 83),
                      decoration: InputDecoration(
                        counterText: '',
                        labelText: '₹',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 25),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(color: Colors.red, width: 0.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(color: Colors.red, width: 0.5),
                        ),
                      ),
                      controller: amountcontroller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 47,
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: presentDatePicker,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(23.0),
                              ),
                              padding: EdgeInsets.fromLTRB(15, 22, 10, 22),
                              child: FittedBox(
                                child: Text(
                                    style: TextStyle(
                                        fontSize: 15.5, color: Colors.white),
                                    chosenDate == null
                                        ? 'Select date'
                                        : DateFormat('EEEE, dd/MM/yyyy')
                                            .format(chosenDate!)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.5),
                        FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 255, 221, 83),
                          elevation: 1.9,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                          foregroundColor: Colors.black,
                          onPressed: presentDatePicker,
                          child: Icon(Icons.date_range_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    // width: 588.5,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      maxLength: 45,
                      textAlign: TextAlign.center,
                      cursorColor: Color.fromARGB(255, 255, 221, 83),
                      decoration: InputDecoration(
                        counterStyle:
                            TextStyle(fontSize: 10, color: Colors.white),
                        labelText: 'Title',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 15.8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                      ),
                      controller: titlecontroller,
                      //manually triggering our function by calling the function with '()'
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                      focusNode: _titleFocusNode,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 97, 97, 97),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      // width: 380,
                      // height: 70,
                      margin: EdgeInsets.all(3),
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                          "'Swipe left to delete' and 'Long-press or double-tap to edit' items in the list.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor: Color.fromARGB(255, 255, 221, 83),
                      ),
                      child: Container(
                        height: 46,
                        width: MediaQuery.of(context).size.width - 90,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                id == null
                                    ? "Add Transaction"
                                    : "Update Transaction"),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _usertxs.isEmpty
                            ? null
                            : _controller
                                .jumpTo(_controller.position.minScrollExtent);
                        // Validate input fields
                        if (titlecontroller.text.isEmpty ||
                            amountcontroller.text.isEmpty ||
                            chosenDate == null) {
                          // Show a dialog or snackbar to inform the user that input is incomplete.
                          return; // Exit the onPressed function without adding/updating.
                        }

                        if (id == null) {
                          await addItem();
                        } else {
                          await updateItem(id);
                        }

                        // Clear input fields and reset the date
                        titlecontroller.text = '';
                        amountcontroller.text = '';
                        chosenDate =
                            null; // Assuming `selectedDate` is your DateTime variable.

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      appBar: AppBar(
        toolbarHeight: 57,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0))),
        backgroundColor: Color(0xff393F44),
        centerTitle: true,
        title: Container(
          height: 110,
          margin: EdgeInsets.only(left: 17),
          child: Image.asset('images/logo.png'),
        ),
        actions: [
          appBar(),
        ],
      ), //_startAddNewTx required build context to show newmodalsheet
      // and here we are calling it as an anonymus function to call it manually and
      //forward context value here
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return false;
        }, // here this is used to remove the overScrollGlow while ovre scrolling
        child: SingleChildScrollView(
          child: Column(
            children: [
              Chart(_recentTX), //dynamically generated property - _recentTX
              txList(_usertxs, deletetrx, startAddNewTx,
                  _controller), //here we passed _usertxs list into txList function
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(255, 255, 221, 83),
        onPressed: () => startAddNewTx(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
