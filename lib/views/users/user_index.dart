import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserIndex extends StatefulWidget {
  const UserIndex({super.key});

  @override
  State<UserIndex> createState() => _UserIndex();
}

class _UserIndex extends State<UserIndex> {
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'CI', 'Nombre','Apellido'];
  bool _showForm = false; 
  User? _editingUser, user; 
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  //Campos para la insercion
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userBirthDateController = TextEditingController();
  String? nameRoleController;
  int? _genreValueController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUserList(String query) {
    final userViewModel = context.read<UserViewModel>();
    userViewModel.filterUsers(query, _selectedFilter);
  }

  void _toggleView([User? patient]) {
    setState(() {
      _showForm = !_showForm;
      _editingUser = patient; 
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterUserList('');
  }

  void _resetForm(){
    _ciController.clear();
    _nameController.clear();
    _lastNameController.clear();
    _secondLastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _genreValueController = null;
    _editingUser = null;
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
                        controller: _ciController,
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
                        controller: _nameController,
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
                        controller: _lastNameController,
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
                        controller: _secondLastNameController,
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
                      InkWell(
                        onTap: () {
                          _showSyncfusionDatePicker(context);
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            hintText: 'Seleccione una fecha',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            _userBirthDateController.text.isEmpty
                                ? 'Seleccione una fecha'
                                : _userBirthDateController.text,
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
                        controller: _phoneController,
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
                        controller: _addressController,
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
                        controller: _emailController,
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
                        value: nameRoleController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese el rol de Usuario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: <String>['Administrador', 'Enfermero', 'Biomedico']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            nameRoleController = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
                const SizedBox(width: 40.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextLabel(content: 'Genero'),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              title: const Text('Masculino'),
                              value: 0,
                              groupValue: _genreValueController,
                              onChanged: (value) {
                                setState(() {
                                  _genreValueController = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: const Text('Femenino'),
                              value: 1,
                              groupValue: _genreValueController,
                              onChanged: (value) {
                                setState(() {
                                  _genreValueController = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String name = _nameController.text;
                  String lastName = _lastNameController.text;
                  String secondLastName = _secondLastNameController.text;
                  String phone = _phoneController.text;
                  String address = _addressController.text;
                  String ci = _ciController.text;
                  String email = _emailController.text;
                  DateTime? birthDate;
                  String genre;
                  int? role;
                  genre = (_genreValueController == 0) ? "M" : "F";
                  if(_userBirthDateController.text.isNotEmpty){
                    birthDate = DateFormat('dd/MM/yyyy').parse(_userBirthDateController.text);
                  }

                  switch(nameRoleController){
                    case "Administrador":
                      role = 1;
                      break;
                    case "Enfermero":
                      role = 2;
                      break;
                    case "Biomedico":
                      role = 3;
                      break;
                    default:
                      role = 0; 
                  }


                  final userViewModel = context.read<UserViewModel>();
                  if(_editingUser != null){
                    if(name.isNotEmpty && lastName.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && ci.isNotEmpty && email.isNotEmpty && birthDate != null && genre.isNotEmpty){
                      user = User(idUser: _editingUser!.idUser!,name: name, lastName: lastName, secondLastName: secondLastName, phone:phone, email:  email,address: address, birthDate: birthDate, genre: genre,ci: ci, idRole: role);
                      userViewModel.editUser(user).then((_) {
                        userViewModel.fetchUsers();
                        _clearSearch();
                      });
                      _showSuccessDialog(context, true);
                      _resetForm();
                    }
                  } else {
                    if(name.isNotEmpty && lastName.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && ci.isNotEmpty && email.isNotEmpty && birthDate != null && genre.isNotEmpty){
                      user = User(name: name, lastName: lastName, secondLastName: secondLastName, phone:phone, email:  email,address: address, birthDate: birthDate, genre: genre,ci: ci, idRole: role);
                      userViewModel.createNewUser(user).then((_) {
                        userViewModel.fetchUsers();
                        _clearSearch();
                      });
                      _showSuccessDialog(context, false);
                      _resetForm();
                    }
                  }
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

  void _showSyncfusionDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
          backgroundColor: const Color(0xFFF5F0FF), 
          content: SizedBox(
            height: 350,
            width: 350,
            child: Container(
              padding: const EdgeInsets.all(10), 
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0FF), 
                borderRadius: BorderRadius.circular(20), 
                border: Border.all(
                  color: const Color.fromARGB(255, 168, 126, 207), 
                  width: 2, // Grosor del borde
                ),
              ),
              child: SfDateRangePicker(
                backgroundColor: const Color(0xFFF5F0FF), 
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    _selectedDate = args.value;
                    _userBirthDateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                  });
                  Navigator.pop(context); 
                },
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: _selectedDate ?? DateTime.now(),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Color(0xFFF0E4FF),
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4B0082),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  todayCellDecoration: BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  disabledDatesTextStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                selectionColor: const Color(0xFF6A0DAD), 
                rangeSelectionColor: const Color(0xFFE1BEE7), 
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9494),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(70, 31),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  void _showDeleteConfirmationDialog(BuildContext context, int? userID) {
     
    if(userID == null){
      if (kDebugMode) {
        print("El userID es null, no se puede mostrar el diálogo de eliminación.");
        return;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            final userViewModel = context.read<UserViewModel>();
            if(userID != null){
              userViewModel.removeUser(userID).then((_){
                userViewModel.fetchUsers();
              });
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
                  _ciController.text = user.ci ?? '';
                  _nameController.text = user.name ?? '';
                  _lastNameController.text = user.lastName ?? '';
                  _secondLastNameController.text = user.secondLastName ?? '';
                  _phoneController.text = user.phone ?? '';
                  _emailController.text = user.email ?? '';
                  _addressController.text = user.address ?? '';
                  _userBirthDateController.text = user.birthDate != null
                      ? DateFormat('dd/MM/yyyy').format(user.birthDate!)
                      : '';
                  _genreValueController = (user.genre == 'M') ? 0 : 1;

                  // Set the role based on `idRole`
                  switch (user.idRole) {
                    case 1:
                      nameRoleController = "Administrador";
                      break;
                    case 2:
                      nameRoleController = "Enfermero";
                      break;
                    case 3:
                      nameRoleController = "Biomedico";
                      break;
                    default:
                      nameRoleController = "No tiene";
                  }
                });
                _toggleView(user);
              }
            },
            onDelete: (id) {
              _showDeleteConfirmationDialog(context, id);
            },
          );
        }
      },
    );
  }
}