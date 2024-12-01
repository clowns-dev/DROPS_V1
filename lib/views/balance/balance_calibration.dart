import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/maintenance.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/view_models/balance_view_model.dart';
import 'package:ps3_drops_v1/view_models/maintenance_view_model.dart';
import 'package:ps3_drops_v1/widgets/error_exist_dialog.dart';
import 'package:ps3_drops_v1/widgets/error_form_dialog.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';

class BalanceCalibration extends StatefulWidget {
  const BalanceCalibration({super.key});

  @override
  State<BalanceCalibration> createState() => _BalanceCalibrationState();
}

class _BalanceCalibrationState extends State<BalanceCalibration> {
  final TextEditingController _balanceCodeController = TextEditingController();
  final TextEditingController _newFactorController = TextEditingController();
  Maintenance? maintenance, balanceData;
  int? getBalanceId;
  String? getBalaceCode;

  Map<String, bool> _fieldErrors = {
    'balanceCode': false,
    'newFactorValue': false,
    'newFactorValueInvalid': false,
    'balanceExists': false
  };

  void _resetFieldErrors(){
    setState(() {
      _fieldErrors = {
        'balanceCode': false,
        'newFactorValue': false,
        'newFactorValueInvalid': false,
        'balanceExists': false
      };
    });
  }

  void _resetForm(){
    _balanceCodeController.clear();
    _resetFieldErrors();
  }

  void _showErrorFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(
          title: 'Faltan datos',
          message: '¡Faltan datos necesarios para la creacion!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _showErrorExistsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return UserExistsDialog(
          title: "Calibracion Fallida",
          message:  'Balanza NO registrada!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: 'Registro Exitoso',
          message: '¡Se creó el registro correctamente!',
          onBackPressed: () { 
            Navigator.of(context).pop();
            setState(() {
              _resetForm();
            });
          },
        );
      },
    );
  }

  void _validateAndSubmit() async {
    final maintenanceViewModel = context.read<MaintenanceViewModel>();
    setState(() {
      _fieldErrors['balanceCode'] = _balanceCodeController.text.trim().isEmpty;
      _fieldErrors['newFactorValue'] = _newFactorController.text.trim().isEmpty;
      _fieldErrors['newFactorValueInvalid'] = !RegExp(r'^\d+([.,]\d+)?$').hasMatch(_newFactorController.text.trim());
    });

    if(_fieldErrors.containsValue(true)){
      _showErrorFormDialog(context);
      return;
    }

    final balanceViewModel = context.read<BalanceViewModel>();
    bool isExists = await balanceViewModel.isCodeRegistered(context, _balanceCodeController.text.trim());
    if(!isExists){
      _showErrorExistsDialog();
      return;
    } else {
      maintenance = Maintenance(
        idBalance: getBalanceId,
        idUser: sessionManager.idUser,
        lastFactor: double.tryParse(_newFactorController.text.trim())
      );

      // ignore: use_build_context_synchronously
      maintenanceViewModel.createNewMaintenance(context ,maintenance!).then((_) {
        maintenanceViewModel.disconnectMqtt(_balanceCodeController.text.trim());
        _resetForm();
        if(mounted){
          _showSuccessDialog(context);
        }
      });

    }
  }

  @override
  void dispose() {
    _balanceCodeController.dispose();
    _newFactorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MaintenanceViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    '../assets/img/monitoring.png',
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Parte derecha
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calibración de balanzas',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _balanceCodeController,
                          onChanged: (value) {
                            setState(() {
                              _fieldErrors['balanceCode'] = _balanceCodeController.text.trim().isEmpty;
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Código de la balanza',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: _fieldErrors['balanceCode']! ? Colors.red : Colors.grey),
                            ),
                            errorText: _fieldErrors['balanceCode']! ? 'Campo obligatorio para calibrar' : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC9A0DC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        onPressed: () async {
                          final balanceCode = _balanceCodeController.text.trim();
                          if (balanceCode.isNotEmpty) {
                            balanceData = await viewModel.fetchBalanceId(context,balanceCode);
                            if(balanceData != null){
                              getBalanceId = balanceData!.idBalance;
                              getBalaceCode = balanceData!.balanceCode;
                              await viewModel.subscribeToBalance(getBalaceCode.toString());
                            } else {
                              _showErrorExistsDialog();
                              return;
                            }
                          }
                        },
                        child: const Text(
                          'Calibrar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Ajuste de parámetros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: 'Peso actual: ${viewModel.receivedPeso}',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Peso actual',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: 'Factor actual: ${viewModel.receivedFactor}',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Factor actual',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nuevo factor de calibración
                  TextField(
                    controller: _newFactorController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Nuevo factor de calibración',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: _fieldErrors['newFactorValue']! ? Colors.red : Colors.grey),
                      ),
                      errorText: _fieldErrors['newFactorValue']! ? 'Campo obligatorio' : _fieldErrors['newFactorValueInvalid']! ? 'Valor invalido' : null, 
                    ),
                    onChanged: (value) {
                      setState(() {
                        _fieldErrors['newFactorValue'] = _newFactorController.text.trim().isEmpty;
                        _fieldErrors['newFactorValueInvalid'] = !RegExp(r'^\d+([.,]\d+)?$').hasMatch(_newFactorController.text.trim());
                      });
                    },
                    
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC9A0DC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          final balanceCode = _balanceCodeController.text.trim();
                          final newFactor = _newFactorController.text.trim();
                          if (balanceCode.isNotEmpty && newFactor.isNotEmpty) {
                            viewModel.publishNewFactor(balanceCode, newFactor);
                          } else {
                            setState(() {
                              _fieldErrors['balanceCode'] = true;
                            });
                          }
                        },
                        child: const Text(
                          'Probar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9A0DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 20),
                      ),
                      onPressed: _validateAndSubmit,
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
