import 'package:flutter/material.dart';
import 'package:tic_tac_toe/cell.dart';
import 'package:tic_tac_toe/helper.dart';

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
  int _numberOfCells = 3;
  double _size = 32;
  double _gridSize = 114;
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
        _numberOfCells,
        (_) => List.generate(_numberOfCells, (_) => Cell.none),
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
    children.addAll(Utils.modelBuilder(grid, (x, value) => buildRow(x)));

    return children;
  }

  Widget buildRow(int x) {
    final values = grid[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Widget buildField(int x, int y) {
    final value = grid[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(_gridSize, _gridSize),
          primary: color,
        ),
        child: Text(value, style: TextStyle(fontSize: 32)),
        onPressed: () => _setEmptyCells(),
      ),
    );
  }

  Color getFieldColor(String value) {
    switch (value) {
      case Cell.O:
        return Colors.blue;
      case Cell.X:
        return Colors.red;
      default:
        return Colors.white;
    }
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
