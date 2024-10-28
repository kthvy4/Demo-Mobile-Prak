import 'package:demo_mobile/app/modules/Profile/controllers/editProfil_Controll.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Editprofile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Editprofile> {
  final EditProfileController _controller = EditProfileController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    await _controller.loadUserProfile();
    setState(() {}); // Update UI with loaded data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_controller.profileImageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_controller.profileImageUrl!),
              )
            else
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
              ),
            TextButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Change Profile Picture"),
              onPressed: () => _showImageSourceSelector(context),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (val) => _controller.name = val,
              controller: TextEditingController(text: _controller.name),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (val) => _controller.email = val,
              controller: TextEditingController(text: _controller.email),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
              onChanged: (val) => _controller.phone = val,
              controller: TextEditingController(text: _controller.phone),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
              onChanged: (val) => _controller.address = val,
              controller: TextEditingController(text: _controller.address),
            ),
            ElevatedButton(
              onPressed: () async {
                await _controller.updateUserProfile();
                // Navigate back to the profile screen after saving changes
                Navigator.of(context).pop();
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera'),
            onTap: () async {
              Navigator.of(context).pop();
              await _controller.pickImage(ImageSource.camera);
              setState(() {}); // Update UI with new image
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () async {
              Navigator.of(context).pop();
              await _controller.pickImage(ImageSource.gallery);
              setState(() {}); // Update UI with new image
            },
          ),
        ],
      ),
    );
  }
}
