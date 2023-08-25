import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TodoCard extends StatelessWidget {
  TodoCard(
      {super.key,
      required this.items,
      required this.index,
      required this.navigateToEditPage,
      required this.deleteById});
  List items = [];
  final int index;
  Function(Map) navigateToEditPage;
  Function(String) deleteById;
  @override
  Widget build(BuildContext context) {
    final id = items[index]['_id'];
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text("${index + 1}")),
        title: Text(items[index]['title']),
        subtitle: Text(items[index]['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == "Edit") {
              navigateToEditPage(items[index]);
            }
            if (value == "Delete") {
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Edit"),
                value: 'Edit',
              ),
              PopupMenuItem(
                child: Text("Delete"),
                value: "Delete",
              )
            ];
          },
        ),
      ),
    );
    ;
  }
}
