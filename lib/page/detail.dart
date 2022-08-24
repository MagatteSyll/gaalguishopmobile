// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gaalguishop/page/souscomponent/myappbar.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:flutter/services.dart";
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';



class Detail extends StatefulWidget {
  final dynamic slug;
  const Detail(this.slug, {super.key});

  @override
  State<Detail> createState() => _DetailState();
}


class _DetailState extends State<Detail> {
   var httpIns=HttpInstance();
   late String nom;
   late var prix;
    bool variation=false;
   late String description;
   var couleur;
   var taille;
   var qte;
   var poids;
   var mesure;
   bool loaded=false;
  List<Map<String, dynamic>> produitimage=[] ;
  static const platform =  MethodChannel("gaalguishop.native.com/auth");
  late  String image;
  late var size;
  late var color;
  late  var quantite;
  late bool active;
  late var nbrevendu;
  late bool vendu;
  late bool islog;
  late var userid;
  late var vendeurid;
  late var prodimgid;

 
deconnexion() async{
  await platform.invokeMethod("deconnexion");
} 
Future getislog() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/isauthenticated/',);
  var result=await  httpIns.get(url);
 if(result.statusCode!=200){
    deconnexion();
   return false ;
 }
 else{
 var response=convert.jsonDecode(result.body);
  return response;
 }
}
Future getuser() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getuser/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
    var response=convert.jsonDecode(result.body);
    //print(result.body);
   return response ;
 }
 else{
// print('no user ');
 }
}
  
Future getproduit()async{
   var slug=widget.slug;
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getproduitdetail/',);
    var response= await httpIns.post(url,body: {"slug":slug});
    if(response.statusCode==200){
    //  print(response.body);
      var value = convert.jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {   
    for(var i=0;i<value['produitimage'].length;i++){
     produitimage.add(value['produitimage'][i]);
     }
     nom=value['produit']['nom'];
     variation=value['produit']['variation'];
     prix=value['produit']['prix'];
     description=value['produit']['description'];
     variation=value['produit']['variation'];
     vendeurid=value['produit']['vendeur']['id'];
     poids=value['produit']['poids'];
     mesure=value['produit']['unite_mesure_poids'];
    if(value['produit']['variation']==false){
      couleur=nom=value['produit']['couleur'];
      taille=value['produit']['taille'];
      qte=value['produit']['qte'];
     }
    loaded=true;
      });
      return value;
     }
    else{
      print(slug);
    }}

