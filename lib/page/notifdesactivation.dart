import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';


class NotificationDesactivation extends StatefulWidget {
  final dynamic id;
  const NotificationDesactivation(this.id, {super.key});

  @override
  State<NotificationDesactivation> createState() => _NotificationDesactivationState();
}

class _NotificationDesactivationState extends State<NotificationDesactivation> {
  var httpIns=HttpInstance();
   late bool load;
   late String message;
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
   child: Column(children: [
      Text(message,style:const  TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
      const SizedBox(height: 10,),
     const
      Text("Des lors vous ne pourrez plus ajouter de produits sur la plateforme.La desactivation ne concerne que les fonctionnalités de vente,vous pouvez toujours commander des produits.",
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      const SizedBox(height:20,),
      ListTile(leading: TextButton(
      onPressed: (){},
      child:const  Text('Politique d utilisation',style: TextStyle(color: Colors.blue),)),),
      ListTile(leading: TextButton(
      onPressed: (){},
      child:const  Text('Politique de confidentialité',style: TextStyle(color: Colors.blue),)),),

      
     ],)
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