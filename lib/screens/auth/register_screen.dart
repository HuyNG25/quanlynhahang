import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final List<String> preferences = [];
  final List<String> allPreferences = ['vegetarian', 'spicy', 'seafood'];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: fullNameCtrl,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: allPreferences.map((p) {
                final selected = preferences.contains(p);
                return FilterChip(
                  label: Text(p),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        preferences.add(p);
                      } else {
                        preferences.remove(p);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child:
                  isLoading ? const CircularProgressIndicator() : const Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    final email = emailCtrl.text.trim();
    final fullName = fullNameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    final address = addressCtrl.text.trim();

    if (email.isEmpty ||
        fullName.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await context.read<AuthProvider>().register(
            email: email,
            fullName: fullName,
            phoneNumber: phone,
            address: address,
            preferences: preferences,
          );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
