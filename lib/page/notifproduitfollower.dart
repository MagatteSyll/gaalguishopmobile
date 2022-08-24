import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';




class NotificationFollower extends StatefulWidget {
  final dynamic id;
  const NotificationFollower(this.id, {super.key});

  @override
  State<NotificationFollower> createState() => _NotificationFollowerState();
}

class _NotificationFollowerState extends State<NotificationFollower> {
  var httpIns=HttpInstance();
   late bool load;
   late String message;
  var produit ;
  Future getnotification() async{
    var id=convert.jsonEncode(widget.id);
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getnotification/',);
    var response= await httpIns.post(url,body: {'id':id});
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   // print(response.body);
 // print(jsonResponse['results'].length);
    setState(() {
     message=jsonResponse['message'];
     produit=jsonResponse['produit'];
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
    body:Container(
    margin: const EdgeInsets.only(top: 50,left:3,right: 3),
   child: Card(
       child: Column(children: [
        Container(
       margin: const  EdgeInsets.only(top: 10,left: 10),
       child: Image.network("https://gaalguishop.herokuapp.com${produit['thumbnail']}",
       width: 300,
      height: 250, ), ), 
      Text(produit!['nom']),
      ListTile(title: TextButton(
       onPressed: () {
      Navigator.of(context).pushNamed('/detail',arguments: produit['slug']);
     },
    child: const Text('Voir les details du produit'))),
  
   ]),
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