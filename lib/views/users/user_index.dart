import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/person.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class UserDataSource extends DataGridSource {
  UserDataSource({required List<Person> users, required this.onEdit, required this.context}) {
    _originalUsers = users;
    _paginatedUsers = users.toList();
    buildDataGridRows(onEdit);
  }

  BuildContext context;

  List<Person> _originalUsers = [];
  List<Person> _paginatedUsers = [];
  List<DataGridRow> _users = [];

  final Function onEdit; 

  @override
  List<DataGridRow> get rows => _users;
  

  void updateSearch(String searchQuery) {
  if (searchQuery.isEmpty) {
    _paginatedUsers = _originalUsers; // Restablecer lista original si no hay búsqueda
  } else {
    _paginatedUsers = _originalUsers.where((person) {
      // Filtra por el campo seleccionado
      var selectedFilter;
      switch (selectedFilter) {
        case 'CI':
          return person.ci.toLowerCase().contains(searchQuery.toLowerCase());
        case 'Nombre':
          return person.name.toLowerCase().contains(searchQuery.toLowerCase());
        case 'Fecha de Nacimiento':
          return person.birthDate.toLowerCase().contains(searchQuery.toLowerCase());
        default:
          return false;
      }
    }).toList();
  }
  buildDataGridRows(onEdit); // Reconstruir la tabla con los resultados filtrados
  notifyListeners(); // Notificar cambios
}
  void buildDataGridRows(Function onEdit) {
    _users = _paginatedUsers.map<DataGridRow>((person) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Nombre', value: person.name),
        DataGridCell<String>(columnName: 'Apellido Paterno', value: person.lastName),
        DataGridCell<String>(columnName: 'Apellido Materno', value: person.secondLastName),
        DataGridCell<String>(columnName: 'Fecha de Nacimiento', value: person.birthDate),
        DataGridCell<String>(columnName: 'CI', value: person.ci),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    onEdit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: (){
                    _showDeleteConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                ),
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: dataGridCell.value is Widget
              ? dataGridCell.value
              : Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
  
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0), // Remove default padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SizedBox(
        width: 336,
        height: 284,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 336,
                height: 284,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE1F2E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 51.25,
              top: 10.0,
              child: Column(
                children: [
                  Image.asset(
                    'assets/interroga.png',
                    width: 116,
                    height: 124,
                  ),
                  const SizedBox(
                    width: 218.31,
                    height: 30,
                    child: Text(
                      '¿Eliminar?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 33,
              top: 180,
              child: SizedBox(
                width: 270,
                height: 50,
                child: Text(
                  '¿Está seguro de que desea eliminar este registro?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Positioned(
              left: 93,
              top: 237,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  // Aquí puedes agregar la acción de eliminar
                  //Provider.of<BalanceViewModel>(context, listen: false).deleteBalance(idBalance);
                },
                child: Container(
                  width: 43,
                  height: 31,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF9494),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Sí',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 197,
              top: 237,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 43,
                  height: 31,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF48E86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);

  }
}


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

List<Person> getUserData() {
  return [
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
    Person(name:'Alejandra',lastName: 'Centellas',secondLastName: 'Centellas', birthDate: '23-18-1992', ci: '7545454'),
  ];
}


class UsersPageState extends State<UsersPage> {
  late UserDataSource _userDataSource;
  late List<Person> _users;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Nombre'; // Inicializa con un valor válido
  String _selectedUsuario = 'Usuario'; 

  int _rowsPerPage = 5;

  bool _isAddingUser = false; // Para alternar entre tabla y formulario de añadir
  bool _isEditingUser = false; // Para alternar entre tabla y formulario de edición

  @override
  void initState() {
    _users = getUserData();
    // Pasar la función de edición a la fuente de datos
    _userDataSource = UserDataSource(users: _users, onEdit: _toggleEditingUser, context: context);
    super.initState();
  }

  // Función para alternar entre la tabla y el formulario de añadir
  void _toggleAddingUser() {
    setState(() {
      _isAddingUser = !_isAddingUser;
    });
  }

  // Función para alternar entre la tabla y el formulario de edición
  void _toggleEditingUser() {
    setState(() {
      _isEditingUser = !_isEditingUser;
    });
  }

  // Mostrar el cuadro de diálogo de confirmación de eliminación
  

@override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 1, // Solo una pestaña
    child: Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gestión de Usuarios'),
            ElevatedButton(
              onPressed: _isAddingUser ? _toggleAddingUser : _toggleAddingUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(169, 157, 177, 158), // Color del botón
              ),
              child: _isAddingUser ? const Text('Volver') : const Text('Añadir Usuario'),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // Ajustar altura
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // TabBar (con una pestaña)
                const Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Historial de Usuarios'),
                    ],
                    
                  ),
                ),
                const SizedBox(width: 10),
                
                _buildSearchFilterDropdown(), 
                const SizedBox(width: 10),
                _buildFilterDropdown(), 
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _buildSearchField(), // Campo de búsqueda
                ),
                
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
  children: [
    Column(
      children: [
        Expanded(
          child: _isAddingUser 
              ? _buildAddUserForm()  // Mostrar formulario de creación si se está agregando un usuario
              : _isEditingUser 
                  ? _buildEditUserForm() // Mostrar formulario de edición si se está editando un usuario
                  : _buildUserTable(),   // Mostrar la tabla de usuarios si no se está editando ni agregando
        ),
        SfDataPager(
          delegate: _userDataSource,
          availableRowsPerPage: const <int>[5, 10, 15],
          pageCount: (_users.length / _rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _rowsPerPage = rowsPerPage!;
            });
          },
        ),
      ],
    ),
  ],
),

    ),
  );
}




