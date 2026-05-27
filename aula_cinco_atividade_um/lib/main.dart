import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ─────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────
class Entrega {
  final int? id;
  final String codigo;
  final String destinatario;
  final String endereco;
  final String status;
  final double latitude;
  final double longitude;
  final String dataHora;

  Entrega({
    this.id,
    required this.codigo,
    required this.destinatario,
    required this.endereco,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.dataHora,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'codigo': codigo,
      'destinatario': destinatario,
      'endereco': endereco,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'dataHora': dataHora,
    };
  }

  Entrega copyWith({
    int? id,
    String? codigo,
    String? destinatario,
    String? endereco,
    String? status,
    double? latitude,
    double? longitude,
    String? dataHora,
  }) {
    return Entrega(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      destinatario: destinatario ?? this.destinatario,
      endereco: endereco ?? this.endereco,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dataHora: dataHora ?? this.dataHora,
    );
  }
}

// ─────────────────────────────────────────
// DATABASE HELPER
// ─────────────────────────────────────────
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('entregas.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entregas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL,
        destinatario TEXT NOT NULL,
        endereco TEXT NOT NULL,
        status TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        dataHora TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Entrega entrega) async {
    final db = await database;
    return await db.insert('entregas', entrega.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Entrega>> getAll() async {
    final db = await database;
    final maps = await db.query('entregas', orderBy: 'id DESC');
    return maps
        .map((m) => Entrega(
              id: m['id'] as int,
              codigo: m['codigo'] as String,
              destinatario: m['destinatario'] as String,
              endereco: m['endereco'] as String,
              status: m['status'] as String,
              latitude: (m['latitude'] as num).toDouble(),
              longitude: (m['longitude'] as num).toDouble(),
              dataHora: m['dataHora'] as String,
            ))
        .toList();
  }

  Future<int> update(Entrega entrega) async {
    final db = await database;
    return await db.update('entregas', entrega.toMap(),
        where: 'id = ?', whereArgs: [entrega.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('entregas', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

// ─────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Localizador de Entregas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle:
              const TextStyle(color: Color(0xFF1565C0)),
        ),
      ),
      home: const ListaEntregasPage(),
    );
  }
}

// ─────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────
const _statusOptions = [
  'Pendente',
  'Em trânsito',
  'Entregue',
  'Cancelado',
];

Color _statusColor(String status) {
  switch (status) {
    case 'Entregue':
      return Colors.green;
    case 'Em trânsito':
      return Colors.orange;
    case 'Cancelado':
      return Colors.red;
    default:
      return Colors.blueGrey;
  }
}

IconData _statusIcon(String status) {
  switch (status) {
    case 'Entregue':
      return Icons.check_circle;
    case 'Em trânsito':
      return Icons.local_shipping;
    case 'Cancelado':
      return Icons.cancel;
    default:
      return Icons.hourglass_empty;
  }
}

// ─────────────────────────────────────────
// LISTA DE ENTREGAS
// ─────────────────────────────────────────
class ListaEntregasPage extends StatefulWidget {
  const ListaEntregasPage({super.key});

  @override
  State<ListaEntregasPage> createState() => _ListaEntregasPageState();
}

class _ListaEntregasPageState extends State<ListaEntregasPage> {
  List<Entrega> _entregas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await DatabaseHelper.instance.getAll();
    setState(() {
      _entregas = data;
      _loading = false;
    });
  }

  Future<void> _delete(Entrega e) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir entrega'),
        content: Text('Deseja excluir a entrega ${e.codigo}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper.instance.delete(e.id!);
      _load();
    }
  }

  Future<void> _openForm({Entrega? entrega}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormEntregaPage(entrega: entrega),
      ),
    );
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text(
          'Localizador de Entregas',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _load,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nova Entrega',
            style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entregas.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Nenhuma entrega cadastrada',
              style: TextStyle(
                  fontSize: 18, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Toque em "Nova Entrega" para adicionar',
              style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: _entregas.length,
      itemBuilder: (_, i) => _EntregaCard(
        entrega: _entregas[i],
        onEdit: () => _openForm(entrega: _entregas[i]),
        onDelete: () => _delete(_entregas[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────
// CARD DE ENTREGA
// ─────────────────────────────────────────
class _EntregaCard extends StatelessWidget {
  final Entrega entrega;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EntregaCard({
    required this.entrega,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(entrega.status);
    final icon = _statusIcon(entrega.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entrega.codigo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          entrega.status,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (v) {
                      if (v == 'edit') onEdit();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Editar')
                          ])),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir',
                                style: TextStyle(color: Colors.red))
                          ])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Destinatário
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entrega.destinatario,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Endereço
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entrega.endereco,
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Coordenadas e data
              Row(
                children: [
                  const Icon(Icons.my_location,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${entrega.latitude.toStringAsFixed(4)}, ${entrega.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    entrega.dataHora,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// FORMULÁRIO DE ENTREGA
// ─────────────────────────────────────────
class FormEntregaPage extends StatefulWidget {
  final Entrega? entrega;

  const FormEntregaPage({super.key, this.entrega});

  @override
  State<FormEntregaPage> createState() => _FormEntregaPageState();
}

class _FormEntregaPageState extends State<FormEntregaPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codigo;
  late final TextEditingController _destinatario;
  late final TextEditingController _endereco;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _dataHora;

  String _status = _statusOptions.first;
  bool _saving = false;

  bool get isEditing => widget.entrega != null;

  @override
  void initState() {
    super.initState();
    final e = widget.entrega;
    _codigo = TextEditingController(text: e?.codigo ?? '');
    _destinatario = TextEditingController(text: e?.destinatario ?? '');
    _endereco = TextEditingController(text: e?.endereco ?? '');
    _latitude = TextEditingController(
        text: e != null ? e.latitude.toString() : '');
    _longitude = TextEditingController(
        text: e != null ? e.longitude.toString() : '');
    _dataHora = TextEditingController(
        text: e?.dataHora ?? _nowFormatted());
    _status = e?.status ?? _statusOptions.first;
  }

  @override
  void dispose() {
    _codigo.dispose();
    _destinatario.dispose();
    _endereco.dispose();
    _latitude.dispose();
    _longitude.dispose();
    _dataHora.dispose();
    super.dispose();
  }

  String _nowFormatted() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final formatted =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    setState(() => _dataHora.text = formatted);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final entrega = Entrega(
      id: widget.entrega?.id,
      codigo: _codigo.text.trim(),
      destinatario: _destinatario.text.trim(),
      endereco: _endereco.text.trim(),
      status: _status,
      latitude: double.parse(_latitude.text.trim()),
      longitude: double.parse(_longitude.text.trim()),
      dataHora: _dataHora.text.trim(),
    );

    try {
      if (isEditing) {
        await DatabaseHelper.instance.update(entrega);
      } else {
        await DatabaseHelper.instance.insert(entrega);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Entrega' : 'Nova Entrega',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionHeader(icon: Icons.qr_code, label: 'Identificação'),
              const SizedBox(height: 12),
              _buildField(
                controller: _codigo,
                label: 'Código da Entrega',
                icon: Icons.tag,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o código' : null,
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                  icon: Icons.person, label: 'Destinatário'),
              const SizedBox(height: 12),
              _buildField(
                controller: _destinatario,
                label: 'Nome do Destinatário',
                icon: Icons.person_outline,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe o destinatário'
                    : null,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _endereco,
                label: 'Endereço',
                icon: Icons.home_outlined,
                maxLines: 2,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe o endereço'
                    : null,
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                  icon: Icons.map_outlined, label: 'Localização'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: _latitude,
                      label: 'Latitude',
                      icon: Icons.south_america,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Obrigatório';
                        if (double.tryParse(v.trim()) == null)
                          return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      controller: _longitude,
                      label: 'Longitude',
                      icon: Icons.south_america,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Obrigatório';
                        if (double.tryParse(v.trim()) == null)
                          return 'Inválido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                  icon: Icons.info_outline, label: 'Status e Data'),
              const SizedBox(height: 12),
              // Status dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(
                    _statusIcon(_status),
                    color: _statusColor(_status),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1565C0), width: 2),
                  ),
                ),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Row(
                            children: [
                              Icon(_statusIcon(s),
                                  size: 18, color: _statusColor(s)),
                              const SizedBox(width: 8),
                              Text(s),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 12),
              // Data/hora
              TextFormField(
                controller: _dataHora,
                readOnly: true,
                onTap: _pickDateTime,
                decoration: InputDecoration(
                  labelText: 'Data e Hora',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1565C0), width: 2),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: const Icon(Icons.edit_calendar),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 32),
              // Botão salvar
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(isEditing ? Icons.save : Icons.add_circle),
                label: Text(
                  isEditing ? 'Salvar Alterações' : 'Cadastrar Entrega',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}

// ─────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF1565C0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: Colors.blue.shade100, thickness: 1),
        ),
      ],
    );
  }
}     