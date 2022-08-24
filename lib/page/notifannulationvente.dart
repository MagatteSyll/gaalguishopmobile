// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';



class NotificationAnnulationVente extends StatefulWidget {
 final dynamic id;
 const NotificationAnnulationVente(this.id, {super.key});

  @override
  State<NotificationAnnulationVente> createState() => _NotificationAnnulationVenteState();
}

class _NotificationAnnulationVenteState extends State<NotificationAnnulationVente> {
var httpIns=HttpInstance();
  late bool load;
  late String message;
  var commande;
  Future getnotification() async{
    var id=convert.jsonEncode(widget.id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getnotification/',);
    var response= await httpIns.post(url,body: {'id':id});
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  //  print(response.body);
 // print(jsonResponse['results'].length);
    setState(() {
     message=jsonResponse['message'];
     commande=jsonResponse['commande'];
  });
    return jsonResponse;
}
  }
@override
void initState() {
  getnotification();
  setState(() {
    load=true;
  });
super.initState();
}
  @override
  Widget build(BuildContext context) {
   if(load){
    return Scaffold(
      appBar:AppBar(
      elevation: 0,
      backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
      automaticallyImplyLeading: false,
      leading:IconButton(icon:const Icon(Icons.cancel_rounded,color:Colors.white),
      onPressed:(){
        Navigator.of(context).pop();
      })
      ),
    body:SingleChildScrollView(
     child:   Container(
        margin: const EdgeInsets.only(top: 50,left:3,right: 3),
   child: Column(children: [
          Text(message,style:const  TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          commande['produitcommande']['product']['variation']?
          Container(
            child: Card(
              child: Column(children: [
              Container(
              margin: const  EdgeInsets.only(top: 10,left: 10),
              child: Image.network("https://gaalguishop.herokuapp.com${commande['produitcommande']['imageproduct']['image']}",
              width: 300,
              height: 250, ), ), 
              TextButton(child: Text( commande['produitcommande']['product']['nom']),
              onPressed: (){},),
             const  Text("Details sur le produit  ",style: TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),),
             ListTile(title: Text("Couleur: ${commande['produitcommande']['imageproduct']['color']}")),
             ListTile(title: Text("Taille: ${commande['produitcommande']['imageproduct']['size']}")),
              ListTile(title: Text("Poids: ${commande['produitcommande']['product']['poids']} ${commande['produitcommande']['product']['unite_mesure_poids']} ")),
             ListTile(title: Text("Prix unitaire: ${commande['produitcommande']['product']['prix']} ${commande['produitcommande']['product']['devise']['devise']}")),
            const  Text("Details sur la commande ",style: TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),),
             ListTile(title: Text("Numéro de la commande : ${commande['id']}")),
             ListTile(title: Text("Quantité: ${commande['produitcommande']['quantity']}")),
             
              ]),
            ),
          ):
          Container(
            child: Card(
              child: Column(children: [
              Container(
              margin: const  EdgeInsets.only(top: 10,left: 10),
              child: Image.network("https://gaalguishop.herokuapp.com${commande['produitcommande']['product']['thumbnail']}",
              width: 300,
              height: 250, ), ), 
              TextButton(child: Text( commande['produitcommande']['product']['nom']),
              onPressed: (){},) ,
            const Text("Details sur le produit  ",style: TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),),
             ListTile(title: Text("Couleur: ${commande['produitcommande']['product']['couleur']}")),
             ListTile(title: Text("Taille: ${commande['produitcommande']['product']['taille']}")),
            ListTile(title: Text("Poids: ${commande['produitcommande']['product']['poids']} ${commande['produitcommande']['product']['unite_mesure_poids']} ")),
             ListTile(title: Text("Prix unitaire: ${commande['produitcommande']['product']['prix']} ${commande['produitcommande']['product']['devise']['devise']}")),
            const  Text("Details sur la commande",style: TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),),
            ListTile(title: Text("Numéro de la commande : ${commande['id']}")),
            ListTile(title: Text("Quantité : ${commande['produitcommande']['quantity']}")),
            
              ]),
            ),
          )

          
         ],)
        ),
     
    )
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