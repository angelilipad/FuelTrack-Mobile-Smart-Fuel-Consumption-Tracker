/* 
FuelTrack Mobile Application
Angelica Jarvina & Nick Gaela
Final Project
*/

import 'package:flutter/material.dart';

void main() {
  runApp(FuelTrackApp());
}

class FuelTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class FuelRecord {
  double liters;
  double distance;
  double cost;

  FuelRecord(this.liters, this.distance, this.cost);

  double get efficiency {
    if (liters == 0) return 0;
    return distance / liters;
  }
}

/* LOGIN SCREEN */

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();

  void login() {
    if (nameController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(username: nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}

/* HOME SCREEN */

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FuelRecord> records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FuelTrack - ${widget.username}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddScreen(records: records)));
                },
                child: Text('Add Record')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ViewScreen(records: records)));
                },
                child: Text('View Records')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SummaryScreen(records: records)));
                },
                child: Text('Summary')),
          ],
        ),
      ),
    );
  }
}

/* ADD SCREEN */

class AddScreen extends StatefulWidget {
  final List<FuelRecord> records;

  AddScreen({required this.records});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final litersController = TextEditingController();
  final distanceController = TextEditingController();
  final costController = TextEditingController();

  void save() {
    double liters = double.tryParse(litersController.text) ?? 0;
    double distance = double.tryParse(distanceController.text) ?? 0;
    double cost = double.tryParse(costController.text) ?? 0;

    setState(() {
      widget.records.add(FuelRecord(liters, distance, cost));
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Record')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(controller: litersController, decoration: InputDecoration(labelText: 'Liters'), keyboardType: TextInputType.number),
            TextField(controller: distanceController, decoration: InputDecoration(labelText: 'Distance'), keyboardType: TextInputType.number),
            TextField(controller: costController, decoration: InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(onPressed: save, child: Text('Save'))
          ],
        ),
      ),
    );
  }
}

/* VIEW + CRUD SCREEN */

class ViewScreen extends StatefulWidget {
  final List<FuelRecord> records;

  ViewScreen({required this.records});

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {

  void delete(int index) {
    setState(() {
      widget.records.removeAt(index);
    });
  }

  void edit(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditScreen(record: widget.records[index])))
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Records')),
        body: ListView.builder(
            itemCount: widget.records.length,
            itemBuilder: (context, index) {
              var r = widget.records[index];
              return ListTile(
                title: Text('L:${r.liters} D:${r.distance} C:${r.cost}'),
                subtitle: Text('Eff: ${r.efficiency.toStringAsFixed(2)} km/L'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () => edit(index)),
                    IconButton(icon: Icon(Icons.delete), onPressed: () => delete(index)),
                  ],
                ),
              );
            }));
  }
}

/* EDIT SCREEN */

class EditScreen extends StatefulWidget {
  final FuelRecord record;

  EditScreen({required this.record});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController litersController;
  late TextEditingController distanceController;
  late TextEditingController costController;

  @override
  void initState() {
    litersController = TextEditingController(text: widget.record.liters.toString());
    distanceController = TextEditingController(text: widget.record.distance.toString());
    costController = TextEditingController(text: widget.record.cost.toString());
    super.initState();
  }

  void update() {
    widget.record.liters = double.tryParse(litersController.text) ?? 0;
    widget.record.distance = double.tryParse(distanceController.text) ?? 0;
    widget.record.cost = double.tryParse(costController.text) ?? 0;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Record')),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(controller: litersController, decoration: InputDecoration(labelText: 'Liters'), keyboardType: TextInputType.number),
              TextField(controller: distanceController, decoration: InputDecoration(labelText: 'Distance'), keyboardType: TextInputType.number),
              TextField(controller: costController, decoration: InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
              SizedBox(height: 10),
              ElevatedButton(onPressed: update, child: Text('Update'))
            ],
          ),
        ));
  }
}

/* SUMMARY SCREEN */

class SummaryScreen extends StatelessWidget {
  final List<FuelRecord> records;

  SummaryScreen({required this.records});

  double totalCost() {
    double total = 0;
    for (var r in records) {
      total += r.cost;
    }
    return total;
  }

  double totalDistance() {
    double total = 0;
    for (var r in records) {
      total += r.distance;
    }
    return total;
  }

  double avgEfficiency() {
    if (records.isEmpty) return 0;
    double total = 0;
    for (var r in records) {
      total += r.efficiency;
    }
    return total / records.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Summary')),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Total Cost: ${totalCost().toStringAsFixed(2)}'),
              Text('Total Distance: ${totalDistance().toStringAsFixed(2)}'),
              Text('Average Efficiency: ${avgEfficiency().toStringAsFixed(2)}'),
            ],
          ),
        ));
  }
}
