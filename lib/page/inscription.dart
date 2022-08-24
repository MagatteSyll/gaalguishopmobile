import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/apiservice.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:convert' as convert;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
   var httpIns=HttpInstance();
   late PhoneNumber phone;
   late String password;
   late String passwordcon;
   late String nom;
   late String prenom;
   bool visiblepassword=true;
   final formKey = GlobalKey<FormState>();
   bool loading=false;

   Future inscription(context)async{
    setState(() {
      loading=true;
    });
   var url=Uri.parse('http://192.168.0.50:8000/api/utilisateur/registration/',);
    var response= await httpIns.post(url,body: {'phone':"$phone",'password':password,
    "nom":nom,"prenom":prenom});
    if(response.statusCode==200){
     var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  Navigator.of(context).pushNamed('/confirmationphoneinscription',arguments: jsonResponse['user_id']);
 
    }
  else{
    setState(() {
    loading=false;
  });
    showTopSnackBar(
    context,
   const CustomSnackBar.error(
    message:"Erreur!Verifiez les données!",),
     //  persistent: true,
   );
 // print(response.statusCode);
   return;
  }
    }
  Widget buildPhone(){
       return Container(
        child: InternationalPhoneNumberInput(
        validator: (value){
          if(value==null||value.trim().isEmpty||value.length<9){
            return "Entrez un numero de telephone valide";
          }
          return null;},
         onInputChanged: (PhoneNumber value){
           phone=value;
          //  print(value);
         },
        selectorConfig:const  SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,  ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        formatInput: false,
        keyboardType: const  TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: const OutlineInputBorder(),
        countries:const  ["SN"],
        inputDecoration: const InputDecoration(
        hintText: 'Numero de telephone',
        // border: InputBorder.none,
         isDense: true
       ),
        ),
       );
       }
    
    Widget buildPassword(){
      return Container(
        margin:const EdgeInsets.only(left: 5),
        child: Row(children: [
         Flexible(
           child: Container(
          child: TextFormField(
          obscureText: visiblepassword,
          decoration:const  InputDecoration(labelText: 'Mot de passe',
         // border: OutlineInputBorder(
          //borderSide:BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
          ),
         validator: (value){
       if(value==null||value.trim().isEmpty){
          return "Entrez un mot de passe";
        }
        if(value.length<8){
         return "Il faut au moins 8 characteres pour le mot de passe ";
        }
        return null;},
       onChanged: (value){
         password=value;
        // print(value);
       },
       ),
       )),
      IconButton(
        icon: visiblepassword?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
        //color: Colors.white,
        onPressed: () {
          setState(() {
            visiblepassword=!visiblepassword;
          });
        },
          ), 
        ]),
      );
   }
  Widget buildPasswordcon(){
      return Container(
        margin:const EdgeInsets.only(left: 5),
        child: Row(children: [
         Flexible(
           child: Container(
          child: TextFormField(
          obscureText: true,
          decoration:const  InputDecoration(labelText: 'Confirmation du mot de passe',
         // border: OutlineInputBorder(
          //borderSide:BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
            ),
        validator: (value){
         if(value!=password){
         return "Les mots de passe ne matchent pas "; 
        }
        return null;
        }, 
       onChanged: (value){
         passwordcon=value;
        // print(value);
       },
       ),
       )),
        ]),
      );
   }
  Widget buildnom(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Nom',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un nom";
        }
        return null;},
       onChanged: (value){
         nom=value;
       //  print(value);
       },
       );
    }
  Widget buildprenom(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Prenom',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un prenom ";
        }
        return null;},
       onChanged: (value){
         prenom=value;
       //  print(value);
       },
       );
    }
  @override
  Widget build(BuildContext context) {
    return !loading? Scaffold(
     appBar: AppBar(
    automaticallyImplyLeading: false,
    backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
    leading: IconButton(
    icon:const  Icon(Icons.arrow_back,color: Colors.white,),
     onPressed: (){
         Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
     },),  ),
    body:SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20,left: 5,right: 5),
        child: Column(children: [
           ListTile(
           leading: Image.asset('assets/logo.jpg',
           width: 40,
           height: 40,),
           title: const Text("Bienvenu sur Gaalguishop"),
           trailing:const Icon(Icons.shopping_basket,color: Color.fromRGBO(200, 104, 28, 1),),
         ),
       const SizedBox(height: 10,),
       const Text('S inscrire',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
      const SizedBox(height: 10,),
      Form(
        key: formKey,
        child: Column(children: [
        buildprenom(),
        const SizedBox(height: 10,),
        buildnom(),
        const SizedBox(height: 15,),
        buildPhone(),
        const SizedBox(height: 15,),
        buildPassword(),
        const SizedBox(height: 15,),
        buildPasswordcon(),
        const SizedBox(height: 20,),
        SizedBox(
        width: double.infinity,
        child: ElevatedButton(
       style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.brown),),
      child: const  Text(
       'Inscription',  style: TextStyle(fontSize: 16), ),
       onPressed: () {
     if (formKey.currentState!.validate()) {
      inscription(context);
     } 
     }, 
     ), ),   
      ]),),
      const SizedBox(height: 10,),
      TextButton(onPressed: (){
        Navigator.of(context).pushNamed('/login');
      }, child:const Text("Se connecter",
      style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),))
        ]),
      )
      ),
    ):
  Container(
  decoration: const BoxDecoration(color: Colors.white),
  child: const  SpinKitCircle(
  color: Color.fromARGB(137, 18, 35, 92),
  size: 50.0,
duration: Duration(milliseconds: 1000),
)
    );
  }
}