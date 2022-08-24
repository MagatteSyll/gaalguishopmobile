// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class DetailCommande extends StatefulWidget {
 final dynamic id;
 const DetailCommande(this.id, {super.key});

  @override
  State<DetailCommande> createState() => _DetailCommandeState();
}

class _DetailCommandeState extends State<DetailCommande> {
    var httpIns=HttpInstance();
    late bool load;
    var commande;

  Future getcommande()async{
  var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getdetailcommande/',);
    var result=await  httpIns.post(url,body: {'id':id});
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
    commande=jsonResponse;
    });
   return ;
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
       appBar:AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(icon:const  Icon(Icons.arrow_back_ios,color: Colors.brown,),
        onPressed: (){
       Navigator.of(context).pop();
        },),
        title: Row(children: [
       Text("Commande numéro ${commande['id']} ",
       style:  const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
         ],), ),
      body: SingleChildScrollView(
        child: commande['produitcommande']['product']['variation']?
        Container(
          margin: const EdgeInsets.only(top: 20,left: 5,right: 5),
          child: Card(
            child: Column(children: [
             Image.network("https://gaalguishop.herokuapp.com${commande['produitcommande']['imageproduct']['image']}",
              width: 300,
              height: 250,), 
           const  Text("Detail de la commande",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
             Row(
            children: [
            const Text('Produit:'),
            const SizedBox(width: 10,),
            Text(commande['produitcommande']['product']['nom'],style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
             Row(
            children: [
            const Text('couleur:'),
            const SizedBox(width: 10,),
            Text(commande['produitcommande']['imageproduct']['color'],style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
          Row(
            children: [
              const Text('taille:'),
              const SizedBox(width: 10,),
              Text(commande['produitcommande']['imageproduct']['size'],style: const TextStyle(fontWeight: FontWeight.bold),)],
          ),
           const SizedBox(height: 10,),
          
           Row(
            children: [
              const Text('poids:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['product']['poids']} ${commande['produitcommande']['product']['unite_mesure_poids']} ",
              style: const TextStyle(color: Colors.black),)
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Quantité commandée:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['quantity']}",style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Prix unitaire:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['product']['prix']} ${commande['produitcommande']['product']['devise']['devise']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Sous total:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['subtotal']} ${commande['produitcommande']['product']['devise']['devise']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
        const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Frais de livraison:'),
             const  SizedBox(width: 10,),
              Text("${commande['livraison']} ${commande['produitcommande']['product']['devise']['devise']}",
              style:const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Total de la commande:'),
             const  SizedBox(width: 10,),
              Text("${commande['total']} ${commande['produitcommande']['product']['devise']['devise']}"
              ,style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
         const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Adresse de livraison:'),
             const  SizedBox(width: 10,),
              Text("${commande['adress']['region']['pays']['pays']},${commande['adress']['region']['region']},${commande['adress']['adress']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          const SizedBox(height: 10,),
           Row(
            children: [
              const Text('Etat  de la commande:'),
             const  SizedBox(width: 10,),
              Text("${commande['statut_commande']}",style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,), 
         Row(
            children: [
            const Text('Date de la commande:'),
            const  SizedBox(width: 10,),
              Text("$formatted,$heuresting",style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 

            ]),
          ),
        ):
     Container(
        margin: const EdgeInsets.only(top: 20,left: 5,right: 5),
      child: Card(
       child: Column(children: [
             Image.network("https://gaalguishop.herokuapp.com${commande['produitcommande']['product']['thumbnail']}",
              width: 300,
              height: 250,), 
           const  Text("Detail de la commande",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
             Row(
            children: [
            const Text('Produit:'),
            const SizedBox(width: 10,),
            Text(commande['produitcommande']['product']['nom'],
            style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
             Row(
            children: [
            const Text('couleur:'),
            const SizedBox(width: 10,),
            Text(commande['produitcommande']['product']['couleur'],
            style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
          Row(
            children: [
              const Text('taille:'),
              const SizedBox(width: 10,),
              Text(commande['produitcommande']['product']['taille'],
              style: const TextStyle(fontWeight: FontWeight.bold),)],
          ),
          const SizedBox(height: 10,),
           Row(
            children: [
              const Text('poids:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['product']['poids']} ${commande['produitcommande']['product']['unite_mesure_poids']} ",
              style: const TextStyle(color: Colors.black),)
            ],
          ),
        const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Quantité commandée:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['quantity']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Prix unitaire:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['product']['prix']} ${commande['produitcommande']['product']['devise']['devise']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Sous total:'),
             const  SizedBox(width: 10,),
              Text("${commande['produitcommande']['subtotal']} ${commande['produitcommande']['product']['devise']['devise']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
        const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Frais de livraison:'),
             const  SizedBox(width: 10,),
              Text("${commande['livraison']} ${commande['produitcommande']['product']['devise']['devise']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Total de la commande:'),
             const  SizedBox(width: 10,),
              Text("${commande['total']} ${commande['produitcommande']['product']['devise']['devise']}",
              style:const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
         const SizedBox(height: 10,),
          Row(
            children: [
              const Text('Adresse de livraison:'),
             const  SizedBox(width: 10,),
              Text("${commande['adress']['region']['pays']['pays']},${commande['adress']['region']['region']},${commande['adress']['adress']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          const SizedBox(height: 10,),
           Row(
            children: [
              const Text('Etat  de la commande:'),
             const  SizedBox(width: 10,),
              Text("${commande['statut_commande']}",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 
          const SizedBox(height: 10,), 
         Row(
            children: [
            const Text('Date de la commande:'),
            const  SizedBox(width: 10,),
              Text("$formatted,$heuresting",
              style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ), 

            ]),
          ),
        )
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