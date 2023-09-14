import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/common/loader.dart';
import 'package:socialmedia/common/utills.dart';
import 'package:socialmedia/provider/user_provider.dart';
import 'package:socialmedia/services/firestore_methods.dart';
import 'package:socialmedia/utils/colors.dart';

import '../../model/user.dart';

class AddPostScrreen extends StatefulWidget {
  const AddPostScrreen({super.key});

  @override
  State<AddPostScrreen> createState() => _AddPostScrreenState();
}

class _AddPostScrreenState extends State<AddPostScrreen> {
  Uint8List? _file;
  final TextEditingController descriptionController = TextEditingController();
  bool _isloading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            elevation: 45,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            title: const Text(
              "Create a post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  void postImage(
    String uid,
    String username,
    String profimage,
  ) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
        _file!,
        descriptionController.text,
        uid,
        username,
        profimage,
      );

      if (res == "success") {
        setState(() {
          _isloading = false;
        });
        showSnackBar(context, "Post added Successfully");
        clearimage();
      } else {
        setState(() {
          _isloading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void clearimage() {
    setState(() {
      _file = null;
      descriptionController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: GestureDetector(
            onTap: () => _selectImage(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Select Image To Post",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Icon(
                  Icons.upload_rounded,
                  color: Colors.blue,
                  size: 50,
                ),
              ],
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: clearimage,
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                _isloading
                    ? Container(
                        margin: const EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Posting...",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : TextButton(
                        onPressed: () => postImage(
                          user.uid,
                          user.username,
                          user.photoUrl,
                        ),
                        child: const Text(
                          "Post",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            body: Column(
              children: [
                _isloading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                _file!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                // const Divider(
                //   height: 10,
                //   color: Colors.grey,
                // )
              ],
            ),
          );
  }
}
