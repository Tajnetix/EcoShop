import 'package:eco_friendly_store/update_password.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'full_name': 'User',
        });

        data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
      }

      nameController.text = data['full_name'] ?? "";

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client
        .from('profiles')
        .update({'full_name': nameController.text})
        .eq('id', user.id);

    setState(() {
      profile!['full_name'] = nameController.text;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });

      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null || imageFile == null) return;

    final path = "${user.id}.png";

    await Supabase.instance.client.storage
        .from('avatars')
        .upload(path, imageFile!, fileOptions: const FileOptions(upsert: true));

    final imageUrl = Supabase.instance.client.storage
        .from('avatars')
        .getPublicUrl(path);

    await Supabase.instance.client
        .from('profiles')
        .update({'avatar_url': imageUrl})
        .eq('id', user.id);

    setState(() {
      profile!['avatar_url'] = imageUrl;
    });
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view your profile")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profile?['avatar_url'] != null
                      ? NetworkImage(profile!['avatar_url'])
                      : null,
                  child: profile?['avatar_url'] == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              profile?['full_name'] ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(profile?['email'] ?? "", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 30),

            const Text("Edit Name"),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: updateName,
              child: const Text("Save Name"),
            ),

            const SizedBox(height: 15),

            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdatePasswordPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: logout,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),

                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}