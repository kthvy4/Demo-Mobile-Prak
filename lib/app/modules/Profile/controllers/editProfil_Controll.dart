import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late User user;
  String? name, email, phone, address, profileImageUrl;
  File? _imageFile;

  EditProfileController() {
    user = _auth.currentUser!;
  }

  Future<void> loadUserProfile() async {
    var userData = await _firestore.collection('Profile').doc(user.uid).get();
    if (userData.exists) {
      name = userData['Nama'];
      email = userData['Email'];
      phone = userData['No telepon'];
      address = userData['alamat'];
      profileImageUrl = userData['profileImageUrl'];
    }
  }

  Future<void> updateUserProfile() async {
    Map<String, dynamic> dataToUpdate = {
      'Nama': name,
      'Email': email,
      'No telepon': phone,
      'alamat': address,
    };

    // Include the profileImageUrl only if a new one has been uploaded
    if (profileImageUrl != null) {
      dataToUpdate['profileImageUrl'] = profileImageUrl;
    }

    await _firestore.collection('Profile').doc(user.uid).update(dataToUpdate);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      await uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    if (_imageFile == null) return;

    try {
      final ref = _storage.ref().child('profile_images').child('${user.uid}.jpg');
      await ref.putFile(_imageFile!);

      // Get the new profile image URL
      profileImageUrl = await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      // Handle upload error if needed
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
