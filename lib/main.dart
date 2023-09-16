// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() => runApp(Contact());

class Contact extends StatefulWidget {
  const Contact({Key? key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  bool switched = false;
  List<ContactModel> contacts = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
      ),
      themeMode: switched ? ThemeMode.dark : ThemeMode.light,
      home: Homepage(
        isDark: switched,
        onThemeChanged: (value) {
          setState(() {
            switched = value;
          });
        },
        contacts: contacts,
        onAddContact: (contact) {
          setState(() {
            contacts.add(contact);
          });
        },
        onEditContact: (index, updatedContact) {
          setState(() {
            contacts[index] = updatedContact;
          });
        },
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;
  final List<ContactModel> contacts;
  final Function(ContactModel) onAddContact;
  final Function(int, ContactModel) onEditContact;

  Homepage({
    Key? key,
    required this.isDark,
    required this.onThemeChanged,
    required this.contacts,
    required this.onAddContact,
    required this.onEditContact,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Diary",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.onThemeChanged(!widget.isDark);
              });
            },
            icon: Icon(
              widget.isDark ? Icons.brightness_2 : Icons.sunny,
              color: Colors.black,
              size: 25,
            ),
          ),
          Icon(
            Icons.more_vert,
            color: Colors.black,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          final contact = widget.contacts[index];
          return ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(contact.name),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Phone: ${contact.number}'),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Call action
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Message action
                            },
                            icon: Icon(
                              Icons.message,
                              color: Colors.yellow,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Video call action
                            },
                            icon: Icon(
                              Icons.videocam,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Share action
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text(
                contact.firstName[0],
                style: TextStyle(fontSize: 24),
              ),
            ),
            title: Text(contact.name),
            subtitle: Text(contact.number),
            trailing: PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Edit"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Delete"),
                ),
              ],
              onSelected: (value) {
                if (value == 0) {
                  _editContact(index, contact);
                } else if (value == 1) {
                  _deleteContact(index);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage()),
          );
          if (newContact != null) {
            widget.onAddContact(newContact);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editContact(int index, ContactModel contact) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditContactPage(contact: contact)),
    );
    if (updatedContact != null) {
      widget.onEditContact(index, updatedContact);
    }
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.contacts.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Contact',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newContact = ContactModel(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        number: _numberController.text,
                        email: _emailController.text,
                      );
                      Navigator.pop(context, newContact);
                    }
                  },
                  child: Center(child: Text('Save')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditContactPage extends StatefulWidget {
  final ContactModel contact;

  EditContactPage({required this.contact});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.contact.firstName;
    _lastNameController.text = widget.contact.lastName;
    _numberController.text = widget.contact.number;
    _emailController.text = widget.contact.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Contact',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedContact = ContactModel(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        number: _numberController.text,
                        email: _emailController.text,
                      );
                      Navigator.pop(context, updatedContact);
                    }
                  },
                  child: Center(child: Text('Update')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactModel {
  final String firstName;
  final String lastName;
  final String number;
  final String email;

  ContactModel({
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.email,
  });

  String get name => '$firstName $lastName';
}
