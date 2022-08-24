// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/services.dart";
import 'package:gaalguishop/page/souscomponent/myappbar.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:badges/badges.dart';











class Accueil extends StatefulWidget {
  
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}


class _AccueilState extends State<Accueil> {
  var httpIns=HttpInstance();
  static const platform =  MethodChannel("gaalguishop.native.com/auth");
   bool islog=false;
   bool searchfocus=false;
   bool load=false;
   List<Map<String, dynamic>> categories=[] ;
   List<Map<String, dynamic>> populaires=[] ;
   List<Map<String, dynamic>> vendeurs=[] ;
   List<Map<String, dynamic>> occasions=[] ;
   late String prenom;
   late String room;
   var userid;
   var badge=0;
   var badgenotif=0;
   var channel;
   

deconnexion() async{
  await platform.invokeMethod("deconnexion");
} 


  Future getcategory() async{
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/category/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
 // print(result.body);
  var response=convert.jsonDecode(result.body);
   return response;
 }
 else{
 
 return;
 }
  }
  Future getpopulaire() async{
  /* var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/isauthenticated/',);
  var result=await  httpIns.get(url);
 if(result.statusCode!=200){
    await deconnexion();
   return false;
 }
 else{
var  jsonResponse = convert.jsonDecode(result.body);
return jsonResponse;
 }*/
  }
Future getbadge() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getcart/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
  // print(result.body);
   var response=convert.jsonDecode(result.body);
   setState(() {
     badge=response['count'];
   });
   return response;
 } 
 else{

return ;
 }
}
Future getbadgenotif() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getbadge/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
  // print(result.body);
   var response=convert.jsonDecode(result.body);
  // print(response['badge']);
   setState(() {
     badgenotif=response['badge'];
   });
   return response;
 }
 else{

return ;
 }
}
Future getmeilleurvendeur() async{
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/nosvendeur/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
  // print(result.body);
   var response=convert.jsonDecode(result.body);
   return response;
 }
 else{

return ;
 }
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
   setState(()=>{
        prenom=response['prenom'],
        userid=response['id'],
        room=response['channel']
        
      });
   return response ;
 }
 else{
  return;
 }
}
Future getoccasion() async{
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitoccasion/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
  // print(result.body);
   var response=convert.jsonDecode(result.body);
   return response;
 }
 else{
  return ;
 }
}

Future handlebadgenotif()async{
  if(badgenotif>0){
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/handlenotify/handlenotif/',);
  var result=await  httpIns.put(url);
 if(result.statusCode==200){
    getbadgenotif();
   
   return;
 }
 else{
return ;
 }
  }
   
}
  @override
  void initState() {
    getislog().then((res) => {
      setState(()=>{
       islog=res,
       if(res==true){
      getuser(),
      getbadge(),
      getbadgenotif()
       }
      })
    });
   
    getcategory().then((res) => {
    setState(()=>{
    for(var i=0;i<res.length;i++){
     categories.add(res[i])
    }
    })
    });
   getmeilleurvendeur().then((res) => {
    setState(()=>{
    for(var i=0;i<res.length;i++){
     vendeurs.add(res[i])
    }
    })
    });
   /*getpopulaire().then((res) => {
    setState(()=>{
    for(var i=0;i<res.length;i++){
     populaires.add(res[i])
    }
    })
    });*/
   getoccasion().then((res) => {
    setState(()=>{
    for(var i=0;i<res.length;i++){
     occasions.add(res[i])
  }
  })
  });
  setState(() {
    load=true;
  });
super.initState();
}

