import 'package:flutter/material.dart';

class EditprofilePage extends StatelessWidget {
   EditprofilePage({Key? key}) : super(key: key);

  static const routename = 'Edit Profile';
  final TextEditingController ageController=TextEditingController();

  final _formKeyUsername = GlobalKey<FormState>();
  final _formKeyAgePassword = GlobalKey<FormState>();
  final _formKeyAge = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$routename'),
        actions: <Widget>[
          IconButton(
          onPressed: ()async{
            if(_formKeyAge.currentState!.validate()){
              Navigator.pop(context);
            }//if
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your edits has been saved'),
              backgroundColor: Colors.grey,
            ),
            ); //ScaffoldMessenger
          },
          icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30,vertical:30),
        child: ListView(
          children: <Widget>[
            usernameTextField(),
            const SizedBox(height:20),
            passwordTextField(),
            const SizedBox(height:20),
            ageTextField(),
          ],
        ),
      ),
    );
  } //build




//widget -------------------------------------------------------------

Widget usernameTextField(){
  return Form(
    key: _formKeyUsername,
    child: TextFormField(
    validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null) {
      return 'Please enter an integer valid number';
    }
    return null;
  },
  controller: ageController,
  enabled: true,
    decoration:  InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(90.0)
      ),
      focusedBorder:  OutlineInputBorder(
          borderSide: const BorderSide(
              width: 1,
              color: Colors.lightGreen ),
          borderRadius: BorderRadius.circular(90.0),
              ),
      labelText: 'Username',
      labelStyle: const TextStyle(color:Colors.lightGreen),
      ),
    ),
  );
}

Widget passwordTextField(){
  return Form(
    key: _formKeyAgePassword,
    child: TextFormField(
    decoration:  InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(90.0)
      ),
      focusedBorder:  OutlineInputBorder(
          borderSide: const BorderSide(
              width: 1,
              color: Colors.lightGreen ),
          borderRadius: BorderRadius.circular(90.0),
              ),
      labelText: 'Password',
      labelStyle: const TextStyle(color:Colors.lightGreen),
      ),
    ),
  );
}
Widget ageTextField(){
return Form(
  key: _formKeyAge,
  child: TextFormField(
    validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null) {
      return 'Please enter an integer valid number';
    }
    return null;
  },
  controller: ageController,
  enabled: true,
  decoration:  InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(90.0)
      ),
      focusedBorder:  OutlineInputBorder(
          borderSide: const BorderSide(
              width: 1,
              color: Colors.lightGreen ),
          borderRadius: BorderRadius.circular(90.0),
              ),
      labelText: 'Age',
      labelStyle: const TextStyle(color:Colors.lightGreen),
      ),
  ),
);

}// ageTextField


}//EditprofilePage


