import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontin/models/boards.dart';
import 'package:prontin/models/lists.dart';
import 'package:prontin/services/lists_services.dart';
import 'package:prontin/services/tasks_services.dart';

class BoardDetailPage extends StatefulWidget {
  final Boards board;

  const BoardDetailPage({super.key, required this.board});

  @override
  _BoardDetailPageState createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final listsServices = Provider.of<ListsServices>(context, listen: false);
      final tasksServices = Provider.of<TasksServices>(context, listen: false);

      await listsServices.loadLists(widget.board.id!);
      await tasksServices
          .loadTasksForLists(listsServices.lists.map((e) => e.id!).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      appBar: AppBar(
        title: Text(widget.board.title,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
      ),
      body: Consumer2<ListsServices, TasksServices>(
        builder: (context, listsServices, tasksServices, child) {
          if (listsServices.isLoading || tasksServices.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return listsServices.lists.isEmpty
              ? const Center(
                  child: Text("Nenhuma lista encontrada",
                      style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listsServices.lists.map((list) {
                      return _buildListCard(context, list, tasksServices);
                    }).toList(),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildListCard(
      BuildContext context, Lists list, TasksServices tasksServices) {
    final tasks = tasksServices.tasksByList[list.id!] ?? [];

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.teal[700],
            child: Text(list.title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Text("Nenhuma tarefa",
                    style: TextStyle(color: Colors.grey))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) => tasksServices
                              .toggleTaskCompletion(task.id!, list.id!, value!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
