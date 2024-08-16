import 'package:flutter/material.dart';
import 'package:proyecto_flutter/utils/crud_clientes.dart';

class ClientesPage extends StatelessWidget {
  final CrudOperations crudOperations = CrudOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: crudOperations.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final clients = snapshot.data ?? [];

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                title: Text('${client['nombres']} ${client['apellidos']}'),
                subtitle: Text('Email: ${client['email']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await crudOperations.deleteUser(client['uid']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Cliente eliminado exitosamente')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error al eliminar el cliente: $e')),
                      );
                    }
                  },
                ),
                onTap: () {
                  // Navegar a una página de detalles o edición si es necesario
                },
              );
            },
          );
        },
      ),
    );
  }
}
