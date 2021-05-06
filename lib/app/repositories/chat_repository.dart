import 'dart:io';

import 'package:nagazap/app/shared/models/message.dart';
import 'package:path_provider/path_provider.dart';

abstract class IChatRepository {}

class ChatRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/messages.txt');
  }

  Future<List<Message>> getMessages() async {
    try {
      final file = await _localFile;
      final contents = (await file.readAsString()).split(' ');
      contents.removeWhere((element) => element.isEmpty);
      List<Message> messages =
          contents.map((e) => Message.fromJson(e)).toList();
      return messages;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<Map<String, List<Message?>>> getLastMessagesForRoom() async {
    try {
      final messages = await getMessages();
      final List<String> rooms = [];
      final msgs = Map<String, List<Message?>>();

      rooms.addAll(
        messages.map((e) {
          if (!rooms.contains(e.room)) {
            return e.room;
          }
          return '';
        }),
      );
      rooms.removeWhere((element) => element == '');

      rooms.forEach((element) {
        msgs[element] = messages.map((e) {
          if (e.room == element) {
            return e;
          }
        }).toList()
          ..removeWhere((element) => element == null);
      });
      return msgs;
    } catch (e) {
      print(e);
      return Map();
    }
  }
}
