// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/services/forum_service.dart';
import 'package:mtsp/view/forum/forum_page.dart';
import 'package:mtsp/widgets/toast.dart';

class CreateForum extends StatefulWidget {
  const CreateForum({super.key});

  @override
  State<CreateForum> createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {

  final ForumsService _forumService = ForumsService();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final Map<String, dynamic> userData = {}; 
  AuthService authService = AuthService();
  
  File? imageFile;
  bool _isPosting = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.getCurrentUserData().then((value) {
      setState(() {
        userData.addAll(value);
      });
    });
  }

 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Perbincangan', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2,
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
                style: TextStyle(color: Colors.white),
                minLines: 5,
                maxLines: null,
              ),
        
              const SizedBox(height: 20.0),
        
              imageFile != null
                  ? GestureDetector(
                      onTap: () {
                        showImageViewer(
                          doubleTapZoomable: true,
                          context,
                          FileImage(imageFile!), 
                        );
                      },
                      child: Stack( children: [
                        Image.file(
                          imageFile!,
                          width: double.infinity,
                          height: 350.0,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFile = null;
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 30.0,
                            ),
                          ),
                        ),
                    ],),
                    )
        
                  : InkWell(
                      onTap: () {
                        FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png'],
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              imageFile = File(value.files.single.path!);
                            });
                          }
                        });
                      },
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    ),
        
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () async {
                  if (_isPosting) return; 
                  if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                    showToast(message: 'Please fill all fields');
                    return;
                  }

                  setState(() {
                    _isPosting = true; 
                  });

                  try {
                    await _forumService.createForum(
                      _titleController.text,
                      _descriptionController.text,
                      userData['email'],
                      userData['username'],   
                      imageFile,
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Forum()),
                      (route) => false,
                    );
                  } catch (e) {
                    showToast(message: 'Failed to post');
                  } finally {
                    setState(() {
                      _isPosting = false; 
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                    end: Alignment(0.97, -0.26),
                    begin: Alignment(-0.97, 0.26),
                    colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                  ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isPosting
                        ? CircularProgressIndicator( 
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Hantar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}