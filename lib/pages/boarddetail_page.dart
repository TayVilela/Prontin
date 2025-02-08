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
    Future.microtask(() {
      Provider.of<ListsServices>(context, listen: false)
          .loadLists(widget.board.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      appBar: AppBar(
        title: Text(
          widget.board.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: Consumer<ListsServices>(
        builder: (context, listsServices, child) {
          if (listsServices.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return listsServices.lists.isEmpty
              ? const Center(
                  child: Text("Nenhuma lista encontrada",
                      style: TextStyle(color: Colors.white)),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...listsServices.lists.map((list) {
                          return _buildListCard(context, list);
                        }).toList(),
                        _buildAddListButton(context),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  // Widget para construir um cartão de lista (semelhante ao Trello)
  Widget _buildListCard(BuildContext context, Lists list) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          // Título da Lista
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Text(
              list.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Tarefas dentro da Lista
          Expanded(
            child: Consumer<TasksServices>(
              builder: (context, tasksServices, child) {
                final tasks = tasksServices.getTasksForList(list.id!);

                return tasks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Nenhuma tarefa",
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(task.title),
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  tasksServices.toggleTaskCompletion(
                                      task.id!, value!);
                                },
                              ),
                              onLongPress: () {
                                tasksServices.deleteTask(task.id!);
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          // Botão de Adicionar Tarefa
          TextButton(
            onPressed: () => _showAddTaskDialog(context, list.id!),
            child: const Text("Adicionar Tarefa"),
          ),
        ],
      ),
    );
  }

  // Botão para adicionar novas listas (sempre visível no final)
  Widget _buildAddListButton(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextButton(
        onPressed: () => _showAddListDialog(context),
        child: const Text(
          "+ Adicionar Lista",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // Método para adicionar uma nova lista
  void _showAddListDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Lista"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<ListsServices>(context, listen: false)
                      .addList(widget.board.id!, titleController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Criar"),
            ),
          ],
        );
      },
    );
  }

  // Método para adicionar uma nova tarefa a uma lista
  void _showAddTaskDialog(BuildContext context, String listId) {
    TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nova Tarefa"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TasksServices>(context, listen: false)
                      .addTask(listId, titleController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Criar"),
            ),
          ],
        );
      },
    );
  }
}
