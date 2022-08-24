import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../utils/apiservice.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';





class Compte extends StatefulWidget {
  const Compte({super.key});

  @override
  State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  static const platform =  MethodChannel("gaalguishop.native.com/auth");
  late PhoneNumber phone;
  final formKey = GlobalKey<FormState>();
  var httpIns=HttpInstance();

 Future  deconnexion(context) async{
    await platform.invokeMethod("deconnexion");
   //print(decon);
 Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route route) => false);
}
Future<void> showdialogvente() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding:const  EdgeInsets.all(5),
        content: const  SingleChildScrollView(
          child: Text("Gaalguishop vous offre la possibilité de vente"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Future<void> showdialogachat() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding:const  EdgeInsets.all(5),
        content: const  SingleChildScrollView(
          child: Text("Gaalguishop vous offre la possibilité d achat"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Widget buildPhone(){
       return Container(
        child: InternationalPhoneNumberInput(
        validator: (value){
          if(value==null||value.trim().isEmpty){
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

Future linkmoney(context)async{
  var url=Uri.parse('https://gaalguimoney.herokuapp.com/api/client/verificationphonepourgaalguishop/',); 
  var result=await  http.post(url,body:{'phone':"$phone"});
  if(result.statusCode==200){
  var url2=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/liersoncomptegaalguimoney/',); 
    var response=await  httpIns.post(url2,body:{'phone':"$phone"});
    if(response.statusCode==200){
    Navigator.of(context).pop();
    showTopSnackBar(
  context,
   const CustomSnackBar.success(
    message:"Données bien éditées",),
     //  persistent: true,
   );
    }
  else{
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Oups!Une erreur est survenue,veuillez réessayer ultérieument",),
     //  persistent: true,
   );
  }
  }
  else{
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Erreur! Veuillez verifier les données entrées!",),
     //  persistent: true,
   );
  }
  
 }
Future<void> showdialogdatamoney() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
       insetPadding:const  EdgeInsets.all(5),
        content: SingleChildScrollView(
          child: Column(children: [
         const  Text("Données lieés au compte GaalguiMoney",style: TextStyle(
          fontSize: 14,fontWeight: FontWeight.bold
         ),),
         const SizedBox(height: 15,),
         Form(
          key: formKey,
          child: Column(
          children: [
           buildPhone(),
           const SizedBox(height: 10,),
           ElevatedButton(
           style: ButtonStyle(
           backgroundColor: MaterialStateProperty.all(Colors.brown),),
           child: const  Text(
           'Valider',
            style: TextStyle(fontSize: 16),),
            onPressed: () {
           if (formKey.currentState!.validate())
            {
             linkmoney(context);
             }  
      }, ),
          ],
         ))
        ]),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Future<void> showdialogdeconnection() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content:  const SingleChildScrollView(
          child: Text('Etes vous sur de vouloir vous déconnecter?'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Déconnection',style: TextStyle(
              color: Colors.red
            ),),
            onPressed: () {
             deconnexion(context);
            },
          ),
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
        leading: IconButton(
        icon:const  Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){
         Navigator.of(context).pop();
          },),
       
        ),
      body: Container(
        margin: const EdgeInsets.only(top: 30,left: 5),
        child: Column(children: [
         ListTile(
          title:GestureDetector(
          onTap: (){
            showdialogvente();
          },
           child:
              Row(
              children: const [
             Icon(Icons.wallet ,size: 24,color: Colors.blueGrey,),
             SizedBox(width: 10,),
             Text("Possibilités  de vente",
             style: TextStyle(
              fontSize:16,fontWeight: FontWeight.bold
             ),
                   ),
                 ],
               ),
          )
         ),
         const SizedBox(height: 15,),
         ListTile(
           title:GestureDetector(
          onTap: (){
            showdialogachat();
          },
           child:
              Row(
              children: const [
            Icon(Icons.shopping_basket
           ,size: 24,color: Color.fromRGBO(200, 104, 28, 1),),
             SizedBox(width: 10,),
             Text("Possibilités d achat",
             style: TextStyle(
              fontSize:16,fontWeight: FontWeight.bold
             ),
                   ),
                 ],
               ),
          )
         ),
         const SizedBox(height: 15,),
          ListTile(
          title:GestureDetector(
          onTap: (){
            showdialogdatamoney();
          },
           child:
              Row(
              children: const [
           Icon(Icons.money ,size: 24,color: Colors.brown,), 
             SizedBox(width: 10,),
             Text("Lier un  compte GaalguiMoney",
             style: TextStyle(
              fontSize:16,fontWeight: FontWeight.bold
             ),
                   ),
                 ],
               ),
          )
         ),
         const SizedBox(height: 15,),
          ListTile(
           title:GestureDetector(
          onTap: (){
            showdialogdeconnection();
          },
           child:
              Row(
              children: const [
            Icon(Icons.person_off ,size: 24,color: Color.fromRGBO(200, 104, 28, 1),), 
             SizedBox(width: 10,),
             Text("Se déconnecter",
             style: TextStyle(
              fontSize:16,fontWeight: FontWeight.bold
             ),
               ),
                 ],
               ),)
         ),
         const SizedBox(height: 15,),
        
        ]),
      ),
    );
    
  }
}