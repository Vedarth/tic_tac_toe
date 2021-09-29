import 'package:flutter/material.dart';
import 'package:tic_tac_toe/cell.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Tic Tac Toe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _matrixSize = 3;
  double _size = 0;
  int _xScore = 0;
  int _oScore = 0;

  String lastMove = Cell.none;
  late List<List<String>> grid;

  @override
  void initState() {
    super.initState();

    _setEmptyCells();
  }

  void _setEmptyCells() => setState(() => grid = List.generate(
        _matrixSize,
        (_) => List.generate(_matrixSize, (_) => Cell.none),
      ));

  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getChildren(),
        ),
      );

  List<Widget> getChildren() {
    List<Widget> children = <Widget>[
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getScoreView("Player X", _xScore, Colors.red, _size),
            getScoreView("Player O", _oScore, Colors.blue, _size)
          ],
        ),
      ),
    ];

    return children;
  }

  Padding getScoreView(String player, int score, MaterialColor color, double size) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            player,
            style: TextStyle(
                fontSize: size, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            score.toString(),
            style: TextStyle(fontSize: 32, color: color),
          ),
        ],
      ),
    );
  }

}
