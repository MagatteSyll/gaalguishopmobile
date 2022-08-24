// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/trunfunction.dart';

class BoutiqueVuClient extends StatefulWidget {
  final dynamic id;
 const BoutiqueVuClient(this.id, {super.key});

  @override
  State<BoutiqueVuClient> createState() => _BoutiqueVuClientState();
}

class _BoutiqueVuClientState extends State<BoutiqueVuClient> {
 var httpIns=HttpInstance();
   ScrollController scrollController=ScrollController();
  List<Map<String, dynamic>> items=[] ;
int page=1;
 var next;
 var previous;
 late bool load;
  late String nom;
  late String prenom;
  late String description;
  late String logo;
  late var note;
  late var nbrefollower;
  late String nomboutique;
  bool allloaded=false;
  bool loaded=false;
  late  bool isabonned;
  late bool islog;
  List<Map<String, dynamic>> produit=[] ;
  Future getboutique() async{
    var id=convert.jsonEncode(widget.id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/profilboutiquevuclient/',);
    var response= await httpIns.post(url,body: {"id":id});
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   // print(response.body);
    setState(() {
       nom=jsonResponse['boutique']['user']['nom'];
       prenom=jsonResponse['boutique']['user']['prenom'];
       description=jsonResponse['boutique']['description'];
       note=jsonResponse['boutique']['note_vendeur'];
       nbrefollower =jsonResponse['boutique']['nbrefollower'];
       logo =jsonResponse['boutique']['logo'];
       isabonned=jsonResponse['isabonned'];
       islog=jsonResponse['islog'];
      }); 
    return jsonResponse;
     
    }
  else{
   return;
  }
 }

 Future getproduit() async{
    setState(() {
      load=true;
    });
    var id=convert.jsonEncode(widget.id);
  //  print(id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitduneboutique/${id}/',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
//  print(result.body); 
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
  return;
//  print(result.statusCode) ;
 }  
 }
  Future getotherproduit() async{
    setState(() {
      load=true;
    });
    var id=convert.jsonEncode(widget.id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitduneboutique/${id}/?page=${page}',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
  //print(result.body); 
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
   getboutique();
   getproduit();
   setState((){
   loaded=true;
  });
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getotherproduit();}
     else{
       setState(() {
         allloaded=true;
         load=false;
       });
     }
     }});
super.initState();
}

Future addfollow(context) async{
   var pk=convert.jsonEncode(widget.id);
   var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/addfollower/',);
   var result=await  httpIns.post(url,body: {'id_boutique':pk});
    if(result.statusCode==200){
   // print(result.body); 
    getboutique();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();  
 }
 else{
  // print(result.statusCode); 
  Navigator.of(context).pop(); 
 }  
}
Future removefollow(context) async{
  var pk=convert.jsonEncode(widget.id);
   var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/follower/removefollower/${pk}/',);
   var result=await  httpIns.delete(url);
    if(result.statusCode==200){
   // print(result.body); 
    getboutique();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();  
 }
 else{
  // print(result.statusCode); 
  Navigator.of(context).pop(); 
 }  
}
Future<void> showdialoaddfollow() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
            addfollow(context);
          },
      child: const Text('s abonner ',style: TextStyle(color: Colors.green,
      fontWeight: FontWeight.bold,fontSize:16),),
          )
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
Future<void> showdialoremove() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  TextButton(onPressed: (){
             removefollow(context);
          },
        child: const  Text('se désabonner ',style: TextStyle(color: Colors.red,
        fontWeight: FontWeight.bold,fontSize:16,)),
          )
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
Future<void> showdialogconnexion() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  Row(
            children: [
              TextButton(onPressed: (){
              Navigator.of(context).pushNamed('/login');
              },
        child: const  Text('Se connecter ',style: TextStyle(color: Colors.red,
        fontWeight: FontWeight.bold,fontSize:16,)),
              ),
       const  Text("ou"),
       TextButton(onPressed: (){
        Navigator.of(context).pushNamed('/inscription');
              },
        child: const  Text('S inscrire',style: TextStyle(color: Colors.red,
        fontWeight: FontWeight.bold,fontSize:16,)),
         ),
            ],
          )
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
      appBar:AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(icon:const  Icon(Icons.arrow_back_ios,color: Colors.brown,),
        onPressed: (){
       Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
        },),
        title: Row(children: [
        Text('$prenom $nom',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
         ],), ),
      body:Container(
        margin: const EdgeInsets.only(top:15),
        child: Column(children: [
          Container(
            margin:const  EdgeInsets.only(left: 10),
            child: Row(
            children: [
          CircleAvatar(
         radius: 40,
       backgroundImage:NetworkImage("https://gaalguishop.herokuapp.com${logo}"),
             ),
      const SizedBox(width: 5,),
      Expanded(child: Column(children: [
            Text("$nbrefollower",),
            const SizedBox(height: 5,),
            const Text("abonné(s)")
      ],)),
      islog?
      Expanded(
      child: isabonned? GestureDetector(
      onTap: (){
       showdialoremove();
      },
      child: Column(children:const  [
      Icon(Icons.check_circle,size:24,color: Colors.green,),
      Text("abonné",style: TextStyle(color: Colors.blue),)
       ]),
     ):GestureDetector(
      onTap: (){
        showdialoaddfollow();
      },
      child: Column(children:const  [
      Icon(Icons.add_circle,size:24,color: Colors.blue,),
      Text("s abonner",style: TextStyle(color: Colors.blue),)
       ]),
     )
      ):
    Expanded(child: GestureDetector(onTap: (){
      showdialogconnexion();
    },
    child: Column(children:const  [
      Icon(Icons.add_circle,size:24,color: Colors.blue,),
      Text("s abonner",style: TextStyle(color: Colors.blue),)
       ]),
    )) 
     ], ),  ),
     Container(
      child: ListTile(
        title: Text(description),
      ), ),
    const SizedBox(height: 10,),
    const ListTile(
    leading: Icon(Icons.shop,color: Color.fromRGBO(200, 104, 28, 1),)
    ),
    Expanded(
      child:items.isNotEmpty?
     GridView.builder(
       gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        controller: scrollController,
        itemCount: items.length ,
         itemBuilder: ((context, index){
          var item=items[index];
          return Container(
            margin: const EdgeInsets.only(left: 2,right: 2),
            child: Card(
               elevation: 1.5,
               child:Column(
              children: [
              Image.network(item['thumbnail'],
              width: 150,
              height: 120,),
              const SizedBox(width: 5,),
              Container(
               child: Column(children: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed('/detail',arguments: item['slug']);
                  },
                  child: Text(truncateString(item['nom'],15) ,
                  style:const  TextStyle(fontWeight: FontWeight.bold),),
                ),
               ]),
              )
               ], 
              ),
            )
        ); }
        )):
    Container(
          child: const ListTile(
          title: Text("Aucun produit à afficher.",style: TextStyle(
           fontWeight: FontWeight.bold
            ),),
          ),
        )
    )  ]),  )  );  
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


