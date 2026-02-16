import 'package:esme2526/datas/user_repository_interface.dart';
import 'package:esme2526/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileWidget extends StatefulWidget {
  final User user;

  const ProfileWidget({super.key, required this.user});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController _nameController;
  late TextEditingController _imgUrlController;
  late TextEditingController _tokensController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _imgUrlController = TextEditingController(text: widget.user.imgProfilUrl);
    _tokensController = TextEditingController(text: widget.user.wallet.tokens.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imgUrlController.dispose();
    _tokensController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text.trim(),
        imgProfilUrl: _imgUrlController.text.trim(),
        wallet: widget.user.wallet.copyWith(tokens: int.parse(_tokensController.text.trim())),
      );

      await UserRepositoryInterface.instance.saveUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Preview
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_imgUrlController.text),
                    radius: 50,
                    onBackgroundImageError: (_, __) {},
                    child: _imgUrlController.text.isEmpty ? const Icon(Icons.person, size: 50) : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Image URL Field
            TextFormField(
              controller: _imgUrlController,
              decoration: const InputDecoration(labelText: 'Profile Image URL', border: OutlineInputBorder(), prefixIcon: Icon(Icons.image)),
              onChanged: (value) {
                setState(() {}); // Update avatar preview
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Wallet Tokens Field
            TextFormField(
              controller: _tokensController,
              decoration: const InputDecoration(
                labelText: 'Wallet Tokens',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter token amount';
                }
                final tokens = int.tryParse(value.trim());
                if (tokens == null || tokens < 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _saveUser,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
