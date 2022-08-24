// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../utils/apiservice.dart';
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class RecuCommande extends StatefulWidget {
  final dynamic id;
  const RecuCommande(this.id, {super.key});

  @override
  State<RecuCommande> createState() => _RecuCommandeState();
}

class _RecuCommandeState extends State<RecuCommande> {
  var httpIns=HttpInstance();
  late bool load;
  var commande;

Future getcommande()async{
  var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getcommande/',); 
  var result=await  httpIns.post(url,body:{'id':id});
   if(result.statusCode==200){
   // print(result.body);
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
    commande=jsonResponse;
    });
   return ;
 }
 else{
  return;
// print(result.statusCode);
  //return response;
 }
}
@override
  void initState() {
    getcommande();
    setState(() {
      load=true;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   if(load) {
  String date=commande['created_at'];
    final  formattedDate =DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final heure=DateFormat('HH:mm');
    final String formatted = formatter.format(formattedDate);
     String heuresting=heure.format(formattedDate);
  return Scaffold(
     appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
      leading: IconButton(
      icon:const  Icon(Icons.arrow_back_ios ,color: Colors.white,),
      onPressed: (){
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
      },),
     ),
     body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 15,left: 5,right: 5),
        child: Column(children: [
         ListTile(
           leading: Image.asset('assets/logo.jpg',
           width: 60,
           height: 40,),
         ),
          Row(
          children: const  [
          Icon(Icons.location_on),
         SizedBox(width: 5,),
          Text("Dakar,rue adress"),
           ], ),
        Row(
          children:const  [
            Icon(Icons.phone),
             SizedBox(width: 10,),
            
            Text("+772058140")
          ],),
         Row(
          children:const  [
            Icon(Icons.mail),
            SizedBox(width: 10,),
            Text("www.gaalguishop.mail")
          ],),
        const SizedBox(height: 5,),
      const  ListTile(
          leading: Icon(Icons.done_all,color: Colors.green,size: 30,),
          title: Text("commande effectuée"),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
         child: Column(children: [
           Row(
            children: [
              const Text('Nom du client '),
               const SizedBox(width: 5,),
              Text(commande['nom_client'],style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
         const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Numero de la commande '),
               const SizedBox(width: 5,),
              Text("${commande['id']}",style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
          const SizedBox(height: 10,),
           Row(
            children: [
              const Text('Date de la commande '),
              // ignore: prefer_interpolation_to_compose_strings
              Text(formatted+","+heuresting,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
            const SizedBox(height: 10,),
           Row(
            children: [
              const Text('Produit acheté'),
             const SizedBox(width: 5,),
              Text(commande['produitcommande']['product']['nom'],style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
           const SizedBox(height: 10,),
            Row(
            children: [
              const Text('Prix unitaire'),
              // ignore: prefer_adjacent_string_concatenation
              const SizedBox(width: 5,),
              Text("${commande['produitcommande']['product']['prix']}"" "+"${commande['produitcommande']['product']['devise']['devise']}"
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
           const SizedBox(height: 10,),
            Row(
            children: [
              const Text('Quantité achetée '),
               const SizedBox(width: 5,),
              Text("${commande['produitcommande']['quantity']}"
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
            const SizedBox(height: 10,),
            Row(
            children: [
              const Text('Sous total'),
              // ignore: prefer_adjacent_string_concatenation
              const SizedBox(width: 5,),
              Text("${commande['produitcommande']['subtotal']} ${commande['produitcommande']['product']['devise']['devise']}"
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
            const SizedBox(height: 10,),
            Row(
            children: [
              const Text('Adresse de livraison'),
              const SizedBox(width: 5,),
              Text("${commande['adress']['region']['pays']['pays']},${commande['adress']['region']['region']},${commande['adress']['adress']}"
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Frais de livraison'),
               const SizedBox(width: 5,),
              // ignore: prefer_adjacent_string_concatenation
              Text("${commande['livraison']}"+" "+commande['produitcommande']['product']['devise']['devise']
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Total de la commande'),
               const SizedBox(width: 5,),
              // ignore: prefer_adjacent_string_concatenation
              Text("${commande['total']}"+" "+commande['produitcommande']['product']['devise']['devise']
              ,style:const 
               TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
            ],),
        
          
         ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25,left: 45),
          child: const Card(
            child: Text('Signature'),
          ),
        )
        
        ]),
      ),
     ),
    );
   }
else{
  return Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
    );
}
  }
}