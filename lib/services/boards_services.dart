import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/boards.dart';

class BoardsServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Boards> _boards = [];
  List<Boards> get boards => _boards;

  BoardsServices() {
    loadBoards(); // Garante que os quadros são carregados na inicialização
  }

  // Carrega os quadros do usuário autenticado
  Future<void> loadBoards() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("⚠️ Nenhum usuário autenticado!");
      return;
    }

    try {
      print("🔄 Carregando quadros para o usuário: ${user.uid}");
      QuerySnapshot snapshot = await _firestore
          .collection('boards')
          .where('userId', isEqualTo: user.uid)
          .get();

      print("✅ Quadros encontrados: ${snapshot.docs.length}");

      _boards = snapshot.docs.map((doc) {
        print(
            "📌 Quadro carregado: ${doc.data()}"); // Verifica os dados carregados
        return Boards.fromJson(doc);
      }).toList();

      notifyListeners();
    } catch (e) {
      print("❌ Erro ao carregar quadros: $e");
    }
  }

  // ✅ Método para adicionar um novo quadro
  Future<void> addBoard(String title) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    Boards newBoard = Boards(
      title: title,
      userId: user.uid,
      createdAt: Timestamp.now(),
      isFavorite: false, // Novo quadro começa sem favoritos
    );

    DocumentReference docRef =
        await _firestore.collection('boards').add(newBoard.toJson());
    newBoard.id = docRef.id;

    _boards.insert(0, newBoard);
    notifyListeners();
  }

  // ✅ Método para alternar favorito (toggleFavorite)
  Future<void> toggleFavorite(String boardId, bool isFavorite) async {
    try {
      await _firestore.collection('boards').doc(boardId).update({
        'isFavorite': isFavorite,
      });

      int index = _boards.indexWhere((board) => board.id == boardId);
      if (index != -1) {
        _boards[index].isFavorite = isFavorite;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Erro ao alternar favorito: $e");
    }
  }

  // ✅ Método para excluir um quadro (deleteBoard)
  Future<void> deleteBoard(String boardId) async {
    try {
      await _firestore.collection('boards').doc(boardId).delete();
      _boards.removeWhere((board) => board.id == boardId);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Erro ao excluir quadro: $e");
    }
  }
}
