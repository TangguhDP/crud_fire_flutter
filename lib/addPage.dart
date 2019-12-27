import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  AddPage({this.emailUser});
  final String emailUser;
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  DateTime _dueDate = DateTime.now();
  String _dateText = '';
  String newTask = '';
  String note = '';
  Future<Null> _selectDueDate(_) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addData() {
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('task');
      await reference.add({
        "email" : widget.emailUser,
        "title" : newTask,
        "duedate" : _dueDate,
        "note" : note
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Page"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String str) {
                setState(
                  () {
                    newTask = str;
                  },
                );
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'New Task',
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Icon(Icons.date_range),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "Due Date",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                FlatButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    _dateText,
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              maxLines: 5,
              onChanged: (String str) {
                setState(
                  () {
                    note = str;
                  },
                );
              },
              decoration: InputDecoration(
                labelText: "Notes",
                icon: Icon(
                  Icons.note,
                  color: Colors.black,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () => _addData(),
                  icon: Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.cancel,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
