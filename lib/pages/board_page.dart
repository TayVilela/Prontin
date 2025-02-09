import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontin/services/boards_services.dart';
import 'package:prontin/pages/boarddetail_page.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      appBar: AppBar(
        title:
            const Text("Meus Quadros", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<BoardsServices>(
          builder: (context, boardsServices, child) {
            if (boardsServices.boards.isEmpty) {
              return const Center(
                  child: Text("Nenhum quadro encontrado",
                      style: TextStyle(color: Colors.white)));
            }
            return ListView.builder(
              itemCount: boardsServices.boards.length,
              itemBuilder: (context, index) {
                final board = boardsServices.boards[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      board.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        board.isFavorite ? Icons.star : Icons.star_border,
                        color: board.isFavorite ? Colors.yellow : Colors.grey,
                      ),
                      onPressed: () {
                        Provider.of<BoardsServices>(context, listen: false)
                            .toggleFavorite(board.id!, !board.isFavorite);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardDetailPage(
                              board: board), // Passa o objeto Board inteiro
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Excluir Quadro"),
                            content: const Text(
                                "Deseja realmente excluir este quadro?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<BoardsServices>(context,
                                          listen: false)
                                      .deleteBoard(board.id!);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text("Excluir"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBoardDialog(context),
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showBoardDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Novo Quadro"),
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
                  Provider.of<BoardsServices>(context, listen: false)
                      .addBoard(titleController.text);
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
