import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/lists.dart';

class ListsServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Lists> _lists = [];
  bool isLoading = false;

  List<Lists> get lists => _lists;

  Future<void> loadLists(String boardId) async {
    isLoading = true;
    notifyListeners();

    try {
      print("🔄 Carregando listas do quadro: $boardId");

      QuerySnapshot snapshot = await _firestore
          .collection('lists')
          .where('boardId', isEqualTo: boardId)
          .orderBy('createdAt', descending: false)
          .get();

      _lists = snapshot.docs.map((doc) => Lists.fromJson(doc)).toList();
      print("📌 Listas carregadas: ${_lists.length}");
      
    } catch (e) {
      print("❌ Erro ao carregar listas: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addList(String boardId, String title) async {
    try {
      DocumentReference docRef = await _firestore.collection('lists').add({
        'boardId': boardId,
        'title': title,
        'createdAt': Timestamp.now(),
      });

      Lists newList = Lists(id: docRef.id, boardId: boardId, title: title, createdAt: Timestamp.now());
      
      _lists.add(newList);
      notifyListeners();
    } catch (e) {
      print("❌ Erro ao adicionar lista: $e");
    }
  }
}
