import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Atividade {
  final int id;
  final String disciplina;
  final String descricao;
  final String dataEntrega;

  Atividade({
    required this.id,
    required this.disciplina,
    required this.descricao,
    required this.dataEntrega,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'disciplina': disciplina,
      'descricao': descricao,
      'dataEntrega': dataEntrega,
    };
  }

  @override
  String toString() {
    return 'Atividade(id: $id, disciplina: $disciplina, descricao: $descricao, dataEntrega: $dataEntrega)';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'minhas_atividades.db'),
    onCreate: (db, version) {
      return db.execute('''CREATE TABLE atividades(
          id INTEGER PRIMARY KEY,
          disciplina TEXT,
          descricao TEXT,
          dataEntrega TEXT
        )''');
    },
    version: 1,
  );

  Future<void> insertAtividade(Atividade atividade) async {
    final db = await database;

    await db.insert(
      'atividades',
      atividade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Atividade>> atividades() async {
    final db = await database;

    final List<Map<String, Object?>> atividadeMaps = await db.query('atidades');

    return [
      for (final {
            'id': id as int,
            'descricao': descricao as String,
            'disciplina': disciplina as String,
            'dataEntrega': dataEntrega as String,
          }
          in atividadeMaps)
        Atividade(
          id: id,
          disciplina: disciplina,
          descricao: descricao,
          dataEntrega: dataEntrega,
        ),
    ];
  }

  Future<void> updateAtividade(Atividade atividade) async {
    final db = await database;

    await db.update(
      'atividades',
      atividade.toMap(),
      where: 'id = ?',
      whereArgs: [atividade.id],
    );
  }

  Future<void> deleteAtividade(int id) async {
    final db = await database;

    await db.delete('atividades', where: 'id = ?', whereArgs: [id]);
  }

  var atividade1 = Atividade(
    id: 1,
    disciplina: 'Programação para Dispositivos Móveis',
    descricao: 'Criar um aplicativo com layout em colunas',
    dataEntrega: '25/05/2026',
  );

  await insertAtividade(atividade1);
  print(await atividades());

  atividade1 = Atividade(
    id: atividade1.id,
    disciplina: 'Desenvolvimento Web Front End',
    descricao: 'Criar uma página com layout responsivo',
    dataEntrega: '25/05/2026',
  );

  await updateAtividade(atividade1);
  print(await atividades());

  await deleteAtividade(atividade1.id);
  print(await atividades());
}
