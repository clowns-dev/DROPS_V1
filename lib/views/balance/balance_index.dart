import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/view_models/balance_view_model.dart';
import 'package:ps3_drops_v1/views/balance/balance_data.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';
import 'package:ps3_drops_v1/widgets/delete_confirmation_dialog.dart';

class BalanceIndex extends StatefulWidget {
  const BalanceIndex({super.key});

  @override
  State<BalanceIndex> createState() => _BalanceIndexState();
}

class _BalanceIndexState extends State<BalanceIndex> {
  Timer? _debounce;
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'Codigo'];
  Balance? _editingBalance, balance;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _balaceCodeController = TextEditingController();
  int?  idUser = 29;

  Map<String, bool> _fieldErrors = {
    'balanceCode': false,
    'balanceCodeInvalid': false,
    'userID': false,
    'codeRegistered': false,
  };

  void _resetFieldErrors(){
    setState(() {
      _fieldErrors = {
        'balanceCode': false,
        'balanceCodeInvalid': false,
        'userID': false,
        'codeRegistered': false,
      };
    });
  }

  void _resetForm(){
    _balaceCodeController.clear();
    _resetFieldErrors();
  }

  void _onCodeChanged(String code){
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final balanceViewModel = context.read<BalanceViewModel>();
      bool isCodeRegistered = await balanceViewModel.isCodeRegistered(code.trim());
      setState(() {
        _fieldErrors['balanceCode'] = code.trim().isEmpty;
        _fieldErrors['balanceCodeInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(code.trim());
        _fieldErrors['codeRegistered'] = isCodeRegistered && _editingBalance == null;
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
          },
        );
      },
    );
  }

  void _clearSearch(){
    _searchController.clear();
    _filterBalanceList('');
  }

  void _showDeleteConfirmationDialog(BuildContext context, int? balanceId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            final balanceViewModel = context.read<BalanceViewModel>();

            if(balanceId != null){
              balanceViewModel.removeBalance(balanceId, 1).then((_){
                balanceViewModel.fetchBalances();
                _clearSearch();
              });
            }

          },
        );
      },
    );
  }

  Future<void> _validateAndSubmit(BuildContext formDialogContext) async {
    final balanceViewModel = context.read<BalanceViewModel>();
    bool isCodeRegistered = await balanceViewModel.isCodeRegistered(_balaceCodeController.text.trim());

    setState(() {
      _fieldErrors['balanceCode'] = _balaceCodeController.text.trim().isEmpty;
      _fieldErrors['balanceCodeInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(_balaceCodeController.text.trim());
      _fieldErrors['userID'] = idUser == null || idUser == 0;
      _fieldErrors['codeRegistered'] = isCodeRegistered && _editingBalance == null;
    });

    if(_fieldErrors.containsValue(true)){
      if(kDebugMode){
        print("Estado fieldErrors: $_fieldErrors");
      }
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.of(formDialogContext).pop();

    if(_editingBalance != null){
      balance = Balance(
        idBalance: _editingBalance!.idBalance,
        balanceCode: _balaceCodeController.text.trim(),
        userID: idUser // ! Cambiarlo por el ID del usuario logueado en el sistema.
      );

      await balanceViewModel.editBalance(balance!);
      balanceViewModel.fetchBalances();
      _clearSearch();
      _resetForm();
      // ignore: use_build_context_synchronously
      _showSuccessDialog(context, true);
    } else {
      balance = Balance(
        balanceCode: _balaceCodeController.text.trim(),
        userID: idUser // ! Cambiar por el ID del usuario logueado en el sistema.
      );

      await balanceViewModel.createNewBalance(balance!);
      balanceViewModel.fetchBalances();
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
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

   void _filterBalanceList(String query) {
    final balanceViewModel = context.read<BalanceViewModel>();
    balanceViewModel.filterBalances(query, _selectedFilter);
  }


  void _showFormModal(BuildContext context, [Balance? balance]) {
      _editingBalance = balance;
      if (_editingBalance != null) {
        _balaceCodeController.text = _editingBalance!.balanceCode ?? '';
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
                          '../assets/img/nurse.png',
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
                                titleTable: _editingBalance == null ? 'Añadir Balanza' : 'Editar Balanza',
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            const TextLabel(content: 'Código:'),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _balaceCodeController,
                              onChanged: _onCodeChanged,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Ingrese el código',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: _fieldErrors['balanceCode']! 
                                        ? Colors.red 
                                        : _fieldErrors['codeRegistered']! 
                                            ? Colors.orange 
                                            : Colors.grey,
                                  ),
                                ),
                                errorText: _fieldErrors['balanceCode']!
                                    ? 'El campo no puede estar vacío.'
                                    : _fieldErrors['balanceCodeInvalid']!
                                        ? 'El código contiene caracteres no válidos.'
                                        : _fieldErrors['codeRegistered']!
                                            ? 'Este código ya está registrado.'
                                            : null,
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
                                          _editingBalance == null ? 'INSERTAR' : 'GUARDAR',
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleContainer(
              title: 'Gestión de Balanzas',
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
                    titleButton: 'Añadir Balanza',
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
                  titleTable: 'Historial de Balanzas',
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
                        if(_selectedFilter == 'Buscar por:'){
                          _filterBalanceList('');
                        }
                      },
                    ),
                    const SizedBox(width: 16.0),
                    SearchField(
                      controller: _searchController,
                      fullWidth: false,
                      onChanged: (query){
                        _filterBalanceList(query);
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
    return Consumer<BalanceViewModel>(
      builder: (context, balanceViewModel, child) {
        if (balanceViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (!balanceViewModel.hasMatches) {
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
          return BalanceDataTable(
            balances: balanceViewModel.filteredBalances,
            onEdit: (id) async {
              Balance? balance = await balanceViewModel.fetchBalanceById(id);
              if (balance != null) {
                setState(() {
                  _editingBalance = balance;
                });
                // ignore: use_build_context_synchronously
                _showFormModal(context, balance);
              }
            },
            onDelete: (id)  async {
              _showDeleteConfirmationDialog(context, id);
            },
          );
        }
      },
    );
  }
}
