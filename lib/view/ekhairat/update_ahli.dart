// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/tanggungan.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/ekhairat/maklumat_ahli.dart';

class UpdateAhli extends StatefulWidget {
  final Ahli ahli;
  const UpdateAhli({super.key, required this.ahli});

  @override
  State<UpdateAhli> createState() => _UpdateAhliState();
}

class _UpdateAhliState extends State<UpdateAhli> {
  final _formKey = GlobalKey<FormState>();
  final EkhairatService ekhairatService = EkhairatService();
  late Ahli ahli;

  @override
  void initState() {
    super.initState();
    ahli = widget.ahli;
  }

  void _updateAhli() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await ekhairatService.updateAhli(ahli);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MaklumatAhli(ahli: ahli)),
          (route) => false);
    }
  }

  void _addTanggungan() {
    setState(() {
      ahli.tanggungan.add(Tanggungan(name: '', ic: '', hubungan: ''));
    });
  }

  void _removeTanggungan(int index) {
    setState(() {
      ahli.tanggungan.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kemaskini Maklumat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField('Nama', ahli.name,
                          (value) => ahli.name = value),
                      _buildTextField('Email', ahli.email,
                          (value) => ahli.email = value,
                          readOnly: true),
                      _buildTextField('No. Kad Pengenalan', ahli.ic,
                          (value) => ahli.ic = value),
                      _buildTextField('Alamat', ahli.alamat,
                          (value) => ahli.alamat = value),
                      _buildTextField('No. Telefon', ahli.phone,
                          (value) => ahli.phone = value),
                      _buildTextField('No. Telefon Kecemasan',
                          ahli.emergencyPhone, (value) => ahli.emergencyPhone = value),
                      _buildDropdown('Status', ahli.status,
                          (value) => ahli.status = value!, ['ACTIVE', 'PENDING', 'EXPIRED']),
                      SizedBox(height: 10),
                      ...ahli.tanggungan
                          .asMap()
                          .entries
                          .map((entry) => _buildTanggunganForm(entry.key, entry.value))
                          .toList(),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _addTanggungan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryButtonColor,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text('Tambah Tanggungan', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _updateAhli,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(Icons.update, color: Colors.white),
                        label: Text('Kemaskini', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onSave, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: secondaryColor,
        ),
        style: TextStyle(color: Colors.white, fontSize: 14),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Sila Masukkan $label';
          }
          return null;
        },
        onSaved: (value) => onSave(value!),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, Function(String?) onChanged, List<String> items) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        fillColor: secondaryColor,
        labelStyle: TextStyle(color: Colors.blue),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(15)),
        filled: true,
      ),
      dropdownColor: secondaryColor,
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item, style: TextStyle(color: Colors.white, fontSize: 14)),
      ))
          .toList(),
      onChanged: onChanged,
    ),
  );
}


  Widget _buildTanggunganForm(int index, Tanggungan tanggungan) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        color: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tanggungan ${index + 1}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeTanggungan(index),
                  ),
                ],
              ),
              SizedBox(height: 5),
              _buildTextField('Nama', tanggungan.name,
                  (value) => tanggungan.name = value),
              _buildTextField('No. Kad Pengenalan', tanggungan.ic,
                  (value) => tanggungan.ic = value),
              _buildTextField('Hubungan', tanggungan.hubungan,
                  (value) => tanggungan.hubungan = value),
            ],
          ),
        ),
      ),
    );
  }
}
