
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/services/forum_service.dart';
import 'package:mtsp/view/forum/comment_page.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:provider/provider.dart';



class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  late ForumsService _forumService;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, dynamic> userData = {}; 
  AuthService authService = AuthService();

  @override
  void initState(){
    super.initState();
    _forumService = Provider.of<ForumsService>(context, listen: false);
    _forumService.getForums().then((_) {
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
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Forum', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: primaryColor,
          bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2,
          ),
        ),
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      body: Consumer<ForumsService>(
        builder: (context, forumService, _) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (forumService.forumData.isEmpty) {
            return Center(
              child: Text(
                'Tiada perbincangan',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            );
          }
          else {
            return ListView.builder(
              itemCount: forumService.forumData.length,
              itemBuilder: (context, index) {
                return Card(
                  color: primaryColor,
                  margin: const EdgeInsets.all(10),
                  elevation: 0,
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
                                forumService.forumData[index]['username'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: forumService.forumData[index]['email'] == FirebaseAuth.instance.currentUser!.email
                                  ? Colors.blue
                                  : Colors.white,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          const SizedBox(height: 10, child: Divider(color: Colors.white, height: 10, thickness: 1, indent: 0, endIndent: 0)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                      
                          Text(
                            forumService.forumData[index]['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          if(forumService.forumData[index].containsKey('imageUrl') == true && forumService.forumData[index]['imageUrl'] != null)...[
                            GestureDetector(
                              onTap: () {
                                showImageViewer(
                                  doubleTapZoomable: true,
                                  context,
                                  NetworkImage(
                                    forumService.forumData[index]['imageUrl'],
                                  ),
                                );
                              },
                              child: Image.network(
                                forumService.forumData[index]['imageUrl'],
                                width: double.infinity,
                                height: 350.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          Text(
                            forumService.forumData[index]['description'],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),


                          Text(
                            Jiffy.parseFromDateTime(forumService.forumData[index]['timestamp'].toDate()).fromNow().toString(),
                            style: GoogleFonts.poppins(   
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                              color: Color(0xFFA19CC5),
                            ),
                          ),
                                          
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.comment, color: Colors.white, size: 25),

                                  const SizedBox(width: 10),
                                  Text(
                                    (forumService.forumData[index]['comments'] != null && forumService.forumData[index]['comments'].isNotEmpty)
                                      ? forumService.forumData[index]['comments'].length.toString()
                                      : '0', 
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                        forumData: forumService.forumData[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Lihat komen',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          
                        ],
                      ),
                    ),

                    if (forumService.forumData[index]['email'] == FirebaseAuth.instance.currentUser!.email || userData['role'] == 'admin')
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
                                    title: Text('Padam perbincangan', style: TextStyle(color: Colors.white)),
                                    content: Text('Adakah anda pasti untuk memadam perbincangan ini?', style: TextStyle(color: Colors.white)),
                                    backgroundColor: primaryColor,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Batal', style: GoogleFonts.poppins(color: Colors.blue)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _isLoading = true;
                                          });
                
                                          await forumService.deleteForum(
                                            forumService.forumData[index]['id'],
                                          );
                
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                        child: Text('Padam', style: GoogleFonts.poppins(color: Colors.blue)),
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
                              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.blue),),
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

      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment(0.97, -0.26),
            begin: Alignment(-0.97, 0.26),
            colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
          ),
          shape: BoxShape.circle,
        ),
        child: FractionallySizedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create_forum');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}