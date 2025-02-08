import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/lists.dart';

class ListsServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Lists> _lists = [];
  List<Lists> get lists => _lists;

  Future<void> loadLists(String boardId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lists')
          .where('boardId', isEqualTo: boardId)
          .orderBy('createdAt',
              descending: true) // Certifique-se de que este campo está indexado
          .get();

      _lists = snapshot.docs.map((doc) => Lists.fromJson(doc)).toList();
      print("✅ Listas carregadas com sucesso: ${_lists.length}");
    } catch (e) {
      debugPrint("Erro ao carregar listas: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Atualiza a interface
    }
  }

  Future<void> addList(String boardId, String title) async {
    try {
      DocumentReference docRef = await _firestore.collection('lists').add({
        'title': title,
        'boardId': boardId,
        'createdAt': Timestamp.now(),
      });

      Lists newList = Lists(
        id: docRef.id,
        title: title,
        boardId: boardId,
        createdAt: Timestamp.now(),
      );

      _lists.insert(0, newList);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao adicionar lista: $e");
    }
  }
}
