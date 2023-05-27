import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/backend/dataBaseHelper.dart';
import 'package:to_do_list/backend/model.dart';

class addNewTask extends StatefulWidget {
  final Function updateTaskList;
  final Task task;

  const addNewTask({Key key, this.task, this.updateTaskList}) : super(key: key);

  @override
  _addNewTaskState createState() => _addNewTaskState();
}

class _addNewTaskState extends State<addNewTask> {
  final _formKey = GlobalKey<FormState>();
  String _isIncome;
  String _title = '';
  String _category;
  int _amount;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final List<String> is_income_list = ["Income", "Expense"];
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    if (widget.task != null) {
      _title = widget.task.title;
      _date = widget.task.date;
      _category = widget.task.category;
      _amount = widget.task.amount;
    }
    super.initState();
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_isIncome, $_title,$_category, $_amount  $_date,');

      Task task = Task(
          title: _title,
          date: _date,
          amount: _amount,
          isIncome: _isIncome,
          category: _category);
      if (widget.task == null) {
        DataBaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        DataBaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DataBaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    widget.task == null ? 'Add Entry' : 'Update Entry',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: is_income_list.map((String priority) {
                            return DropdownMenuItem(
                              child: Text(
                                priority,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              value: priority,
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Choose',
                            labelStyle: TextStyle(fontSize: 18.0),
                          ),
                          validator: (input) => is_income_list == null
                              ? 'please select a priority'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _isIncome = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Source of income/expense',
                            labelStyle: TextStyle(fontSize: 18.0),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter source of income/expense'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Category',
                            labelStyle: TextStyle(fontSize: 18.0),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter a Category'
                              : null,
                          onSaved: (input) => _category = input,
                          initialValue: _category,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Amount in INR',
                            labelStyle: TextStyle(fontSize: 18.0),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter amount'
                              : null,
                          onSaved: (input) => _amount = int.parse(input),
                          initialValue: "",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          onTap: _handleDatePicker,
                          controller: _dateController,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Date',
                            labelStyle: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: MaterialButton(
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          onPressed: () => _submit(),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      widget.task != null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: MaterialButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                onPressed: () => _delete(),
                              ))
                          : SizedBox.shrink()
                    ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
