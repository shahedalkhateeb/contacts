import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'app_theme.dart';
import 'contact.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int maxContacts = 6;
  final List<Contact> _contacts = [];

  bool get _canAdd => _contacts.length < maxContacts;

  Future<void> _openSheet() async {
    final contact = await showModalBottomSheet<Contact>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddContactSheet(),
    );
    if (contact != null) {
      setState(() => _contacts.add(contact));
    }
  }

  void _deleteContact(Contact contact) {
    setState(() => _contacts.remove(contact));
  }

  void _deleteLast() {
    if (_contacts.isEmpty) return;
    setState(() => _contacts.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        titleSpacing: 16,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: RouteLogo(width: 120),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _contacts.isEmpty ? _buildEmpty() : _buildGrid(),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_contacts.isNotEmpty)
            FloatingActionButton(
              heroTag: 'delete_last',
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              onPressed: _deleteLast,
              child: const Icon(Icons.delete),
            ),
          if (_contacts.isNotEmpty && _canAdd)  SizedBox(height: 12),
          if (_canAdd)
            FloatingActionButton(
              heroTag: 'add',
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.darkBlue,
              onPressed: _openSheet,
              child: const Icon(Icons.add),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/list_animation.json', height: 260),
          const SizedBox(height: 16),
          Text(
            'There is No Contacts Added Here',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 160, top: 8),
      itemCount: _contacts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, i) {
        final contact = _contacts[i];
        return ContactCard(
          contact: contact,
          onDelete: () => _deleteContact(contact),
        );
      },
    );
  }
}
class RouteLogo extends StatelessWidget {
  final double width;
  const RouteLogo({super.key, this.width = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/route_logo.png',
      width: width,
      fit: BoxFit.contain,

    );
  }
}

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onDelete;

  const ContactCard({super.key, required this.contact, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: AppColors.gold,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  contact.imagePath != null
                      ? Image.file(File(contact.imagePath!), fit: BoxFit.cover)
                      : Container(
                    color: AppColors.darkBlue,
                    child: const Icon(Icons.person,
                        size: 64, color: AppColors.gold),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        contact.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColors.darkBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _infoRow(Icons.email, contact.email),
                  const SizedBox(height: 6),
                  _infoRow(Icons.phone, contact.phone),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 14, color: AppColors.white),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.darkBlue),
          ),
        ),
      ],
    );
  }
}

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({super.key});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _imagePath = file.path);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Contact(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        imagePath: _imagePath,
      ),
    );
  }

  String _text(TextEditingController c, String fallback) =>
      c.text.trim().isEmpty ? fallback : c.text.trim();

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gold, width: 1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _imagePath == null
                          ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Lottie.asset(
                            'assets/animations/image_picker.json'),
                      )
                          : Image.file(File(_imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_text(_nameController, 'User Name'),
                            style: titleMedium),
                        const Divider(color: AppColors.gold, height: 16),
                        Text(_text(_emailController, 'example@email.com'),
                            style: titleMedium),
                        const Divider(color: AppColors.gold, height: 16),
                        Text(_text(_phoneController, '+200000000000'),
                            style: titleMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 16, color: AppColors.gold),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Enter User Name'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 16, color: AppColors.gold),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Enter User Email'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter an email';
                  final ok =
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                  return ok ? null : 'Please enter a valid email';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(fontSize: 16, color: AppColors.gold),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'Enter User Phone'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter a phone number';
                  final ok = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
                  return ok ? null : 'Please enter a valid phone number';
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Enter user'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}