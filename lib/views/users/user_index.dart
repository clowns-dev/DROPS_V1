import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/user.dart';
import 'package:ps3_drops_v1/view_models/user_view_model.dart';
import 'package:ps3_drops_v1/views/users/user_data.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';
import 'package:ps3_drops_v1/widgets/delete_confirmation_dialog.dart';

class UserIndex extends StatefulWidget {
  const UserIndex({super.key});

  @override
  State<UserIndex> createState() => _UserIndex();
}

class _UserIndex extends State<UserIndex> {
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'CI', 'Nombre','Apellido'];
  bool _showForm = false; 
  User? _editingUser; 
  //String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _showNurseFields = false;

  //Campos para la insercion
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userBirthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {// Cancela el debounce al destruir el widget
    _searchController.dispose();
    super.dispose();
  }

  void _filterUserList(String query) {
    final userViewModel = context.read<UserViewModel>();
    userViewModel.filterUsers(query, _selectedFilter);
  }

  void _toggleView({bool resetForm = false}) {
    setState(() {
      _showForm = !_showForm;

      if (resetForm) {
        _editingUser = null;
        _showNurseFields = false;
      } else {
        _showNurseFields = _editingUser?.nameRole == 'Enfermera';
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterUserList('');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleContainer(
              title: 'Gestión de Usuarios',
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 500) {
                  return IconButton(
                    icon: Icon(
                      _showForm ? Icons.arrow_back : Icons.add,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    onPressed: () => _toggleView(),
                  );
                } else {
                  return OutlinedButton(
                    onPressed: () => _toggleView(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      side: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showForm ? Icons.arrow_back : Icons.add,
                          color: Colors.grey[700],
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        AddTitleButton(
                          titleButton: _showForm ? 'Volver' : 'Añadir Usuario',
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(236, 238, 240, 255),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(236, 238, 240, 255),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showForm)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HistoryTitleContainer(
                    titleTable: 'Historial de Usuarios',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownFilter(
                        fullWidth: false,
                        value: _selectedFilter,
                        items: _filterOptions,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFilter = newValue as String;
                          });
                          if (_selectedFilter == 'Buscar por:') {
                            _filterUserList('');
                          }
                        },
                      ),
                        const SizedBox(width: 16.0),
                      SearchField(
                        controller: _searchController,
                        fullWidth: false,
                        onChanged: (query) {
                          _filterUserList(query);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18.0),
                child: _showForm ? _buildForm() : _buildTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: HistoryTitleContainer(
                titleTable: _editingUser == null ? 'Añadir Usuario' : 'Editar Usuario',
              ),
            ),
            const SizedBox(height: 24.0),

            // Distribución de los campos en dos columnas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera columna de campos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextLabel(content: 'CI:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.ci ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el C.I.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Nombre:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.name ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el nombre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Apellido Paterno:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.lastName ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el apellido paterno',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Apellido Materno:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.secondLastName ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el apellido materno',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Fecha de Nacimiento:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        
                        decoration: InputDecoration(
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextLabel(content: 'Celular:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.phone ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el número de celular',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Direccion:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.address ?? '',
                        ),
                        maxLines: 6,
                        minLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Ingrese la dirección del domicilio',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Correo Electronico:'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: TextEditingController(
                          text: _editingUser?.email ?? '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese el Correo Electronico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const TextLabel(content: 'Rol Usuario'),
                      const SizedBox(height: 8.0),
                      DropdownButtonFormField<String>(
                        value: _editingUser?.nameRole,
                        decoration: InputDecoration(
                          hintText: 'Ingrese el rol de Usuario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: <String>['Enfermera', 'Doctor', 'Admin']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _editingUser?.nameRole = newValue;
                            _showNurseFields = newValue == 'Enfermera';
                          });
                        },
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
                const SizedBox(width: 40.0),
                // Tercera columna para campos adicionales de "Enfermera"
                if (_showNurseFields)
                  Expanded(
                    child: Column(
                      children: [
                        const TextLabel(content: 'Rol Enfermero'),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: TextEditingController(
                            text: _editingUser?.email ?? '',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ingrese el Rol del Enfermero',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        const TextLabel(content: 'En Turno'),
                        const SizedBox(height: 8.0),
                        SwitchListTile(
                          value: _editingUser?.idUser != null,
                          onChanged: (bool value) {
                            setState(() {
                              // Aquí podrías definir una lógica para actualizar el campo "en turno"
                            });
                          },
                          title: const Text('En turno'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32.0),

            // Botón para guardar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_editingUser != null) {
                    if (kDebugMode) {
                      print('Editando paciente con ID: ${_editingUser?.idUser}');
                    }
                  } else {
                    if (kDebugMode) {
                      print('Creando nuevo paciente');
                    }
                  }
                  _showSuccessDialog(context, _editingUser != null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade300,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  _editingUser == null ? 'INSERTAR' : 'GUARDAR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showSuccessDialog(BuildContext context, bool isEditing) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: isEditing ? 'Edición exitosa' : 'Registro Exitoso',
          message: isEditing
              ? '¡Se modificó el registro correctamente!'
              : '¡Se creó el registro correctamente!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
            _toggleView();
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int? idEmployee) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            Provider.of<UserViewModel>(context, listen: false);
            if (kDebugMode) {
              print('Eliminando empleado con ID: $idEmployee');
            }
          },
        );
      },
    );
  }

  Widget _buildTable() {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (!userViewModel.hasMatches) {
          return Center(
            child: Text(
              'Sin coincidencias',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          );
        } else {
          return UserDataTable(
            users: userViewModel.filteredUsers,
            onEdit: (id) async {
              User? user = await userViewModel.fetchUserById(id);
              if (user != null) {
                setState(() {
                  _editingUser = user;
                });
                // ignore: use_build_context_synchronously
                //_showFormModal(context, user);
              }
            },
            onDelete: (id) async {
              _showDeleteConfirmationDialog(context, id);
            },
          );
        }
      },
    );
  }
}

