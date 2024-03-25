import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uni_alarm/Services/database.dart';
import 'constants.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  late String image;
  Future getImage() async{
    try{
      image= await storage.ref('images/${user.uid}.png').getDownloadURL();
      return image;
    } on FirebaseException {
      image= await storage.ref('images/default.png').getDownloadURL();
      return image;
    }
  }

  Future pickImage() async{
    checked=true;
    final aux=await ImagePicker().pickImage(source: ImageSource.gallery);
    return aux;
  }

  Future<void> upload(String path) async{
    File file= File(path);
    try{
      String ref = 'images/${user.uid}.png';
      await storage.ref(ref).putFile(file);
      
    } on FirebaseException  {
    }

  }

  pickAndUploadImage() async {
    XFile file = await pickImage();
    if(file != null) {
      await upload(file.path);
      setState(() {});
    }
  }
  String name = username;
  bool checked=false;
  bool isEditing=false;
  final _controller = TextEditingController();



  Widget editUsername() {
    if (isEditing) {
      return TextField(
        maxLength: 15,
        controller: _controller,
        // autofocus: true,
        style: TextStyle(
          color: isDark ? darkText : lightText,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        onSubmitted: (String value) {
          setState(() {
            name = value;
            isEditing = false;
          });
        },
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.center,
            counterText: "",
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: InkWell(
                onTap: () {
                  setState(() {
                    name = _controller.text;
                    updateUsername(name);
                    username=name;
                    isEditing = false;
                  });
                },
                child: Icon(Icons.check, color: isDark ? darkText : lightText),
              ),
            ),
            suffixIconColor: Colors.red),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child:
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(name,
              style: TextStyle(color: isDark ? darkText : lightText)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          InkWell(
              onTap: () {
                setState(() {
                  _controller.text = name;
                  isEditing = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: themeImage("edit.png"), width: 15),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Text("Edit Profile",
                      style: TextStyle(color: isDark ? darkText : lightText))
                ],
              )
          )
        ]),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? darkBackground : lightBackground,
        body: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Stack(
                children: [
                  FutureBuilder(future:getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Placeholder widget while waiting for the image
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return ClipOval(
                          child: Image.network(
                            snapshot.data.toString(),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return Text('No image available');
                      }
                    },
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueGrey,
                        mini: true,
                        onPressed: () {
                          pickAndUploadImage();
                        },
                        child: const Icon(Icons.add),
                      )
                  )
                ],
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: editUsername(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: isDark ? darkDetails : lightDetails,
                    ),
                  ),
                  color: isDark ? darkMainCards : lightMainCards,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("DarkTheme", style: TextStyle(color: isDark?darkText : lightText, fontSize: 15)),
                        Switch(
                          key: const ValueKey('DarkTheme_switch'),
                          activeColor: lightBackground,
                          activeTrackColor: darkDetails,
                          inactiveThumbColor: darkBackground,
                          inactiveTrackColor: lightDetails,
                          value: isDark,
                          onChanged: (bool value) {
                            setState(() {
                              if (!autoTheme) {
                                isDark = value;
                                colorNotifier.value = isDark;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: isDark ? darkDetails : lightDetails,
                    ),
                  ),
                  color: isDark ? darkMainCards : lightMainCards,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Automatic Theme", style: TextStyle(color: isDark?darkText : lightText, fontSize: 15)),
                        Switch(
                          activeColor: lightBackground,
                          activeTrackColor: darkDetails,
                          inactiveThumbColor: darkBackground,
                          inactiveTrackColor: lightDetails,
                          value: autoTheme,
                          onChanged: (bool value){
                            updateAutoTheme(value);
                            autoTheme = value;
                            setState((){
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width:(MediaQuery.of(context).size.width)*0.4,height: (MediaQuery.of(context).size.height)*0.2,),
              Expanded(
                flex: 1,
                child: IconButton(
                  key: const ValueKey('logout_button'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image(image: themeImage("logout.png")),
                  iconSize: 60,
                ),
              ),
            ],
          ),
        ));
  }
}
