import 'package:flutter/material.dart';
import 'package:todo/screens/add_page.dart';
import 'package:todo/services/todo_services.dart';
import 'package:todo/widgets/todo_card.dart';

import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isloading = true;
  Future<void> fetchdata() async {
    final response = await TodoServices.fetchdata();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showsucessMessage(context, 'Something went wrong');
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> deleteById(id) async {
    final isSucess = await TodoServices.deleteById(id);
    if (isSucess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showsucessMessage(context, 'Deletion failed');
    }
  }

  Future<void> navigateToTodoPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(context: context),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchdata();
  }

  Future<void> navigateToEditPage(Map items) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(context: context, todo: items),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchdata();
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToTodoPage(context);
        },
        label: const Text("Add Todo"),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchdata,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (BuildContext context, int index) {
                return TodoCard(
                  index: index,
                  deleteById: deleteById,
                  navigateToEditPage: navigateToEditPage,
                  items: items,
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
