import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper._internal();
  factory DatabaseHelper() => _instancia;
  DatabaseHelper._internal();

  static Database? _baseDatos;

  final String _nombreBaseDatos = 'base_datos_app.db';
  final int _versionBaseDatos = 1;

  final String _tablaUsuarios = 'usuarios';
  final String columnaId = 'id';
  final String columnaNombre = 'nombre';
  final String columnaApellido = 'apellido';
  final String columnaCorreo = 'correo';
  final String columnaContrasena = 'contrasena';

  Future<Database> get obtenerBaseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos = await _inicializarBaseDatos();
    return _baseDatos!;
  }

  Future<Database> _inicializarBaseDatos() async {
    String ruta = join(await getDatabasesPath(), _nombreBaseDatos);
    return await openDatabase(
      ruta,
      version: _versionBaseDatos,
      onCreate: _crearTabla,
    );
  }

  Future<void> _crearTabla(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tablaUsuarios (
        $columnaId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnaNombre TEXT NOT NULL,
        $columnaApellido TEXT NOT NULL,
        $columnaCorreo TEXT NOT NULL UNIQUE,
        $columnaContrasena TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarUsuario(Map<String, dynamic> usuario) async {
    Database db = await obtenerBaseDatos;
    return await db.insert(_tablaUsuarios, usuario);
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    Database db = await obtenerBaseDatos;
    return await db.query(_tablaUsuarios);
  }

  Future<Map<String, dynamic>?> obtenerUsuarioPorCorreo(String correo) async {
    Database db = await obtenerBaseDatos;
    List<Map<String, dynamic>> resultado = await db.query(
      _tablaUsuarios,
      where: '$columnaCorreo = ?',
      whereArgs: [correo],
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }

  Future<int> actualizarUsuario(Map<String, dynamic> usuario) async {
    Database db = await obtenerBaseDatos;
    return await db.update(
      _tablaUsuarios,
      usuario,
      where: '$columnaId = ?',
      whereArgs: [usuario[columnaId]],
    );
  }

  Future<int> eliminarUsuario(int id) async {
    Database db = await obtenerBaseDatos;
    return await db.delete(
      _tablaUsuarios,
      where: '$columnaId = ?',
      whereArgs: [id],
    );
  }

  Future<void> cerrarBaseDatos() async {
    Database db = await obtenerBaseDatos;
    await db.close();
  }
}