@override
void initState(){
   getislog().then((res) => {
    setState(()=>{
    islog=res
    })
    });
  getuser().then((value) => 
  setState(()=>{
    userid=value['id']
  }),);
  getproduit()
  .then((value) => {
     setState(() {
       image=produitimage[0]['image']; 
        size=produitimage[0]['size'];
        color=produitimage[0]['color'];
        quantite=produitimage[0]['quantite'];
        active=produitimage[0]['active'];
        nbrevendu=produitimage[0]['qte_vendu'];
        prodimgid=produitimage[0]['id'];
       })
    
  },);
  setState(() {
    loaded=true;
  });
  
  super.initState();
}
 void handledisplay(index){
 // print(index);
   setState(() {
    image=produitimage[index]['image'];
    size=produitimage[index]['size'];
    color=produitimage[index]['color'];
    quantite=produitimage[index]['quantite'];
    vendu=produitimage[index]['vendu'];
    active=produitimage[index]['active'];
    nbrevendu=produitimage[index]['qte_vendu']; 
    prodimgid=produitimage[index]['id'];
   });  }

  Future addcartunique(context) async{
    var slug=widget.slug;
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/addcart/',);
    var response= await httpIns.post(url,body: {"slug":slug});
    if(response.statusCode==200){
       showTopSnackBar(
    context,
   const  CustomSnackBar.success(
    message:"Produit bien  ajouté au panier ",),
     //  persistent: true,
   );
   return;
    }
  else{
    showTopSnackBar(
    context,
   const  CustomSnackBar.success(
    message:"Oups!Erreur",),
     //  persistent: true,
   );
   return;
  }
 }
 Future addcartvarie(context) async{
  var slug=widget.slug;
  var id=convert.jsonEncode(prodimgid);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/addcart/',);
    var response= await httpIns.post(url,body: {"slug":slug,"prodimg":id});
    if(response.statusCode==200){
       showTopSnackBar(
    context,
   const  CustomSnackBar.success(
    message:"Produit bien  ajouté au panier ",),
     //  persistent: true,
   );
     // print(response.body);
    }
  else{
  showTopSnackBar(
    context,
   const  CustomSnackBar.success(
    message:"Oups!Erreur",),
     //  persistent: true,
   );
  }
 }
  @override
  Widget build(BuildContext context) {
    if(loaded) {   
    return Scaffold(
      appBar: PreferredSize(
       preferredSize: const Size.fromHeight(50),
       child:myappbarpage(context),
      ),
      body:SingleChildScrollView(
         child: Column(
          mainAxisSize: MainAxisSize.max, 
          children: [
            Container(
            margin: const  EdgeInsets.only(top: 30,left: 10),
            child: Card(
              child: Image.network("https://gaalguishop.herokuapp.com${image}",
              width: 300,
              height: 250, ),
            ),  ),
            const   Divider(),
             Text(nom,style: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
            Container(
              height: 150,
              width:MediaQuery.of(context).size.width * 1,
                child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: produitimage.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  
              return Container(
                margin: const EdgeInsets.only(left: 5,right: 5),
                child: GestureDetector(onTap: (){
                handledisplay(index);
                  },
            child: CircleAvatar(
            radius: 35,
            backgroundImage:NetworkImage("https://gaalguishop.herokuapp.com${produitimage[index]['image']}",
            ),),
          ),
              ); },    
             ),), 
          const Divider(),
          variation?
          Container(
          margin: const EdgeInsets.only(left: 15) ,
          child: Column(
          children: [
           Row(
            children: [
            const Text('couleur:'),
            const SizedBox(width: 10,),
            Text(color,style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
          Row(
            children: [
              const Text('taille:'),
              const SizedBox(width: 10,),
              Text(size,style: const TextStyle(color: Colors.brown),)],
          ),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('quantite:'),
             const  SizedBox(width: 10,),
              Text("$quantite",style: const TextStyle(color: Colors.redAccent),)
            ],
          ),
         const SizedBox(height: 10,),
           Row(
            children: [
              const Text('poids:'),
             const  SizedBox(width: 10,),
              Text("$poids $mesure",style: const TextStyle(color: Colors.black),)
            ],
          ),
          const  Divider(),
       Container(
       // margin: const EdgeInsets.only(left:3),
        child: Column(
          children: [
           const   Text("description",style: TextStyle(fontWeight: FontWeight.bold),),
            ListTile(title: Text(description)),
            islog?
            Container(
              child:
              userid==vendeurid?
              IconButton(onPressed: (){
               return;
              }, icon: const 
               Icon(Icons.star,color: Color.fromRGBO(200, 104, 28, 1),size: 30,)):
              IconButton(onPressed: (){
                addcartvarie(context);
              }, icon:const  Icon(Icons.add_shopping_cart,color: Color.fromRGBO(200, 104, 28, 1),
              size: 30,))
             
             )
            :IconButton(onPressed: (){
              Navigator.of(context).pushNamed('/login');
            }, icon:const  Icon(Icons.add_shopping_cart,color: Color.fromRGBO(200, 104, 28, 1),
            size: 30,))
          ],
        ),
       ),
           ], ),  
          ):
          Container(
          margin: const EdgeInsets.only(left: 15) ,
           child: Column(
           children: [
          Row(
            children: [
            const Text('couleur:'),
            const SizedBox(width: 10,),
            Text(couleur,style: const TextStyle(fontWeight: FontWeight.bold),)
            ], ),
             const SizedBox(height: 10,),
          Row(
            children: [
              const Text('taille:'),
              const SizedBox(width: 10,),
              Text(taille,style: const TextStyle(color: Colors.red),)],
          ),
           const SizedBox(height: 10,),
          Row(
            children: [
              const Text('quantite:'),
             const  SizedBox(width: 10,),
              Text("$qte",style: const TextStyle(color: Colors.blue),)
            ],
          ), 
        const SizedBox(height: 10,),
           Row(
            children: [
              const Text('poids:'),
             const  SizedBox(width: 10,),
              Text("$poids $mesure",style: const TextStyle(color: Colors.black),)
            ],
          ),
        const  Divider(),
       Container(
       // margin: const EdgeInsets.only(left:3),
        child: Column(
          children: [
           const   Text("description",style: TextStyle(fontWeight: FontWeight.bold),),
            ListTile(title: Text(description)),
            islog?
            Container(
              child:
              userid==vendeurid?
              IconButton(onPressed: (){
               return;
              }, icon: const 
               Icon(Icons.star,color: Color.fromRGBO(200, 104, 28, 1),size: 30,)):
              IconButton(onPressed: (){
                addcartunique(context);
              }, icon:const  Icon(Icons.add_shopping_cart,color: Color.fromRGBO(200, 104, 28, 1),
              size: 30,))
             
             )
            :IconButton(onPressed: (){
              Navigator.of(context).pushNamed('/login');
            }, icon:const  Icon(Icons.add_shopping_cart,color: Color.fromRGBO(200, 104, 28, 1),
            size: 30,))
          ],
        ),
       ),
        ],), 
          ),
       
        ],), ),
       );}
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


