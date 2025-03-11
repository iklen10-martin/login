import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'db.dart';
import 'registro.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final password = TextEditingController();

  bool passwordVisible = false;
  Icon passwordIcon = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RacingLinesBehaviour(
          direction: LineDirection.Rtl,
          numLines: 20,
        ),
        vsync: this,
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("INICIAR SESIÓN",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontSize: 24,
                                  color: Colors.blueAccent,
                                  fontFamily: 'AltoneTrial'))
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideX(),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nombre,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Favor de ingresar el usuario";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'ComfortaaLight'),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Colors.blueAccent),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        style: TextStyle(fontSize: 14),
                      ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: passwordVisible ? false : true,
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Favor de ingresar la contraseña";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'ComfortaaLight'),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(Icons.password_outlined,
                              color: Colors.blueAccent),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                  if (passwordVisible) {
                                    passwordIcon = Icon(Icons.visibility,
                                        color: Colors.blueAccent);
                                  } else {
                                    passwordIcon = Icon(Icons.visibility_off,
                                        color: Colors.blueAccent);
                                  }
                                });
                              },
                              icon: passwordIcon),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        style: TextStyle(fontSize: 14),
                      ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String correo = nombre.text;
                            String contrasena = password.text;

                            Map<String, dynamic>? usuario =
                                await DatabaseHelper()
                                    .obtenerUsuarioPorCorreo(correo);

                            if (usuario != null) {
                              if (usuario[DatabaseHelper().columnaContrasena] ==
                                  contrasena) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Inicio de sesión exitoso")),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PantallaPrincipal()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Contraseña incorrecta")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Usuario no encontrado")),
                              );
                            }
                          }
                        },
                        child: Text(
                          "Iniciar",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'ComfortaaLight',
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 50)),
                      ).animate().fadeIn(duration: 500.ms).scale(),
                      SizedBox(height: 20),
                      TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => registro()));
                              },
                              child: Text(
                                "Registrarse",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'ComfortaaLight',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent),
                              ))
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.1),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
