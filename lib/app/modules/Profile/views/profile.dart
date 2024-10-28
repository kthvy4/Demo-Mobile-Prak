import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String? _profileImageUrl;
  bool _isLoading = true;

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('Profile').doc(user.uid).get();
        setState(() {
          _name = userDoc['Nama'] ?? 'Nama tidak tersedia';
          _email = userDoc['Email'] ?? 'Email tidak tersedia';
          _phone = userDoc['No telepon'] ?? 'Nomor tidak tersedia';
          _address = userDoc['alamat'] ?? 'Alamat tidak tersedia';
          _profileImageUrl = userDoc['profileImageUrl'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete the user's profile document from Firestore
        await _firestore.collection('Profile').doc(user.uid).delete();
        // Sign out the user
        await _auth.signOut();
        // Redirect to login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error deleting profile: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete profile. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0D9),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _profileImageUrl != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_profileImageUrl!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/cat.png'),
                          ),
                    SizedBox(height: 20),
                    Text(
                      'PROFIL',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildProfileItem('Nama', _name),
                    _buildProfileItem('Email', _email),
                    _buildProfileItem('No telepon', _phone),
                    _buildProfileItem('Alamat', _address),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(context, '/edit_profile');
                            if (result == true) {
                              _fetchUserData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text('Edit Profile'),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text('Settings'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      ),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Confirm before deleting the profile
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Profile'),
                            content: Text('Are you sure you want to delete your profile? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _deleteProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      ),
                      child: Text(
                        'DELETE PROFILE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}