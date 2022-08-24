// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;


class Commander extends StatefulWidget {
  final dynamic id;
  const Commander(this.id, {super.key});

  @override
  State<Commander> createState() => _CommanderState();
}

class _CommanderState extends State<Commander> {
  var httpIns=HttpInstance();
  var cart;
  late bool load;
  var   nom;
  var phonejoignable;
  var phonegaalguimoney;
  var idlivraison;
  var fraislivraison;
  var total;
  bool calculivraison=false;
  bool loading=false;
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> adress=[] ;
  Future getcartproduct() async{
    var id=convert.jsonEncode(widget.id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/cartcommande/',);
    var result=await  httpIns.post(url,body:{'id':id});
    if(result.statusCode==200){
      //print(result.body);
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
  for(var i=0;i<jsonResponse['adress'].length;i++){
     adress.add(jsonResponse['adress'][i]);
      }
    cart=jsonResponse['cartproduit'];
    });
   return ;
 }
 else{
 print(result.statusCode);
  //return response;
 }
  }
Widget buildnomcomplet(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Votre nom complet ',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         nom=value;
       //  print(value);
       },
       );
    }
Widget buildnumerovalide(){
       return Container(
        child: InternationalPhoneNumberInput(
        validator: (value){
          if(value==null||value.trim().isEmpty){
            return "Entrez un numero de telephone valide";
          }
          return null;},
         onInputChanged: (PhoneNumber value){
           phonejoignable=value;
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
        hintText: 'Numero de telephone joignable',
        // border: InputBorder.none,
         isDense: true
       ),
        ),
       );
       }
Widget buildnumerogaalguilmoney(){
       return Container(
        child: InternationalPhoneNumberInput(
        validator: (value){
          if(value==null||value.trim().isEmpty){
            return "Entrez un numero de telephone valide";
          }
          return null;},
         onInputChanged: (PhoneNumber value){
           phonegaalguimoney=value;
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
        hintText: 'Compte  GaalguiMoney ',
        // border: InputBorder.none,
         isDense: true
       ),
        ),
       );
       }
buildadresslivraison(){
  return DropdownButtonFormField(
  
    decoration: const InputDecoration(labelText: "Adress de livraison ",),
    items:adress
          .map<DropdownMenuItem<String>>((ad) {
        return DropdownMenuItem<String>(
          value:ad['id'].toString(),
          child: Text(ad['adress']+""+"(${ad['region']['region']})"),
        );
      }).toList(),
    
   onChanged: (value){
     idlivraison=value;
     calculdelivraison();
      // print(value);
       }, 
   );
  }

