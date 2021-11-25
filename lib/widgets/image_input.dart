import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;

class ImageInput extends StatefulWidget {
  Function selectedImage;
  ImageInput(this.selectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDirectory = await sysPaths
        .getApplicationDocumentsDirectory(); //That's a directory on the device which is reserved for app data.

    final fileName = path.basename(imageFile
        .path); //to get the name that was automatically assigned by the camera, by the image picker.

    //call copy to copy this file in a new location. So that's great. Now we need to enter a path on our device where we want to copy this, too. And this is the very tricky part, because, of course, as you can imagine on OS and Android, you can't write files to any place on the hard drive. Instead, there are a lot of restrictions regarding where you can write data to so that you don't clutter up the hard drive of the mobile device or start writing files into folders where you really shouldn't have access.So Dan, for both I was an android typically give you a certain path where you can store where your app related data.and that good because whenever I delete data I erase where the path shows and that keeps my hard drive clean and therefore I need to know which path to use and this something I know from the site pub.div
    final savedImage = await _storedImage.copy(
        '${appDirectory.path}/$fileName'); // for a copy, we need a path which is actually just a string, not a directory handle. But the good thing is that our app Dir directory has a path property which gives us the path as a stream. But I don't want to copy my image like this. Instead, you also have to provide the name of the image it should have. And for that I'm fine with the name that was automatically assigned by the camera, by the image picker. So that means I basically copy the file into this path and I keep the file name.

    widget.selectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image taken🥵',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}
