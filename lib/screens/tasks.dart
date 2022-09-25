import 'package:flutter/material.dart';
import 'package:todo_flutter/database_helper.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/screens/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  const TaskPage({required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String? _taskTitle = "";
  int? _taskId = 0;
  String? _taskDesc = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      // Set visiblity to true if task is not null
      _contentVisible = true;
      _taskTitle = widget.task?.title;
      _taskDesc = widget.task?.description;
      _taskId = widget.task?.id;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    print("Id: ${widget.task?.id}");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(Icons.backspace),
                        ),
                      ),
                      // Task Adding
                      Expanded(
                          child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (widget.task == null) {
                              Task _newTask =
                                  Task(title: value, description: "");
                              _taskId = await _dbHelper.insertTask(_newTask);
                              print("new task is $_taskId");
                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                            } else {
                              _dbHelper.updateTaskTitle(_taskId!, value);
                              print("Task updated");
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        // Task title
                        controller: TextEditingController()..text = _taskTitle!,
                        decoration: InputDecoration(
                          hintText: "Enter Task headline",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551)),
                      ))
                    ],
                  ),
                ),
                // Task Description
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (_taskId != 0) {
                            await _dbHelper.updateTaskDesc(_taskId!, value);
                            _taskDesc = value;
                          }
                        }
                        _todoFocus.requestFocus();
                      },
                      controller: TextEditingController()..text = _taskDesc!,
                      focusNode: _descriptionFocus,
                      decoration: InputDecoration(
                          hintText: "Enter Task description",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 24.0)),
                    ),
                  ),
                ),

                // Todo listView
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskId!),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data?[index].isDone == 0) {
                                    _dbHelper.updateTaskisDone(
                                        snapshot.data?[index].id, 1);
                                  } else {
                                    _dbHelper.updateTaskisDone(
                                        snapshot.data?[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data?[index].title,
                                  isDone: snapshot.data?[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Container(
                            width: 25.0,
                            height: 26.0,
                            margin: EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Icon(Icons.hourglass_empty)),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController()..text = "",
                            focusNode: _todoFocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (_taskId != 0) {
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: _taskId,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  print("new Todo has been Added");
                                } else {
                                  print("update the Todo");
                                }
                                _todoFocus.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () {
                      if (_taskId != 0) {
                        _dbHelper.deleteTask(_taskId!);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
