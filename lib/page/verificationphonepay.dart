// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../utils/apiservice.dart';
import 'dart:convert' as convert;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;


class VerificationPhonePay extends StatefulWidget {
  final dynamic id;
  const VerificationPhonePay(this.id, {super.key});

  @override
  State<VerificationPhonePay> createState() => _VerificationPhonePayState();
}

class _VerificationPhonePayState extends State<VerificationPhonePay> {
  var httpIns=HttpInstance();
  late bool load;
  var commande;
  final formKey = GlobalKey<FormState>();
  var code;
  bool loading=false;

  Future getcommande()async{
  var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/commandepay/',); 
  var result=await  httpIns.post(url,body:{'id':id});
   if(result.statusCode==200){
      //print(result.body);
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>;  
   setState(() {
    commande=jsonResponse;
    });
   return ;
 }
 else{
  return;
 //print(result.statusCode);
  //return response;
 }
  }
Future payer(context)async{
  setState(() {
    loading=true;
  });
 // print(code);
 
   var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguimoney.herokuapp.com/api/client/payementgaalguishop/',); 
  var result=await  http.post(url,body:{
    'code':"$code",
    'phone':"${commande['phone_gaalguiMoney']}",
    'id':"${commande['codeid']}",
    'total':"${commande['total']}",
    'commission':"${commande['commission']}",
    'livraison':"${commande['livraison']}",
  });
  if(result.statusCode==200){
    var url2=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/confirmationpaycommande/',); 
  var response=await  httpIns.post(url2,body:{'id':id});  
if(response.statusCode==200){
  Navigator.of(context).pushNamed('/recucommande',arguments:widget.id);
   setState(() {
  loading=false;
});
}
else{
  setState(() {
    loading=false;
  });
 // print(response.statusCode);
showTopSnackBar(
  context,
  const CustomSnackBar.error(
  message:"Erreur!Commande non effectuee.",),
     //  persistent: true,
        );
}
 }
 else{
setState(() {
    loading=false;
  });
showTopSnackBar(
  context,
  const CustomSnackBar.error(
  message:"Erreur!Payement refusé.",),
     //  persistent: true,
        );
 //print(result.statusCode);
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
Widget buildcode(){
    return  TextFormField(

     keyboardType:const  TextInputType.numberWithOptions(decimal:false,
        signed: false,),
       decoration:const  InputDecoration(labelText: 'Code de verification du compte GaalguiMoney',
          border: OutlineInputBorder(
          borderSide:BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
          )),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un code valide ";
        }
        return null;},
       onChanged: (value){
        code=value;
       },
       );
    }
  Future annulationcommande(context) async{
 var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/actioncommande/suppressioncommandeuser/',); 
  var result=await  httpIns.put(url,body:{
   'id':id
  });
  if(result.statusCode==200){
   var url2=Uri.parse('https://gaalguimoney.herokuapp.com/api/client/managecode/coderemove/',); 
  var response=await  http.put(url2,body:{
    'id':"${commande['codeid']}"
  }); 
  if(response.statusCode==200){
  Navigator.of(context).pop();
}
else{
  return;
//print(response.statusCode);
}
 }
 else{
  return;
 //print(result.statusCode);
  //return response;
 }
  }
  @override
  Widget build(BuildContext context) {
  if(load){
  return !loading? Scaffold(
    appBar: AppBar(
    automaticallyImplyLeading: false,
      backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
      leading: IconButton(
      icon:const  Icon(Icons.arrow_back_ios ,color: Colors.white,),
      onPressed: (){
        annulationcommande(context);
      },),
    ),
  body: SingleChildScrollView(child: 
  Container(
    margin: const EdgeInsets.only(top: 50,left: 15,right: 15),
    child: Form(
      key: formKey,
      child: 
    Column(children: [
      buildcode(),
      const SizedBox(height: 20,),
       ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
        child: const  Text('Confirmer',style: TextStyle(fontSize: 16),),onPressed: ()  {
       if (formKey.currentState!.validate()){
         // print("oy");
          payer(context);
         
       }
        ;
       }, )
    ],)),
  )),
    ):Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
    );
  }
else{
  return  Container(
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