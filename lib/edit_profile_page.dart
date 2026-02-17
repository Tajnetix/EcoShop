import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: "Sarah Johnson");

  final TextEditingController _emailController =
      TextEditingController(text: "sarah.j@email.com");

  final TextEditingController _phoneController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCECCB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC8DAB5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                /// MAIN WHITE CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Change Photo
                      Row(
                        children: [
                          Stack(
                            children: [
                              const CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xFFE5EFE0),
                                child: Icon(Icons.person,
                                    size: 35,
                                    color: Color(0xFF1B5E20)),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Change photo clicked"),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF1B5E20),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Change Photo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// FULL NAME
                      const Text("Full Name"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// EMAIL LABEL + VERIFIED ABOVE FIELD
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Email"),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5EFE0),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 14,
                                    color: Color(0xFF1B5E20)),
                                SizedBox(width: 4),
                                Text(
                                  "Email Verified",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF1B5E20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null ||
                              !value.contains("@")) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// PHONE NUMBER
                      const Text("Phone Number"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _phoneController,
                        hint: "Enter phone number",
                      ),

                      const SizedBox(height: 25),

                      /// CHANGE PASSWORD
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Change Password Clicked")),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.lock,
                                color: Color(0xFF1B5E20)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text("Change password"),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF1B5E20),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!
                                .validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Changes Saved")),
                              );
                            }
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// DEACTIVATE ACCOUNT (ONLY ONCE)
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Deactivate Account Clicked")),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.delete,
                                color: Colors.grey),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Deactivate Account",
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.w500),
                              ),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
