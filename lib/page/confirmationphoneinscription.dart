// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../utils/apiservice.dart';
import 'dart:convert' as convert;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class ConfirmationPhoneInscription extends StatefulWidget {
  final dynamic id;
  const ConfirmationPhoneInscription(this.id, {super.key});

  @override
  State<ConfirmationPhoneInscription> createState() => _ConfirmationPhoneInscriptionState();
}

class _ConfirmationPhoneInscriptionState extends State<ConfirmationPhoneInscription> {
  var httpIns=HttpInstance();
   late String code;
   final formKeycode = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  var user;
  late bool load;
  bool loading=false;
   Widget codeWidget(){
      return Container(
        child:
        TextFormField(
      keyboardType:TextInputType.number,
      decoration: const InputDecoration(labelText: 'Code de vérification du numero de telephone',
      border: OutlineInputBorder(
       borderSide: BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
          )),
      validator: (value){
        if(value==null||value.trim().isEmpty){
          return "Entrez un code valide";
        }
        return null;},
       onChanged: (value){
         code=value;
       }, ) ); }
    
  Future handlecode(context) async{
    setState(() {
      loading=true;
    });
   var id=convert.jsonEncode(widget.id);
   var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/phonecodeconfirmation/',);
  var response=await  httpIns.post(url,body: {"code_id": "${user['codeid']}","code":code,"id":id});
  if (response.statusCode == 200) {
   Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route route) => false);
  }
  else {
   setState(() {
      loading=false;
    });
  showTopSnackBar(
    context,
   const  CustomSnackBar.error(
    message:"Erreur!Verifiez le code entré",),
     //  persistent: true,
   );
 }
}
Future annulation(context)async{
  var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('http://192.168.0.50:8000/api/utilisateur/suspensioninscription/deleteuser/${id}/',);
  var response=await  httpIns.put(url);
  if (response.statusCode == 200) {
   Navigator.of(context).pushNamedAndRemoveUntil('/inscription', (Route route) => false);
  }
  
}
Future getuser() async{
   var id=convert.jsonEncode(widget.id);
  var url=Uri.parse('http://192.168.0.50:8000/api/utilisateur/getuseregistration/',);
  var response=await  httpIns.post(url,body: {"id":id});
  if (response.statusCode == 200) {
  // print(response.body);
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {
      user=jsonResponse;
    });
  }  
}
@override
  void initState() {
   getuser();
   setState(() {
     load=true;
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   if(load){
     return  !loading? Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor:const  Color.fromRGBO(200,104,28,1), 
      leading: IconButton(onPressed: (){
        annulation(context);
      }, 
      
      icon:const Icon(Icons.arrow_back_ios,color: Colors.white,),), 
      ),
    body: SingleChildScrollView(
          child: ListBody(
            children: [
                const  SizedBox(height: 15,),
                 Container(
                  margin: const EdgeInsets.only(top: 50,left: 15,right: 15),
                   child: Form(
                     key: formKeycode,
                     child: Column(children: [
                     codeWidget(),
                  const SizedBox(height: 15,),
                      ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.brown),),
                    child: const Text(
                    'Valider',
                    style: TextStyle(fontSize: 16),
                    ),
                    onPressed: (){
                     if (formKeycode.currentState!.validate()) {
                      handlecode(context);
                   // handlecode(context,id,codid);
                     }}, ),
                   ],)),
                 )
              
            ],
          ),
        ),
    ):
    Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
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
