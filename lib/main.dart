import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SwitchesModel(),
      child: DemoApp(),
    ),
  );
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
        child: ToggleSwitches(),
      )),
    );
  }
}

class Value {
  final names = [];
}

class SwitchesModel extends ChangeNotifier {
  int _selected = 0;
  List<int> values = [];

  void start() {
    var val = 1;
    final List<int> data = [];
    for (var i = 1; i <= 5; i++) {
      data.add(val);
      val <<= 1;
    }
    values = data;
    notifyListeners();
  }

  void change(int val) {
    if (_selected & val == 0) {
      _selected += val;
      notifyListeners();
    } else {
      _selected -= val;
      notifyListeners();
    }
  }

  int get selected => _selected;
  set selected(int val) {
    _selected = val;
    notifyListeners();
  }
}

class ToggleSwitches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SwitchesModel>(context, listen: false);
    model.start();

    return Selector<SwitchesModel, List<int>>(
      selector: (_, value) => value.values,
      builder: (_, values, __) => ListView(
        children: [
          ...values.map((value) {
            return Selector<SwitchesModel, int>(
              selector: (_, value) => value.selected,
              builder: (_, selected, __) {
                return ListTile(
                  onTap: () {},
                  trailing: Switch(
                      onChanged: (newValue) => model.change(value),
                      value: (selected & value) != 0),
                  title: const Text(
                    'スイッチ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}
