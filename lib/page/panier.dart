// ignore_for_file: prefer_typing_uninitialized_variables

import "package:flutter/material.dart";
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';




class Panier extends StatefulWidget {
  const Panier({Key? key}) : super(key: key);

  @override
  State<Panier> createState() => _PanierState();
}


class _PanierState extends State<Panier> {
   var httpIns=HttpInstance();
   int page=1;
   var next;
   var previous;
   late bool load;
   bool allloaded=false;
   bool loaded=false;
   static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy');
  final String an = formatter.format(now);
   List<Map<String, dynamic>> items=[] ;
   ScrollController scrollController=ScrollController();
  
  Future getpanier() async{
    setState(() {
      load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getcart/?page=$page',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
  for(var i=0;i<jsonResponse['results'].length;i++){
     items.add(jsonResponse['results'][i]);
      }
    next=jsonResponse['next'];
     page++;
     previous=jsonResponse['previous'];
    load=false;
    });
   return ;
 }
 else{

  return ;
 }  
 }

@override
  void initState(){
  getpanier();
  setState(() {
    loaded=true;
  });
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getpanier();}
     else{
       setState(() {
         allloaded=true;
         load=false;
       });
     }
     }});
  super.initState();
}
 Future addplusvarie(slug,id,context) async{
  var pid=convert.jsonEncode(id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/addcart/',);
    var result=await  httpIns.post(url,body: {'slug':slug,'prodimg':pid});
    if(result.statusCode==200){
   Navigator.of(context).pushNamed('/panier');
     // print(result.body);
    }
      
  else{
   // print(result.statusCode);
     Navigator.of(context).pop();
  }
 }
Future addplusunique(slug,context) async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/addcart/',);
    var result=await  httpIns.post(url,body: {'slug':slug,});
    if(result.statusCode==200){
      getpanier();
   Navigator.of(context).pushNamed('/panier');
    }
      
  else{
   // print(result.statusCode);
     Navigator.of(context).pop();
  }
 }

