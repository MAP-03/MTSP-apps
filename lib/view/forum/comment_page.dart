// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/services/forum_service.dart';
import 'package:mtsp/view/forum/forum_page.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final Map<String, dynamic> forumData;
  const CommentPage({Key? key, required this.forumData}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late ForumsService _forumService;
  bool _isLoading = true;
  File? imageFile;
  bool _isSending = false;
  TextEditingController _commentController = TextEditingController();
  final Map<String, dynamic> userData = {};
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _forumService = Provider.of<ForumsService>(context, listen: false);
    _forumService.getComments(widget.forumData['id']).then((_) {
      setState(() {
        authService.getCurrentUserData().then((value) {
          setState(() {
            userData.addAll(value);
          });
        });
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komen', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Forum()));
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      color: Color(0xFF040C23),
                      margin: const EdgeInsets.all(5),
                      elevation: 5,
                      child: Stack(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                     userData['profileImage'] == null
                                      ? CircleAvatar(
                                          backgroundImage: const AssetImage('assets/images/profileMan.png'),
                                          radius: 20,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showImageViewer(
                                              doubleTapZoomable: true,
                                                context,
                                                NetworkImage(
                                                  userData['profileImage'],
                                                ),
                                            );
                                          },
                                        child: CircleAvatar(
                                            backgroundImage: NetworkImage(userData['profileImage']),
                                            radius: 20,
                                          ),
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.forumData['username'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: widget.forumData['email'] == FirebaseAuth.instance.currentUser!.email
                                        ? Colors.blue
                                        : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Divider(color: Colors.white, height: 10, thickness: 1),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  widget.forumData['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (widget.forumData.containsKey('imageUrl') == true && widget.forumData['imageUrl'] != null) ...[
                                  GestureDetector(
                                    onTap: () {
                                      showImageViewer(
                                        doubleTapZoomable: true,
                                        context,
                                        NetworkImage(widget.forumData['imageUrl']),
                                      );
                                    },
                                    child: Image.network(
                                      widget.forumData['imageUrl'],
                                      width: double.infinity,
                                      height: 350.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Text(
                                  widget.forumData['description'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  Jiffy.parseFromDateTime(widget.forumData['timestamp'].toDate()).fromNow().toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: Color(0xFFA19CC5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          if (widget.forumData['email'] == FirebaseAuth.instance.currentUser!.email || userData['role'] == 'admin')
                            Positioned(
                              top: 0,
                              right: 0,
                              child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.white),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Padam perbincangan'),
                                          content: Text('Ada pasti mahu padam perbincangan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                _forumService.deleteForum(widget.forumData['id']);

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => Forum()),
                                                  (route) => false,
                                                );

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                              child: Text('Padam'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    height: 40,
                                    value: 'delete',
                                    child: Text('Delete', style: GoogleFonts.poppins(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Consumer<ForumsService>(
                      builder: (context, forumService, _) {
                        if (_isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (forumService.commentData.isEmpty) {
                          return const Center(
                            child: Text(
                              'Tiada komen',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: forumService.commentData.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color.fromARGB(255, 0, 18, 53),
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                               userData['profileImage'] == null
                                                ? CircleAvatar(
                                                    backgroundImage: const AssetImage('assets/images/profileMan.png'),
                                                    radius: 20,
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      showImageViewer(
                                                        doubleTapZoomable: true,
                                                          context,
                                                          NetworkImage(
                                                            userData['profileImage'],
                                                          ),
                                                      );
                                                    },
                                                  child: CircleAvatar(
                                                      backgroundImage: NetworkImage(userData['profileImage']),
                                                      radius: 20,
                                                    ),
                                                ),
                                              const SizedBox(width: 10),
                                              Text(
                                                forumService.commentData[index]['username'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: forumService.commentData[index]['email'] == FirebaseAuth.instance.currentUser!.email
                                                  ? Colors.blue
                                                  : Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const Divider(color: Colors.white, height: 10, thickness: 1),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            forumService.commentData[index]['comment'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          if (forumService.commentData[index].containsKey('imageUrl') == true && forumService.commentData[index]['imageUrl'] != null) ...[
                                            GestureDetector(
                                              onTap: () {
                                                showImageViewer(
                                                  doubleTapZoomable: true,
                                                  context,
                                                  NetworkImage(forumService.commentData[index]['imageUrl']),
                                                );
                                              },
                                              child: Image.network(
                                                forumService.commentData[index]['imageUrl'],
                                                width: double.infinity,
                                                height: 350.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                          forumService.commentData[index]['timestamp'].runtimeType == DateTime
                                              ? Text(
                                                  Jiffy.parseFromDateTime(forumService.commentData[index]['timestamp']).fromNow().toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w200,
                                                    color: Color(0xFFA19CC5),
                                                  ),
                                                )
                                              : Text(
                                                  Jiffy.parseFromDateTime(forumService.commentData[index]['timestamp'].toDate()).fromNow().toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w200,
                                                    color: Color(0xFFA19CC5),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    if (forumService.commentData[index]['email'] == FirebaseAuth.instance.currentUser!.email || userData['role'] == 'admin')
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: Colors.white),
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Padam komen'),
                                                    content: Text('Adakah anda pasti mahu padam komen ini?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context).pop();
                                                          setState(() {
                                                            _isLoading = true;
                                                          });

                                                          await forumService.deleteComment(widget.forumData['id'], forumService.commentData[index]['id']);

                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        },
                                                        child: Text('Padam'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                              height: 40,
                                              value: 'delete',
                                              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.blue)),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 80), // Add padding to avoid bottom sheet overlap
                  ],
                ),
              ),
            ),
      bottomSheet: SafeArea(
        child: Container(
          color: secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Tulis komen anda...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
              ),
              if (imageFile == null)
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () async {
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
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showImageViewer(
                            doubleTapZoomable: true,
                            context,
                            FileImage(imageFile!),
                          );
                        },
                        child: Image.file(
                          imageFile!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              imageFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(0),
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            _isSending = true;
                          });

                          _forumService.createComment(
                            widget.forumData['id'],
                            _commentController.text,
                            FirebaseAuth.instance.currentUser!.email!,
                            userData['username'],
                            imageFile,
                          ).then((_) {
                            setState(() {
                              _isSending = false;
                            });
                          });

                          _commentController.clear();
                          setState(() {
                            imageFile = null;
                          });
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