Future handleshopcategory(context,catid) async{
Navigator.of(context).pushNamed('/produitunecategorie',arguments: catid);
}

  showtoggle(){
  showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: ((context, index){
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Center(
                     child: TextButton(
                       onPressed: () {
                         handleshopcategory(context,categories[index]['id']);
                       },
                       child: Text(categories[index]['category'],
                       style: const  TextStyle(
                       fontSize:20,fontWeight:FontWeight.bold,
                       color: Color.fromRGBO(200, 104, 28, 1)
                       )),
                     ),
                 ),
                  );
                  })  
                 ),
          );
        }
  );
}
showcompte(islog){
  if(islog){
     showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const  BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Container(
              margin: const  EdgeInsets.only(top: 5,left:15),
              child: ListView(children:  [
                 TextButton(onPressed: (){
                   Navigator.of(context).pushNamed('/compte');
                 },
                 child:Row(children:    [
                const  Icon(Icons.account_circle,color: Colors.green,),
                 Text(prenom,
          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),) 
                 ],)),
               const  SizedBox(height: 15,),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamed('/maboutique');
                },
                 child:Row(children: const   [
                 Icon(Icons.shop,color: Color.fromRGBO(200, 104, 28, 1),),
                 Text("Ma boutique",
                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),) 
                 ],)),
               const  SizedBox(height: 15,),
               TextButton(onPressed: (){
                Navigator.of(context).pushNamed('/achat');
               },
                 child:Row(children: const   [
                 Icon(Icons.wallet,color: Colors.brown,),
                 Text("Mes achats",
                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),) 
                 ],)),
               const  SizedBox(height: 15,),
               TextButton(onPressed: (){
                Navigator.of(context).pushNamed('/mescommandes');
               },
                 child:Row(children: const   [
                 Icon(Icons.shopping_bag,color: Colors.orange,),
                 Text("Mes commandes",
                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),) 
                 ],)),
               const  SizedBox(height: 15,),
               TextButton(onPressed: (){
                Navigator.of(context).pushNamed('/moyendepayement');
               },
                 child:Row(children: const   [
                 Icon(Icons.monetization_on,color: Colors.black,),
                 Text("Moyen de payement",
                 style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),) 
                 ],)),
               const  SizedBox(height: 15,),
              ],),
            ),
          );
        }
  );
  }
  else{
   showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: const  EdgeInsets.only(top: 20,left: 10),
            child:Column(
              children: [
                const Text("Pour profiter des services d achat et de vente de gaalguishop"),
                Row(
                  children: [
                    TextButton(onPressed: (){Navigator.of(context).pushNamed('/login');}, child:const  Text('Connectez-vous')),
                   const  Text("ou"),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamed('/inscription');
                    }, child:const  Text('Inscrivez vous')),
                  ],
                ), 
              ],
            ),
          );
      }
   );

  }
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