Future minus(id,context) async{
  var pid=convert.jsonEncode(id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/cartmanage/mycart/remove/${pid}/',);
    var result=await  httpIns.put(url);
    if(result.statusCode==200){
     getpanier();
   Navigator.of(context).pushNamed('/panier');
    
    }
      
  else{
    //print(result.statusCode);
     Navigator.of(context).pop();
  }
 }
 Future remove(id,context) async{
  var pid=convert.jsonEncode(id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/cartmanage/mycart/removesingle/${pid}/',);
  var result=await  httpIns.put(url);
    if(result.statusCode==200){
    getpanier();
   Navigator.of(context).pushNamed('/panier');
    }    
  else{
   // print(result.statusCode);
    Navigator.of(context).pop();
  }
 }
Future<void> showdialogplusunique(slug) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
            // handleprofil(context);
          },
        child:Row(
          children:  [
           const Icon(Icons.add, color: Colors.green),
           const SizedBox(width: 10,),
           TextButton
           (child: const Text('Ajouter ',
           style: TextStyle(
             color: Colors.green
           ),),
           onPressed: (){
             addplusunique(slug, context);
           },),
          ],
        ) )
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
Future<void> showdialogplusvarie(slug,id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
            // handleprofil(context);
          },
        child:Row(
          children:[
          const Icon(Icons.add,
           color: Colors.green),
          const SizedBox(width: 10,),
          TextButton(
          child:const  Text('Ajouter',
          style: TextStyle(
            color: Colors.green
          ),),
          onPressed: (){
            addplusvarie(slug, id, context);
           },),
          ],
        ) )
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
Future<void> showdialogminus(id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
            // handleprofil(context);
          },
        child:Row(
          children:  [
          const  Icon(Icons.remove,
            color: Colors.blue),
          const SizedBox(width: 10,),
           TextButton(
            onPressed: (){
             minus(id, context) ;
            },
             child:const  Text('Retirer ',
             style: TextStyle(
               color: Colors.blue
             ),
             ),
           ),
          ],
        ) )
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
Future<void> showdialogremove(id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
            // handleprofil(context);
          },
        child:Row(
          children:  [
          const  Icon(Icons.delete,
           color: Colors.red),
          TextButton(
            onPressed: (){
              remove(id, context);
            },
            child: const Text('Supprimer ',style: TextStyle(
              color: Colors.red
             ),),
          ),
          ],
        ) )
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
  @override
  Widget build(BuildContext context) {
    if(loaded){
     return Scaffold(
      appBar: AppBar(
       backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
       automaticallyImplyLeading: false,
       title: const Text('Panier'),
       leading: IconButton(
        onPressed: (){
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
        },
       icon: const  Icon(Icons.arrow_back_ios),
       ),
      ),
      body: items.isNotEmpty?
        Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: items.length ,
              itemBuilder: ((context, index){
              var item=items[index];
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: item['product']['variation']?
                  Card(
                    child: Column(children: [
                      item['imageproduct']['active']?
                      Text("${item['imageproduct']['quantite']} disponible(s)",
                      style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):
                      const Text("Produit non disponible",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10,),
                       Container(
                       child: TextButton(
                       onPressed: (){
                      Navigator.of(context).pushNamed('/detail',arguments:item['product']['slug']);
                       },
                     child:Text(item['product']['nom'],
                     style: const TextStyle(fontWeight: FontWeight.bold),),
                     ) ,) ,
                       Image.network(item['imageproduct']['image'],
                         width: 300,
                         height: 250, ),
                         const SizedBox(height: 10,),
                         Container(child: Row(
                           children: [
                        const Text("Taille"),
                       const  SizedBox(width: 5,),
                       Text(item['imageproduct']['size'],
                       style: const TextStyle(fontWeight: FontWeight.bold),)
                           ],
                         )),
                       const SizedBox(height: 10,),
                         Container(child: Row(
                        children: [
                        const Text("Couleur"),
                       const  SizedBox(width: 5,),
                       Text(item['imageproduct']['color'],
                       style: const TextStyle(fontWeight: FontWeight.bold),)
                           ],
                         )),
                      const SizedBox(height: 10,),
                      Container(child: Row(
                           children: [
                        const Text("Quantité ajoutée "),
                       const  SizedBox(width: 5,),
                       Text('${item['quantity']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),)
                         ],
                         )),
                    const SizedBox(height: 10,),
                       Container(child: Row(
                           children: [
                        const Text("Prix unitaire "),
                       const  SizedBox(width: 5,),
                       Text('${item['product']['prix']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),),
                       const  SizedBox(width: 3,),
                       Text(item['product']['devise']['devise'],)
                         ],
                         )),
                      const SizedBox(height: 10,),
                       Container(child: Row(
                           children: [
                        const Text("Sous total "),
                       const  SizedBox(width: 5,),
                       Text('${item['subtotal']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),),
                       const  SizedBox(width: 3,),
                       Text(item['product']['devise']['devise'],)
                         ],
                         )),
                    Container(child: Row(
                           children: [
                        item['quantity']<item['product']['imageproduct']['quantite']?
                        IconButton(onPressed: (){
                          showdialogplusvarie(item['product']['slug'],item['imageproduct']['id']);
                         // addplusvarie(item['product']['slug'], item['imageproduct']['id'],context);
                        }, icon:const Icon(Icons.add,color: Colors.green,))
                      :Container(),
                       const  SizedBox(width: 5,),
                       IconButton(onPressed: (){
                        showdialogminus(item['id']);
                       // minus(item['id'],context);
                       }, icon:const  Icon(Icons.remove,color: Colors.blue)),
                       const  SizedBox(width: 5,),
                       IconButton(onPressed: (){
                        showdialogremove(item['id']);
                         // remove(item['id'],context);
                       }, icon:const  Icon(Icons.delete,color: Colors.red,)),
                           ],
                         )),
                      const SizedBox(width: 10,),
                      item['imageproduct']['active']?
                      ElevatedButton(onPressed:(){
                        Navigator.of(context).pushNamed('/commander',arguments: item['id']);
                      },
                      style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.brown),),
                      child:const  Text("Commander"),
                      ):
                      Container()     
                    ]),
                  ):
                  Card(
                    child: Column(children: [
                    item['product']['active']?
                      Text("${item['product']['qte']} disponible(s)",
                      style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):
                      const Text("Produit non disponible"),
                       Container(
                       child: TextButton(
                        onPressed: (){
                       Navigator.of(context).pushNamed('/detail',arguments:item['product']['slug']);
                       },
                      child:Text(item['product']['nom'],
                      style: const TextStyle(fontWeight: FontWeight.bold),),
                       ) ,) ,
                       Image.network(item['product']['thumbnail'],
                         width: 300,
                         height: 250, ),
                         const SizedBox(height: 10,),
                         Container(child: Row(
                           children: [
                        const Text("Taille"),
                       const  SizedBox(width: 5,),
                       Text(item['product']['taille'],
                       style: const TextStyle(fontWeight: FontWeight.bold),)
                           ],
                         )),
                       const SizedBox(height: 10,),
                         Container(child: Row(
                        children: [
                        const Text("Couleur"),
                       const  SizedBox(width: 5,),
                       Text(item['product']['couleur'],
                       style: const TextStyle(fontWeight: FontWeight.bold),)
                           ],
                         )),
                      const SizedBox(height: 10,),
                      Container(child: Row(
                           children: [
                        const Text("Quantité ajoutée "),
                       const  SizedBox(width: 5,),
                       Text('${item['quantity']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),),
                       ],
                         )),
                      const SizedBox(height: 10,),
                       Container(child: Row(
                           children: [
                        const Text("Prix unitaire "),
                       const  SizedBox(width: 5,),
                       Text('${item['product']['prix']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),),
                       const  SizedBox(width: 3,),
                       Text(item['product']['devise']['devise'],)
                         ],
                         )),
                      const SizedBox(height: 10,),
                       Container(child: Row(
                           children: [
                        const Text("Sous total "),
                       const  SizedBox(width: 5,),
                       Text('${item['subtotal']}',
                       style: const TextStyle(fontWeight: FontWeight.bold),),
                       const  SizedBox(width: 3,),
                       Text(item['product']['devise']['devise'],)
                         ],
                         )),
                      Container(child: Row(
                           children: [
                          item['quantity']<item['product']['qte']?
                        IconButton(onPressed: (){
                         showdialogplusunique(item['product']['slug']);
                         // addplusunique(item['product']['slug'],context);
                        }, icon:const Icon(Icons.add,color: Colors.green,)):
                        Container(),
                       const  SizedBox(width: 5,),
                       IconButton(onPressed: (){
                        showdialogminus(item['id']);
                        //minus(item['id'],context);
                       }, icon:const  Icon(Icons.remove,color: Colors.blue)),
                       const  SizedBox(width: 5,),
                       IconButton(onPressed: (){
                        showdialogremove(item['id']);
                        //  remove(item['id'],context);
                       }, icon:const  Icon(Icons.delete,color: Colors.red,)),
                           ],
                         )),
                      const SizedBox(width: 10,),
                      item['product']['active']?
                      ElevatedButton(onPressed:(){
                        Navigator.of(context).pushNamed('/commander',arguments: item['id']);
                      },
                      style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.brown),),
                      child:const  Text("Commander"),
                      ):
                      Container()
                       
                    ]),
                  )
                );
             })),
       if(load)...const [
                 Positioned(
                left:130,
                bottom: 0,
                child: Center(
                child:  Loadinganimate(),
              ))
              ]
          ],
        ):
      Container(
        child: Center(child: 
        Row(children: [
          const Text(" Oups votre panier est vide ,commencez vos"),
          TextButton(onPressed: (){}, child: const Text('Shoppings',style: TextStyle(
            color: Color.fromRGBO(200, 104, 28,1)
          ),))
        ],)),
      )
     );
    }
  else{
   return const  Loadinganimate();
  }
      
  }
}

class Loadinganimate extends StatelessWidget {
  const Loadinganimate({super.key});

  @override
  Widget build(BuildContext context) {
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
