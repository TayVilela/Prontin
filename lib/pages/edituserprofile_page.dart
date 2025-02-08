import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontin/services/users_services.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController birthdayController;
  late TextEditingController genderController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UsersServices>(context, listen: false).users;
    nameController = TextEditingController(text: user?.name ?? "");
    usernameController = TextEditingController(text: user?.userName ?? "");
    emailController = TextEditingController(text: user?.email ?? "");
    birthdayController = TextEditingController(text: user?.birthday ?? "");
    genderController = TextEditingController(text: user?.gender ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final usersServices = Provider.of<UsersServices>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);
                      await usersServices.updateUserProfile(
                        nameController.text,
                        usernameController.text,
                        emailController.text,
                        birthdayController.text,
                        genderController.text,
                      );
                      setState(() => isLoading = false);
                      Navigator.pop(context);
                    }
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Nome'),
              const SizedBox(height: 10),
              _buildTextField(usernameController, 'Usuário'),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'E-mail'),
              const SizedBox(height: 10),
              _buildTextField(birthdayController, 'Data de Nascimento'),
              const SizedBox(height: 10),
              _buildTextField(genderController, 'Gênero'),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          await usersServices.updateUserProfile(
                            nameController.text,
                            usernameController.text,
                            emailController.text,
                            birthdayController.text,
                            genderController.text,
                          );
                          setState(() => isLoading = false);
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Salvar Alterações", style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/changePassword');
                },
                child: const Text("Mudar Senha", style: TextStyle(color: Colors.white)),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Excluir Conta"),
                        content: const Text(
                            "Tem certeza que deseja excluir sua conta? Todos os seus dados serão apagados permanentemente."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await usersServices.deleteUserAccount();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text("Excluir"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Excluir Conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
