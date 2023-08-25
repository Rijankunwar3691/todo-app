// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as htttp;
import 'package:todo/services/todo_services.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final BuildContext context; // Add this line to store the context
  Map? todo;

  AddTodoPage({Key? key, required this.context, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool isEdit = false;

  TextEditingController titlecontroller = TextEditingController();

  TextEditingController descriptioncontroller = TextEditingController();

  Future<void> submitdata() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final isSucess = await TodoServices.addTodo(body);
    if (isSucess) {
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      showsucessMessage(widget.context, 'Creation succesful');
    } else {
      showsucessMessage(widget.context, 'Creation failed');
    }
  }

  Future<void> updatedata() async {
    final id = widget.todo!['_id'];
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final isSucess = await TodoServices.updatedata(id, body);

    if (isSucess) {
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      showsucessMessage(widget.context, 'Update succesful');
    } else {
      showsucessMessage(widget.context, 'Update failed');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      titlecontroller.text = widget.todo!['title'];
      descriptioncontroller.text = widget.todo!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit ToDo' : 'Add ToDo'),
        centerTitle: true,
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          controller: titlecontroller,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: descriptioncontroller,
          decoration: const InputDecoration(hintText: "Description"),
          minLines: 5,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: isEdit ? updatedata : submitdata,
            child: Text(isEdit ? 'update' : "Submit"))
      ]),
    );
  }
}