Widget _buildSearchField() {
  return TextField(
    controller: _searchController,
    onChanged: (value) {
      setState(() {
        _userDataSource.updateSearch(value); // Actualizar búsqueda cuando cambia el texto
      });
    },
    decoration: InputDecoration(
      hintText: 'Buscar usuario',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    ),
  );
}

Widget _buildFilterDropdown() {
  return DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 2), 
      borderRadius: BorderRadius.circular(8), 
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedUsuario,
        items: <String>['Usuario', 'Administrador', 'Enfermera', 'Biomédico']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedUsuario = newValue!;
            _userDataSource.updateSearch(_searchController.text);
          });
        },
        underline:const SizedBox(),
      ),
    ),
  );
}


Widget _buildSearchFilterDropdown() {
  return DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedFilter, 
        items: <String>['Nombre', 'CI', 'Fecha de Nacimiento'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedFilter = newValue!; 
          });
        },
        underline:const SizedBox(),
      ),
    ),
  );
}
  // Formulario de añadir usuario
  Widget _buildAddUserForm() {
    final TextEditingController ciController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dobController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController modifierController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: ciController,
            decoration: const InputDecoration(labelText: 'CI'),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: dobController,
            decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
          ),
          TextField(
            controller: typeController,
            decoration: const InputDecoration(labelText: 'Tipo de Usuario'),
          ),
          TextField(
            controller: modifierController,
            decoration: const InputDecoration(labelText: 'Usuario Modificador'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showSuccessDialogCreate(context, () {
                Navigator.of(context).pop();
              });
              _toggleAddingUser(); // Vuelve a la tabla de usuarios
            },
            child: const Text('Registrar Usuario'),
          ),
        ],
      ),
    );
  }

  // Formulario de edición de usuario
  Widget _buildEditUserForm() {
    final TextEditingController ciController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dobController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController modifierController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: ciController,
            decoration: const InputDecoration(labelText: 'CI'),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: dobController,
            decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
          ),
          TextField(
            controller: typeController,
            decoration: const InputDecoration(labelText: 'Tipo de Usuario'),
          ),
          TextField(
            controller: modifierController,
            decoration: const InputDecoration(labelText: 'Usuario Modificador'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showSuccessDialogEdit(context, () {
                Navigator.of(context).pop();
              });


              _toggleEditingUser(); // Vuelve a la tabla de usuarios
            },
            child: const Text('Guardar Edicion'),
          ),
        ],
      ),
    );
  }

  // Vista de la tabla de usuarios
  Widget _buildUserTable() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: SfDataGridTheme(
              data: const SfDataGridThemeData(
                headerColor: Color.fromARGB(255, 246, 247, 248),
              ),
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.fill,
                source: _userDataSource,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Nombre',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Nombre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Apellido Paterno',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Apellido Paterno',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Apellido Materno',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Apellido Materno',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Fecha de Nacimiento',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Fecha de Nacimiento',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'CI',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'CI',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Acciones',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Acciones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


void _showSuccessDialogCreate(BuildContext context, VoidCallback onBackPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 354,
            maxHeight: 315,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 71, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F2E1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 121,
                height: 121,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/aceptar.png', // Asegúrate de tener esta imagen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Registro exitoso',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                '¡Se creo el registro correctamente!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Carrois Gothic SC',
                ),
              ),
              const SizedBox(height: 21),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onBackPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48E86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: const Size(70, 24),
                  ),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showSuccessDialogEdit(BuildContext context, VoidCallback onBackPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 354,
            maxHeight: 315,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 71, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F2E1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 121,
                height: 121,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/aceptar.png', // Asegúrate de tener esta imagen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Edicion exitosa',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                '¡Se modifico el registro correctamente!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Carrois Gothic SC',
                ),
              ),
              const SizedBox(height: 21),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onBackPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48E86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    minimumSize: const Size(70, 24),
                  ),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void main() {
  runApp(const MaterialApp(home: UsersPage()));
}
