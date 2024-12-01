import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/view_models/smart_view_model.dart';
import 'package:ps3_drops_v1/views/smart/smart_data.dart';
import 'package:ps3_drops_v1/views/smart/smart_nurses_data.dart';
import 'package:ps3_drops_v1/widgets/error_form_dialog.dart';
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
  Timer? _debounce;
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'Codigo', 'Enfermero'];
  Smart? _editingSmart, smart;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchNurseController = TextEditingController();
  final TextEditingController _smartCodeController = TextEditingController();
  int?  idNurse, idSmart,_availabilityStatus, availableAssignment;

  Map<String, bool> _fieldErrors = {
    'codeRfid': false,
    'codeRfidInvalid': false,
    'available': false,
    'idNurse': false,
    'userId':false,
    'codeRegistered':false,
    'availableAssignment': false
  };

  void _resetFieldErrors(){
    setState(() {
      _fieldErrors = {
        'codeRfid': false,
        'codeRfidInvalid': false,
        'idNurse': false,
        'available': false,
        'userId': false,
        'codeRegistered':false,
        'availableAssignment': false
      };
    });
  }

  void _resetForm(){
    final smartViewModel = context.read<SmartViewModel>();
    idNurse = null;
    availableAssignment = null;
    _availabilityStatus = null;
    _smartCodeController.clear();
    smartViewModel.updateSelectedNurseId(0);
    _filterNurseList('');
    _filterSmartList('');
    _resetFieldErrors();
  }

  void _onCodeChanged(String code) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final smartViewModel = context.read<SmartViewModel>();
      bool isCodeRegistered = await smartViewModel.isCodeRegistered(context, code.trim());
      setState(() {
        _fieldErrors['codeRfid'] = code.trim().isEmpty;
        _fieldErrors['codeRfidInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(code.trim());
        _fieldErrors['codeRegistered'] = isCodeRegistered && _editingSmart == null;
      });
    });
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
            //Navigator.of(formDialogContext).pop(); 
          },
        );
      },
    );
  }

  void _showSuccessDialogAssignment(BuildContext context, BuildContext formDialogContext) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: 'Asignacion Exitosa',
          message: '¡Se asigno al enfermero correctamente!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
            Navigator.of(formDialogContext).pop(); 
          },
        );
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();
    _filterSmartList('');
  }

  void _showDeleteConfirmationDialog(BuildContext context, int? smartId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            final smartViewModel = context.read<SmartViewModel>();
            if(smartId != null){
              smartViewModel.removeSmart(context, smartId).then((_) {
                // ignore: use_build_context_synchronously
                smartViewModel.fetchSmarts(context);
                _clearSearch();
              });
            }
          },
        );
      },
    );
  }

  void _showErrorFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(
          title:'Advertencia',
          message: '¡Seleccione un Enfermero!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  Future<void> __validateAndSubmitToAssignment(BuildContext formDialogContext, int smartID) async {
    setState(() {
      _fieldErrors['idNurse'] = idNurse == null || idNurse == 0;
    });

    if(_fieldErrors.containsValue(true)){
      _showErrorFormDialog(context);
      return;
    }

    final smartViewModel = context.read<SmartViewModel>();

    try{
      smart = Smart(
        idSmart: smartID,
        idUser: idNurse,
      );

      await smartViewModel.asignSmart(context, smart!);

      // ignore: use_build_context_synchronously
      await smartViewModel.fetchSmarts(context);
      // ignore: use_build_context_synchronously
      await smartViewModel.fetchSmartNurses(context);
      _clearSearch();
      _resetForm();
      // ignore: use_build_context_synchronously
      _showSuccessDialogAssignment(context, formDialogContext);

    } catch (e){
      throw Exception("Error Index: $e");
    }
  }

  Future<void> _validateAndSubmit(BuildContext formDialogContext) async {
    final smartViewModel = context.read<SmartViewModel>();
    bool isCodeRegistered = await smartViewModel.isCodeRegistered(context, _smartCodeController.text.trim());

    setState(() {
      _fieldErrors['codeRfid'] = _smartCodeController.text.trim().isEmpty;
      _fieldErrors['codeRfidInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(_smartCodeController.text.trim());
      _fieldErrors['userId'] = sessionManager.idUser == null || sessionManager.idUser == 0;
      _fieldErrors['codeRegistered'] = isCodeRegistered && _editingSmart == null;

      if (_editingSmart != null) {
        _fieldErrors['available'] = _availabilityStatus == null;
        _fieldErrors['availableAssignment'] = _availabilityStatus == null;
      } else {
        _fieldErrors['available'] = false;
        _fieldErrors['availableAssignment'] = false;  
      }
    });

    if (_fieldErrors.containsValue(true)) {
      if(kDebugMode){
        print("Estado fieldErrors: $_fieldErrors");
      }
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.of(formDialogContext).pop();

    if (_editingSmart != null) {

      if(kDebugMode){
        print("El id es: $availableAssignment");
        print("El idUser es: ${_editingSmart!.idUser}}");
      }

      if(availableAssignment == 1){
        availableAssignment = _editingSmart!.idUser;
      }

      smart = Smart(
        idSmart: _editingSmart!.idSmart,
        codeRFID: _smartCodeController.text,
        available: _availabilityStatus,
        idUser: availableAssignment,
      );

      // ignore: use_build_context_synchronously
      await smartViewModel.editSmart(context, smart!);
      // ignore: use_build_context_synchronously
      smartViewModel.fetchSmarts(context);
      // ignore: use_build_context_synchronously
      smartViewModel.fetchSmartNurses(context);
      _clearSearch();
      _resetForm();
      // ignore: use_build_context_synchronously
      _showSuccessDialog(context, true);
    } else {
      smart = Smart(
        codeRFID: _smartCodeController.text,
        idUser: 0,
      );

      // ignore: use_build_context_synchronously
      await smartViewModel.createNewSmart(context, smart!);
      // ignore: use_build_context_synchronously
      smartViewModel.fetchSmarts(context);
      _clearSearch();
      _resetForm();
      // ignore: use_build_context_synchronously
      _showSuccessDialog(context, false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final smartViewModel = context.read<SmartViewModel>();
    smartViewModel.fetchSmarts(context);
    smartViewModel.fetchSmartNurses(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _filterSmartList(String query) {
    final smartViewModel = context.read<SmartViewModel>();
    smartViewModel.filterSmarts(query, _selectedFilter);
  }

  void _filterNurseList(String query) {
    final smartViewModal = context.read<SmartViewModel>();
    smartViewModal.filterNurses(query);
  }

  void _showFormModal(BuildContext context, [Smart? smart]) {
     _editingSmart = smart;
    if (_editingSmart != null) {
      _smartCodeController.text = _editingSmart!.codeRFID ?? ''; 
      _availabilityStatus = _editingSmart!.available ?? 0;
      idNurse = _editingSmart!.idUser ?? 0; 
      //availableAssignment = _editingSmart!.idUser ?? 0;
    } else {
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                width: 1000,
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
                          height: 500,
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
                              controller: _smartCodeController,
                              onChanged: _onCodeChanged,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Ingrese el código RFID',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: _fieldErrors['codeRfid']!
                                        ? Colors.red
                                        : _fieldErrors['codeRegistered']!
                                            ? Colors.orange
                                            : Colors.grey,
                                  ),
                                ),
                                errorText: _fieldErrors['codeRfid']!
                                    ? 'El código RFID no puede estar vacío'
                                    : _fieldErrors['codeRfidInvalid']!
                                        ? 'El código RFID contiene caracteres no válidos'
                                        : _fieldErrors['codeRegistered']!
                                            ? 'Este código ya está registrado'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            if (_editingSmart != null) ...[
                              const TextLabel(content: 'Disponibilidad:'),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<int>(
                                      title: const Text('Sí'),
                                      value: 1,
                                      groupValue: _availabilityStatus,
                                      onChanged: (value) {
                                        setModalState(() {
                                          _availabilityStatus = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<int>(
                                      title: const Text('No'),
                                      value: 0,
                                      groupValue: _availabilityStatus,
                                      onChanged: (value) {
                                        setModalState(() {
                                          _availabilityStatus = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              const TextLabel(content: 'Quitar Asignacion:'),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<int>(
                                      title: const Text('Sí'),
                                      value: 0, 
                                      groupValue: availableAssignment, 
                                      onChanged: (value) {
                                        setModalState(() {
                                          availableAssignment = value!; 
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<int>(
                                      title: const Text('No'),
                                      value: 1, 
                                      groupValue: availableAssignment, 
                                      onChanged: (value) {
                                        setModalState(() {
                                          availableAssignment = value!; 
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setModalState(() {
                                            _validateAndSubmit(dialogContext);
                                          });
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
              );
            },
          ),
        );
      },
    );
  }

  void showNursesTableModal(BuildContext context, int? idS) {
    _resetForm();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  spreadRadius: 4,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            width: 1000, 
            height: 650,
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), 
              ),
              insetPadding: const EdgeInsets.all(16.0), 
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Enfermeros',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10.0),
                              SearchField(
                                controller: _searchNurseController,
                                fullWidth: false,
                                onChanged: (query) {
                                  _filterNurseList(query);
                                },
                              ),
                              const SizedBox(width: 24.0),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    __validateAndSubmitToAssignment(dialogContext, idS!);
                                  });
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
                                child: const Text(
                                  'Asignar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: _buildNursesTable(context), 
                          ),
                          const SizedBox(height: 16.0),
                           Center( 
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); 
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9494),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 32.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Cerrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
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
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFilter = newValue as String;
                        });
                        if (_selectedFilter == 'Buscar por:') {
                          _filterSmartList('');
                        }
                      },
                    ),
                    const SizedBox(width: 16.0),
                    SearchField(
                      fullWidth: false,
                      controller: _searchController,
                      onChanged: (query) {
                        _filterSmartList(query);
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
        } else if (!smartViewModel.hasMatches) {
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
            onAssignment: (id) async {
              _resetForm();
              showNursesTableModal(context, id);
            },
            onEdit: (id) async {
              Smart? smart = await smartViewModel.fetchBalanceById(context, id);
              // ignore: unnecessary_null_comparison
              if (smart != null) {
                setState(() {
                  _resetFieldErrors();
                  _editingSmart = smart;
                });
                // ignore: use_build_context_synchronously
                _showFormModal(context, _editingSmart);
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

  Widget _buildNursesTable(BuildContext context) {
    return Consumer<SmartViewModel>(
      builder: (context, smartViewModal, child) {
        if (smartViewModal.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (!smartViewModal.hastMatchesNurses) {
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
          return SmartNursesDataTable(
            smartNurses: smartViewModal.filteredNursesWhithoutSmarts,
            selectedId: smartViewModal.selectedNurseId,
            onAssign: (int id) {
              idNurse = smartViewModal.updateSelectedNurseId(id);
            },
          );
        }
      },
    );
  }
}