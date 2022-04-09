import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ira/data/save.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditPage extends StatefulWidget {
  final SharedPreferences prefs;

  const EditPage({Key? key, required this.prefs}) : super(key: key);

  @override
  State<EditPage> createState() => _EditState();
}

class _EditState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  String _name = '', _gender = '', _uType = '', _address = '', _profileImg = '';
  @override
  void initState() {
    super.initState();
    _gender = widget.prefs.getString('gender')!;
    _name = widget.prefs.getString('name')!;
    _uType = widget.prefs.getString('type')!;
    _address = widget.prefs.getString('address')!;
    _profileImg = widget.prefs.getString('profImg')!;
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imagePermanent = await saveImagePermanent(image.path);
      setState((() => this.image = imagePermanent));
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {}
  }

  Future<File> saveImagePermanent(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Widget _userProfile(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ImageProvider<Object>? backgroundImage = image != null
        ? FileImage(image!)
        : _profileImg == 'none'
            ? AssetImage('images/logo.png')
            : NetworkImage(_profileImg) as ImageProvider;
    return Column(
      children: [
        SizedBox(height: 10),
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                  radius: size.width * 0.25, backgroundImage: backgroundImage),
              Container(
                  alignment: Alignment.bottomRight,
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_rounded, size: 40),
                    onPressed: () => pickImage(),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userName(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: 900,
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.0, right: size.width * 0.0),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter Your Name';
            } else {
              _name = value;
            }
            return null;
          },
          initialValue: _name,
          decoration: InputDecoration(
            labelText: 'Enter Your Name',
            icon: Icon(Icons.person),
          ),
        ),
      ),
    );
  }

  Widget _userAddress(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: 900,
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.0, right: size.width * 0.0),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter Your Address';
            } else {
              _address = value;
            }
            return null;
          },
          initialValue: _address,
          decoration: InputDecoration(
              labelText: 'Enter Your Address',
              icon: Icon(Icons.location_city_rounded)),
        ),
      ),
    );
  }

  Widget _userGender(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Choose Your Gender',
          style: TextStyle(fontSize: 17, color: Colors.grey[700]),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.arrow_forward_ios, color: Colors.grey[500]),
            SizedBox(width: 10),
            ToggleSwitch(
              totalSwitches: 3,
              labels: ['Male', 'Female', 'Others'],
              icons: [Icons.male, Icons.female, Icons.call_split_rounded],
              cornerRadius: 30,
              minWidth: 100,
              initialLabelIndex: _gender == 'Male'
                  ? 0
                  : _gender == 'Female'
                      ? 1
                      : 2,
              onToggle: (index) {
                _gender = index == 0
                    ? 'Male'
                    : index == 1
                        ? 'Female'
                        : 'Others';
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      width: 150,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: Colors.deepPurple,
      ),
      child: Center(
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
              editUserData(
                  context: context,
                  prefs: widget.prefs,
                  uname: _name,
                  ugender: _gender,
                  uType: _uType,
                  uaddress: _address,
                  phoneNo: widget.prefs.getString('phone')!,
                  uimage: image);
            }
          },
          child: const Text(
            'Update',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _userForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _userName(context),
            SizedBox(height: 15),
            _userAddress(context),
            SizedBox(height: 15),
            _userGender(context),
            SizedBox(height: 15),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Your Information"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          _userProfile(context),
          _userForm(context),
        ],
      )),
    );
  }
}