handleroutenotif()async{
  Navigator.of(context).pushNamed('/notification');
 await  handlebadgenotif();
}
  @override
  Widget build(BuildContext context) {
    if(load){
       return Scaffold(
     appBar:PreferredSize(
       preferredSize: const Size.fromHeight(50),
       child:myappbar(context,badge,islog,showdialogconnexion),
      ),
      body:
          SingleChildScrollView(
            child: Column(
              children: [
                const  ListTile(
                 textColor: Color.fromARGB(255, 187, 125, 32),
                 title: Text("Categories les plus demandees",
                 style: TextStyle(fontWeight:FontWeight.bold),),
                ),
                 parcategory(categories,context),
                 const  SizedBox(height: 15,),
                 occasions.isNotEmpty?
                  const  ListTile(
                 textColor: Color.fromARGB(249, 179, 18, 165),
                 title: Text("Du materiel d occasion pour vous",
                 style: TextStyle(fontWeight:FontWeight.bold),),
                ):Container(),
                occasions.isNotEmpty?
                 occasion(occasions,context):
                Container(),
                const  SizedBox(height: 5,),
                meilleurvendeur(vendeurs,context,userid),
              //  const  SizedBox(height: 15,),
               //  populaire(populaires),
              ],),
          ),  
      bottomSheet: ListTile(
        leading: IconButton(icon: const Icon(Icons.menu,color: Colors.black,size: 30),
        onPressed: (){
          showtoggle(); 
        }),
        trailing: badgenotif==0? GestureDetector(
        onTap: (){ islog? 
         handleroutenotif():showdialogconnexion();},
        child: const  Icon(Icons.notifications,color: Colors.black,size: 30,), )
      :GestureDetector(
        onTap: (){ islog? 
          handleroutenotif():showdialogconnexion();},
        child: Badge(
          elevation: 0,
          alignment: Alignment.topLeft,
          badgeContent: Text('$badgenotif',style: const TextStyle(color:Colors.white)),
          child: const  Icon(Icons.notifications,color: Colors.black,size: 30,),

        )
      ),
    title:IconButton(icon: const  Icon(Icons.account_circle,color: Colors.black,size: 30,),onPressed: (){
        showcompte(islog);
      },), 
      ),
    );
 }
 else{
   return Container(
     decoration: const BoxDecoration(color: Colors.white),
     child:const  SpinKitSquareCircle(
     color: Colors.purple,
     size: 250.0,
     duration: Duration(milliseconds: 1000),
)
    );
 }
 }
}

 Widget parcategory(categories,context){
   final List<Widget> categoryslider = categories
    .map<Widget>((item) => Container(
          child: Container(
            margin: const  EdgeInsets.only(left:5.0,right: 5),
            child: ClipRRect(
                borderRadius: const  BorderRadius.all(Radius.circular(15.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network("https://gaalguishop.herokuapp.com${item['image']}", 
                    fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration:const  BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding:const  EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: ListTile(
                          title: TextButton(
                            onPressed: (){
                          Navigator.of(context).pushNamed('/produitunecategorie',arguments:item['id']);
                            },
                            child: Text(
                              item['category'],
                              style:const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        )).toList();
   
  return  Container(
        //margin: const EdgeInsets.only(top: 25,left: 5), 
        child: CarouselSlider(
          options: CarouselOptions(
             autoPlay: true,
             aspectRatio: 1.5,
             enlargeCenterPage: true,
          ),
          items:categoryslider
       ),
        );
}
Widget occasion(occasions,context){
  Widget imgoccasion(index){
    if(index <occasions.length){
       return GestureDetector(
         onTap: (){
          Navigator.of(context).pushNamed('/detail',arguments:occasions[index]['slug'] );
         },
         child: Card(
             child: Column(
          children: [
            Text(occasions[index]['nom']),
            Image.network("https://gaalguishop.herokuapp.com${occasions[index]['thumbnail']}",
            width: 150,
            height: 150,
            ),
          ],
             ),
           ),
       );
   }
  else{
    return Container();
  }
   
  }
  return Container(
    margin: const EdgeInsets.only(left: 5),
    child:Card(child: Column(children: [
      Container(
      child:Row(children: [
      imgoccasion(0),
       const  SizedBox(width: 20,),
       imgoccasion(1),
      ],) ),
  const  SizedBox(height: 10,),
    Container(
      child:Row(children: [
      imgoccasion(2),
       const  SizedBox(width: 20,),
       imgoccasion(3),
      ],) ),
   const  SizedBox(height: 10,),
   Container(
      child:Row(children: [
      imgoccasion(4),
       const  SizedBox(width: 20,),
       imgoccasion(5),
      ],) ),
      const  SizedBox(height: 10,),
   Container(
      child:Row(children: [
      imgoccasion(6),
       const  SizedBox(width: 20,),
       imgoccasion(7),
      ],) ),
    const  SizedBox(height: 10,),
     Container(
     margin:const  EdgeInsets.only(left:5),
      child: ListTile(
        title: TextButton(
        onPressed: (){
          print('appuyer');
          Navigator.of(context).pushNamed('/occasion');
        },
        child:const Text("Voir plus"),),), ),

      ],),)
  );
}

Widget meilleurvendeur(vendeurs,context,userid){
  
  return Container(
    width: MediaQuery.of(context).size.width * 1,
    height: 300,
    child: Card(
      margin: const EdgeInsets.only(left: 15),
      child:Column(children: [
      const  ListTile(
       textColor: Color.fromARGB(249, 179, 18, 165),
       title: Text("Nos meilleurs vendeurs",
       style: TextStyle(fontWeight:FontWeight.bold),),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 150,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
             scrollDirection: Axis.horizontal,
              itemCount: vendeurs.length+1,
             itemBuilder: (context, index) => (index != vendeurs.length)
            ? Container(
               margin: const  EdgeInsets.only(left: 5,right: 5),
               child: GestureDetector(
                 onTap:userid==vendeurs[index]['user']['id']? (){ 
                 Navigator.of(context).pushNamed('/maboutique');
                 }:(){
                 Navigator.of(context).pushNamed('/boutiquevu',arguments:vendeurs[index]['id'] );
                  },
                 child: Column(
                    children: [
                    Text("${vendeurs[index]['note_vendeur']}",
                    style: const TextStyle(
                      color:Color.fromARGB(200, 104, 28, 1),
                    )),
                     CircleAvatar(
                          radius:35,
                            backgroundImage:NetworkImage("https://gaalguishop.herokuapp.com${vendeurs[index]['logo']}",
                           )
                 ),
                           TextButton(
                           onPressed: (){},
                           child: Text(vendeurs[index]['user']['prenom']+" "+vendeurs[index]['user']['nom'] )),
                      ]),
               ))
            : Container(
              child: Column(
                children: [
                 const  SizedBox(height: 18,),
                  CircleAvatar(
                      radius: 35,
                      child: TextButton(
                      onPressed: (){
                    Navigator.of(context).pushNamed('/meilleurvendeur');
                      }, 
                      child: const  Text('voir plus',style: TextStyle(color: Colors.white),)),
                    ),
                ],
              ),
            ))      
       
      ),
          
 ],)
       
  ));
  }

Widget populaire(populaires){
  return Container(
    margin: const EdgeInsets.only(top: 20,left: 5),
    child:const  Center(child: Text("catergoy"),),
  );
}


