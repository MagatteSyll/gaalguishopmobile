// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';



class NotificationNoteVendeur extends StatefulWidget {
 final dynamic id;
 const NotificationNoteVendeur(this.id, {super.key});

  @override
  State<NotificationNoteVendeur> createState() => _NotificationNoteVendeurState();
}

class _NotificationNoteVendeurState extends State<NotificationNoteVendeur> {
   var httpIns=HttpInstance();
   late bool load;
   late String message;
   double  note=1;
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

handlenote(context) async{
  var id=convert.jsonEncode(widget.id);
  //var mark=convert.jsonEncode(widget.id)
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/noterlevendeur/',);
    var response= await httpIns.post(url,body: {'id':id,'note':'$note'});
    if(response.statusCode==200){
     Navigator.of(context).pop();
   showTopSnackBar(
    context,
   const  CustomSnackBar.error(
    message:"Note bien prise en compte",),
     //  persistent: true,
   );

    }
 else{
  return;
  // print(response.body);
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
        Navigator.of(context).pushNamedAndRemoveUntil('/notification', (Route route) => false);
      })
      ),
    body:SingleChildScrollView(
      child: 
        Container(
        margin: const EdgeInsets.only(top: 50,left:5,right: 5),
        child: Column(children: [
        Text(message,style:const  TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        Container(
          margin: const EdgeInsets.only(top: 15,left: 5,right: 5),
          child: Center(
            child: Row(
            children: [
            RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding:const  EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Color.fromRGBO(200, 104, 28, 1),  ),  
            onRatingUpdate: (rating) {
             // print(rating);
              setState(() {
              note=rating ;
               });
              },),
            Text("($note)")
              ],
            ),
          ),
        ),
      const SizedBox(height: 15,),
      ElevatedButton(onPressed: (){
        handlenote(context);
      }, 
      child:const  Text('Confirmer'),
      ),
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