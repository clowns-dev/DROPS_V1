import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/view_models/balance_view_model.dart';
import 'package:ps3_drops_v1/view_models/smart_view_model.dart';
import 'package:ps3_drops_v1/views/balance/balance_data.dart';
import 'package:ps3_drops_v1/views/smart/smart_data.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';
import 'package:ps3_drops_v1/widgets/delete_confirmation_dialog.dart';

class SmartIndex extends StatefulWidget {
  const SmartIndex({super.key});

  @override
  State<SmartIndex> createState() => _SmartIndexState();
}

class _SmartIndexState extends State<SmartIndex> {
  final String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'Codigo'];
  Smart? _editingSmart;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final smartViewModel = context.read<SmartViewModel>();
    smartViewModel.filterBalances(_searchController.text);
  }

  void _showFormModal(BuildContext context, [Smart? smart]) {
    setState(() {
      _editingSmart = smart;
    });
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: 800,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    child: Image.asset(
                      '../assets/img/nurse2.png',
                      fit: BoxFit.cover,
                      height: 400,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: HistoryTitleContainer(
                            titleTable: _editingSmart == null ? 'Añadir Manilla' : 'Editar Manilla',
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        const TextLabel(content: 'Código RFID:'),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: TextEditingController(
                            text: _editingSmart?.codeRFID ?? '',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ingrese el código RFID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_editingSmart != null) {
                                        if (kDebugMode) {
                                          print('Editando balanza con ID: ${_editingSmart?.idSmart}');
                                        }
                                      } else {
                                        if (kDebugMode) {
                                          print('Creando nueva balanza');
                                        }
                                      }
                                      _showSuccessDialog(context, _editingSmart != null, dialogContext);
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
                                      _editingSmart == null ? 'INSERTAR' : 'GUARDAR',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(); 
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade400,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: 32.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'CANCELAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
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

  void _showSuccessDialog(BuildContext context, bool isEditing, BuildContext formDialogContext) {
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
            Navigator.of(formDialogContext).pop(); 
          },
        );
      },
    );
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
              title: 'Gestión de Manillas',
            ),
            OutlinedButton(
              onPressed: () => _showFormModal(context),
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
                    Icons.add,
                    color: Colors.grey[700],
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                  const AddTitleButton(
                    titleButton: 'Añadir Manilla',
                  ),
                ],
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HistoryTitleContainer(
                  titleTable: 'Historial de Manillas',
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownFilter(
                      fullWidth: false,
                      value: _selectedFilter,
                      items: _filterOptions,
                      onChanged: (newValue) {},
                    ),
                    const SizedBox(width: 16.0),
                    SearchField(
                      controller: _searchController,
                      fullWidth: false,
                      onChanged: (value) => _onSearchChanged(),
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
                child: _buildTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Consumer<SmartViewModel>(
      builder: (context, smartViewModel, child) {
        if (smartViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (smartViewModel.filteredSmarts.isEmpty) {
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
          return SmartDataTable(
            smarts: smartViewModel.filteredSmarts,
            onEdit: (id) {
              Smart? smart = smartViewModel.filteredSmarts.firstWhere(
                (s) => s.idSmart == id,
                orElse: () => Smart(),
              );
              // ignore: unnecessary_null_comparison
              if (smart != null) {
                _showFormModal(context, smart);
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

  void _showDeleteConfirmationDialog(BuildContext context, int smartId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            Provider.of<SmartViewModel>(context, listen: true).deleteSmart(smartId);
            if (kDebugMode) {
              print('Eliminando Manilla con ID: $smartId');
              
            }
            Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
          },
        );
      },
    );
  }
}