import 'package:flutter/material.dart';
import 'package:nihongo_courses/models/word.dart';
import 'package:nihongo_courses/widgets/word_item_details.dart';

class SessionPage extends StatefulWidget {
  SessionPage(this.items);

  final List<WordItem> items;

  @override
  _SessionPageState createState() => _SessionPageState();
}

enum Phase {
  NEW_WORD,
  TEST,
}

class _SessionPageState extends State<SessionPage> {
  var _phases = List<dynamic>();
  var _currentIndex = 0;

  get _currentPhase {
    return _phases[_currentIndex];
  }

  @override
  void initState() {
    super.initState();
    _phases = _buildPhases(widget.items);
  }

  List<dynamic> _buildPhases(items) {
    var list = [];

    for (var i = 0; i < items.length - 1; i += 2) {
      list.add({"item": items[i], "phase": Phase.NEW_WORD});
      list.add({"item": items[i + 1], "phase": Phase.NEW_WORD});

      list.add({"item": items[i], "phase": Phase.TEST});
      list.add({"item": items[i + 1], "phase": Phase.TEST});
    }

    var randoms = [];
    for (var i = 0; i < items.length; i++) {
      randoms.add({"item": items[i], "phase": Phase.TEST});
    }
    randoms.shuffle();

    list.addAll(randoms);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFF736AB7),
        child: Stack(
          children: <Widget>[
            _buildContent(),
            _buildToolbar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff43cea2),
            const Color(0xff185a9d),
          ],
          stops: [0.0, 1.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _currentPhase["phase"] == Phase.TEST
                ? _buildTest(_currentPhase["item"])
                : _buildItem(_currentPhase["item"]),
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  value: (_currentIndex + 1) / _phases.length,
                ),
                FlatButton(
                  padding: const EdgeInsets.all(16.0),
                  color: Color(0xffffbf69),
                  shape: ContinuousRectangleBorder(),
                  textColor: Colors.white,
                  child: Text("CONTINUE"),
                  onPressed: _nextPhase,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BackButton(color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTest(WordItem item) {
    // var test = Random().nextInt(3);
    /*switch (test) {
      case 0:
        return Test1(item);
      case 1:
        return Test2(item);
      case 2:
        return Test3(item);
    }*/
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(top: 72.0),
      child: Center(child: Text("TEST")),
    );
  }

  Widget _buildItem(WordItem item) {
    return WordItemDetails(item);
  }

  void _nextPhase() {
    setState(() {
      _currentIndex++;
    });
  }
}
