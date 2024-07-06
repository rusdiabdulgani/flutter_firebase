import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showCreateDataForm(context);
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Create Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/login");
                // showToast(message: "Successfully signed out"); // Nonaktifkan toast jika tidak digunakan
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildUserList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return DataTable(
          columns: [
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('Alamat')),
            DataColumn(label: Text('Umur')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: userProvider.users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.username ?? '')),
                DataCell(Text(user.adress ?? '')),
                DataCell(Text(user.age?.toString() ?? '')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDataForm(context, user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          userProvider.removeUser(user);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  void _showCreateDataForm(BuildContext context) {
    _usernameController.clear();
    _addressController.clear();
    _ageController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Data'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Nama';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Alamat';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Umur'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Umur';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukkan Umur yang Valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<UserProvider>(context, listen: false).addUser(
                    UserModel(
                      username: _usernameController.text,
                      adress: _addressController.text,
                      age: int.parse(_ageController.text),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDataForm(BuildContext context, UserModel user) {
    _usernameController.text = user.username ?? '';
    _addressController.text = user.adress ?? '';
    _ageController.text = user.age?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Nama';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Alamat';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Umur'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan Umur';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukkan Umur yang Valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<UserProvider>(context, listen: false).updateUser(
                    user.id!,
                    UserModel(
                      id: user.id,
                      username: _usernameController.text,
                      adress: _addressController.text,
                      age: int.parse(_ageController.text),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class UserModel {
  final String? id;
  final String? username;
  final String? adress;
  final int? age;

  UserModel({this.id, this.username, this.adress, this.age});
}

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  int _idCounter = 0;

  List<UserModel> get users => _users;

  void addUser(UserModel user) {
    user = UserModel(
      id: (_idCounter++).toString(),
      username: user.username,
      adress: user.adress,
      age: user.age,
    );
    _users.add(user);
    notifyListeners();
  }

  void updateUser(String id, UserModel updatedUser) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void removeUser(UserModel user) {
    _users.removeWhere((u) => u.id == user.id);
    notifyListeners();
  }
}
