import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/backend/dataBaseHelper.dart';
import 'package:to_do_list/backend/model.dart';
import 'package:to_do_list/screen/AddTaskScreens.dart';

class TodoListScreeen extends StatefulWidget {
  @override
  _TodoListScreeenState createState() => _TodoListScreeenState();
}

class _TodoListScreeenState extends State<TodoListScreeen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DataBaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: task.isIncome == 'Income' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: task.isIncome == 'Income'
                    ? Colors.green[200]
                    : Colors.red[200],
                child: task.isIncome == 'Income'
                    ? Text(
                        "Income",
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.green[900]),
                      )
                    : Text("Expense",
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.red[900])),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Source: ${task.title}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Category: ${task.category}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  'INR ${task.amount} on ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${_dateFormat.format(task.date)}',
                    style: TextStyle(
                      fontSize: 15,
                    )),
              ],
            ),
            trailing: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => addNewTask(
                              task: task,
                              updateTaskList: _updateTaskList,
                            ))),
                icon: Icon(
                  Icons.delete,
                  size: 35.0,
                )),
          ),
          Divider()
        ],
      ),
    );
  }

  // widget tile for showing current month data;
  Widget _totalTile(int totalIncome, int totalExpense) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.grey[400]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Currrent Month Info",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    "Total income:    ",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                  Text(
                    "INR $totalIncome",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Total Expense:  ",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                  Text(
                    "INR $totalExpense",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Balance:  ",
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                  Text(
                    "INR ${totalIncome - totalExpense}",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Budget Management")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => addNewTask(
                        updateTaskList: _updateTaskList,
                      )));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            int totalIn = 0, totalEx = 0;
            var now = new DateTime.now();

            // this loop is used to find totalIncome and totalExpense of current month;

            for (var i = 0; i < snapshot.data.toList().length; i++) {
              if (snapshot.data[i].date.month == now.month) {
                if (snapshot.data[i].isIncome == "Income") {
                  totalIn += snapshot.data[i].amount;
                } else {
                  totalEx += snapshot.data[i].amount;
                }
              }
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return _totalTile(totalIn, totalEx);
                }
                return _buildTask(snapshot.data[i - 1]);
              },
            );
          }),
    );
  }
}