Future calculdelivraison()async{
  var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/calculivraison/',); 
  var result=await  httpIns.post(url,body:{'adress_id':"$idlivraison",'cartproduit_id':id});
   if(result.statusCode==200){
      //print(result.body);
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
     fraislivraison=jsonResponse['livraison'];
     total=jsonResponse['total'];
     calculivraison=true;
    });
   return ;
 }
 else{
// print(result.statusCode);
  return ;
 }

}
Future commander(context)async{
setState(() {
  loading=true;
});
 var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguimoney.herokuapp.com/api/client/verificationpayement/',); 
  var result=await  http.post(url,body:{'phone':"$phonegaalguimoney",'total':"$total"});
   if(result.statusCode==200){
   // print(result.body);
    var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;
    var url2=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/commande/',); 
    var response=await  httpIns.post(url2,body:
    {'phone':"$phonejoignable",
    'total':"$total",
    'nom_client':"$nom",
    'adress_id':"$idlivraison",
    'livraison':"$fraislivraison",
    'cart_id':id,
    'phone_gaalguiMoney':"$phonegaalguimoney",
    'codeid':"${jsonResponse['id']}"
     });
  if(response.statusCode==200){
    // print(response.body);
    var jsonres= convert.jsonDecode(response.body) as Map<String, dynamic>;
    Navigator.of(context).pushNamed('/verificationphonepay',arguments: jsonres['id']);
  setState(() {
  loading=false;
});
  }
 else{
 //print(response.statusCode);
 setState(() {
  loading=false;
});
 showTopSnackBar(
  context,
  const CustomSnackBar.error(
  message:"Erreur!Impossible de commander .",),
     //  persistent: true,
   );
  return;
 }   
 }
 else{
 //print(result.statusCode);
 setState(() {
  loading=false;
});
   showTopSnackBar(
  context,
  const CustomSnackBar.error(
  message:"Erreur!Verifiez vos credntiels de payement.",),
     //  persistent: true,
        );
  return;
 } 
}
@override
  void initState() {
   getcartproduct();
   setState(() {
     load=true;
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   if(load) {
  return !loading? Scaffold(
   appBar: AppBar(
   automaticallyImplyLeading: false,
  backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
   leading: IconButton(
   icon:const  Icon(Icons.arrow_back_ios ,color: Colors.white,),
   onPressed: (){
        Navigator.of(context).pop();
      },),
   ),
  body:  SingleChildScrollView(child: 
  Column(children: [
    Container(
      child: Card(
        child: Column(children: [
        cart['product']['variation']?
        Card(
        child: Column(children:[
        Text(cart['product']['nom'],
        style: const TextStyle(fontWeight: FontWeight.bold),),
        Image.network(cart['imageproduct']['image'],
         width: 300, height: 250, ),
        const SizedBox(height: 10,),
         Container(child: Row(
         children: [
          const Text("Taille"),
          const  SizedBox(width: 5,),
         Text(cart['imageproduct']['size'],
          style: const TextStyle(fontWeight: FontWeight.bold),)
           ], )),
          const SizedBox(height: 10,),
          Container(child: Row(
          children: [
          const Text("Couleur"),
          const  SizedBox(width: 5,),
          Text(cart['imageproduct']['color'],
          style: const TextStyle(fontWeight: FontWeight.bold),) ], )),
          const SizedBox(height: 10,),
          Container(child: Row(
           children: [
          const Text("Quantité"),
          const  SizedBox(width: 5,),
          Text('${cart['quantity']}',
          style: const TextStyle(fontWeight: FontWeight.bold),) ], )),
          const SizedBox(height: 10,),
           Container(child: Row(
          children: [
            const Text("Prix unitaire "),
             const  SizedBox(width: 5,),
            Text('${cart['product']['prix']}',
            style: const TextStyle(fontWeight: FontWeight.bold),),
            const  SizedBox(width: 3,),
            Text(cart['product']['devise']['devise'],) ], )),
            const SizedBox(height: 10,),
            Container(child: Row(
            children: [
            const Text("Sous total "),
            const  SizedBox(width: 5,),
            Text('${cart['subtotal']}',
            style: const TextStyle(fontWeight: FontWeight.bold),),
            const  SizedBox(width: 3,),
            Text(cart['product']['devise']['devise'],) ], )),
            ]),):
         Card(
           child: Column(children: [
            Text(cart['product']['nom'],
            style: const TextStyle(fontWeight: FontWeight.bold),),
          Image.network(cart['product']['thumbnail'], width: 300, height: 250, ),
          const SizedBox(height: 10,),
          Container(child: Row(
          children: [
             const Text("Taille"),
             const  SizedBox(width: 5,),
              Text(cart['product']['taille'],
              style: const TextStyle(fontWeight: FontWeight.bold),) ],
               )),
               const SizedBox(height: 10,),
              Container(child: Row(
              children: [
              const Text("Couleur"),
              const  SizedBox(width: 5,),
              Text(cart['product']['couleur'],
              style: const TextStyle(fontWeight: FontWeight.bold),)
               ], )),
             const SizedBox(height: 10,),
              Container(child: Row(
               children: [
                const Text("Quantité ajoutée "),
               const  SizedBox(width: 5,),
              Text('${cart['quantity']}',
              style: const TextStyle(fontWeight: FontWeight.bold),),
                 ], )),
              const SizedBox(height: 10,),
                Container(child: Row(
                 children: [
                const Text("Prix unitaire "),
                const  SizedBox(width: 5,),
                Text('${cart['product']['prix']}',
               style: const TextStyle(fontWeight: FontWeight.bold),),
                const  SizedBox(width: 3,),
                Text(cart['product']['devise']['devise'],) ],
               )),
                const SizedBox(height: 10,),
                 Container(child: Row(
                 children: [
                const Text("Sous total "),
                const  SizedBox(width: 5,),
                Text('${cart['subtotal']}',
               style: const TextStyle(fontWeight: FontWeight.bold),),
               const  SizedBox(width: 3,),
              Text(cart['product']['devise']['devise'],) ],
               )),
             const SizedBox(width: 10,),
             ]),
         )
          ]),
      ),
    ),
    Container(
      margin:const EdgeInsets.only(top:15,left:5,right:5),
      child: Form(
      key: formKey,
      child: Column(children: [
      buildnomcomplet(),
      const SizedBox(height: 10,),
      buildnumerovalide(),
      const SizedBox(height: 10,),
      buildadresslivraison(),
      const SizedBox(height: 10,),
      calculivraison?
      Container(
        margin:const EdgeInsets.only(top: 15,bottom: 15),
        child: Column(children: [
          Text("Frais de livraison: $fraislivraison ${cart['product']['devise']['devise']}",
          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
          const SizedBox(height: 5,),
          Text("Total de la commande: $total ${cart['product']['devise']['devise']}",
          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
        ]),
      ):Container(),
      const SizedBox(height: 10,),
      Row(
        children: const [
          Text("Payement"),
          Icon(Icons.wallet,size: 30,color: Color.fromRGBO(200, 104, 28, 1),)
        ],
      ),
      const SizedBox(height: 5,),
      buildnumerogaalguilmoney(),
      const SizedBox(height: 15,),
      ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
        child: const  Text('Passer la commande',style: TextStyle(fontSize: 16),),onPressed: ()  {
       if (formKey.currentState!.validate()){
         // print("oy");
          commander(context);
       }
        ;
       }, )
      ],)),
    )
  ],)
  ),
    ):Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
    );
    }
  else{
    return Container();
  }
  }
}