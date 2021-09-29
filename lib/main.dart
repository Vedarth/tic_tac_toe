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
        appBarTheme: AppBarTheme(centerTitle: true)),
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
  double _gridSize = 90;
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

  Color _getBackgroundColor() {
    final thisMove = lastMove == Cell.X ? Cell.O : Cell.X;

    return _getCellColor(thisMove).withAlpha(150);
  }

  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _getBackgroundColor(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getChildren(),
        ),
      );

  List<Widget> _getChildren() {
    List<Widget> children = <Widget>[
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getScoreView("Player X", _xScore, Colors.red, _size),
            _getScoreView("Player O", _oScore, Colors.blue, _size)
          ],
        ),
      ),
    ];
    children.addAll(Utils.modelBuilder(grid, (x, value) => _buildRow(x)));

    return children;
  }

  Widget _buildRow(int x) {
    final values = grid[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => _buildCell(x, y),
      ),
    );
  }

  

  Widget _buildCell(int x, int y) {
    final value = grid[x][y];
    final color = _getCellColor(value);

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(_gridSize, _gridSize),
          primary: color,
        ),
        child: Text(value, style: TextStyle(fontSize: _size)),
        onPressed: () => _selectField(value, x, y),
      ),
    );
  }

  void _selectField(String value, int x, int y) {
    if (value == Cell.none) {
      final newValue = lastMove == Cell.X ? Cell.O : Cell.X;

      setState(() {
        lastMove = newValue;
        grid[x][y] = newValue;
      });

      if (_isWinner(x, y)) {
        if (newValue == Cell.X) {
          _xScore += 1;
        } else {
          _oScore += 1;
        }
        _showEndDialog('Player $newValue Won');
      } else if (_isEnd()) {
        _showEndDialog('Undecided Game');
        setState(() {
          lastMove = Cell.none;
        });
      }
    }
  }

  bool _isEnd() =>
      grid.every((values) => values.every((value) => value != Cell.none));

  bool _isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = grid[x][y];
    final n = _numberOfCells;

    for (int i = 0; i < n; i++) {
      if (grid[x][i] == player) col++;
      if (grid[i][y] == player) row++;
      if (grid[i][i] == player) diag++;
      if (grid[i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  Color _getCellColor(String value) {
    switch (value) {
      case Cell.O:
        return Colors.blue;
      case Cell.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Padding _getScoreView(
      String player, int score, MaterialColor color, double size) {
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
            style: TextStyle(fontSize: size, color: color),
          ),
        ],
      ),
    );
  }

  void _clearScoreBoard() {
    _setEmptyCells();
    setState(() {
      _xScore = 0;
      _oScore = 0;
    });
  }

  Color _getEndGameColor(String value) {
    switch (value) {
      case Cell.O:
        return Colors.blue;
      case Cell.X:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void _increaseGrid() {
    setState(() {
      _numberOfCells += 1;
    });
    _setEmptyCells();
    Navigator.popAndPushNamed(context,'/');
  }

  void _decreaseGrid() {
    setState(() {
       _numberOfCells -= 1;
    });
    _setEmptyCells();
    Navigator.popAndPushNamed(context,'/');
  }

  void _showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title:
              Text(title, style: TextStyle(color: _getEndGameColor(lastMove))),
          content: Text('Press to Restart the Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _clearScoreBoard();
                Navigator.of(context).pop();
              },
              child: Text('Clear Score Board'),
            ),
            ElevatedButton(
              onPressed: () {
                _setEmptyCells();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                _increaseGrid();
                Navigator.of(context).pop();
              },
              child: Text('${_numberOfCells + 1} Cells'),
            ),
            if (_numberOfCells > 2)
            ElevatedButton(
              onPressed: () {
                _decreaseGrid();
                Navigator.of(context).pop();
              },
              child: Text('${_numberOfCells - 1} Cells'),
            )
          ],
        ),
      );

}
