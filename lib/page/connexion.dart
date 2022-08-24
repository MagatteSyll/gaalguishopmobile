import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/apiservice.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:convert' as convert;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class Connection extends StatefulWidget {
  const Connection({ Key? key }) : super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
     late PhoneNumber phone;
     late String password;
     bool loading=false;
     static const platform =  MethodChannel("gaalguishop.native.com/auth");
     var httpIns=HttpInstance();
     bool visiblepassword=true;
   final _formKey = GlobalKey<FormState>();
Widget buildPhone(){
       return Container(
        child: InternationalPhoneNumberInput(
        validator: (value){
          if(value==null||value.trim().isEmpty){
            return "Entrez un numero de telephone valide";
          }
          return null;},
         onInputChanged: (PhoneNumber value){
           phone=value;
          //  print(value);
         },
        selectorConfig:const  SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,  ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        formatInput: false,
        keyboardType: const  TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: const OutlineInputBorder(),
        countries:const  ["SN"],
        inputDecoration: const InputDecoration(
        hintText: 'Numero de telephone',
        // border: InputBorder.none,
         isDense: true
       ),
        ),
       );
       }
    
    Widget buildPassword(){
      return Container(
        margin:const EdgeInsets.only(left: 5),
        child: Row(children: [
         Flexible(
           child: Container(
          child: TextFormField(
          obscureText: visiblepassword,
          decoration:const  InputDecoration(labelText: 'Mot de passe',
          border: OutlineInputBorder(
          borderSide:BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
          )),
         validator: (value){
        if(value==null||value.trim().isEmpty){
          return "Entrez un mot de passe ";
        }
        return null;},
       onChanged: (value){
         password=value;
        // print(value);
       },
       ),
       )),
      IconButton(
        icon: visiblepassword?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
        //color: Colors.white,
        onPressed: () {
          setState(() {
            visiblepassword=!visiblepassword;
          });
        },
          ), 
        ]),
      );
   }


// Listen to close message



  Future  handleconnexion(context) async{
    setState(() {
      loading=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/connexion/',);
    var response= await httpIns.post(url,body: {'phone':"$phone",'password':password});
    if(response.statusCode==200){
   var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   final arguments={'jmpp':jsonResponse['access'],'jvlf':jsonResponse['access']};
   await platform.invokeMethod("setoken",arguments);
   Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
    }
  else{
    setState(() {
      loading=true;
    });
    showTopSnackBar(
    context,
   const  CustomSnackBar.error(
    message:"Erreur!Utilisateur non trouvé!",),
     //  persistent: true,
   );
   return;
  }
   
  }
   
   
  @override
  Widget build(BuildContext context) { 
    return !loading? Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
        leading: IconButton(
        icon:const  Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){
         Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
          },),
       
        ),
        body: SingleChildScrollView(child: 
       Column(children: [
        const   ListTile(
        leading: Icon(Icons.shopping_cart,color: Colors.brown),
        title: Text("Faire ses courses en ligne en toute securite",
        style: TextStyle(fontWeight: FontWeight.bold),),
        trailing: Icon(Icons.lock_person,color: Colors.red,),
        ),
          Container(
          margin: const EdgeInsets.all(5.0),
          child: Form(
          key: _formKey ,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
             buildPhone(),
           const   SizedBox(height: 30,),
             buildPassword(),
          const    SizedBox(height: 30,),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                     style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.brown),
                   ),
                      child: const  Text(
                      'Connexion',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                         handleconnexion(context);
                         } }, ), ),
                 ]  )), ),
                  const   SizedBox(height: 50,),
                 Container(
                   margin: const EdgeInsets.only(left: 10),
                  child: Column(
                 children:  [
                  const  ListTile(
                     leading: Icon(Icons.money,size: 24,color: Color.fromRGBO(141, 109, 20, 1),),
                      title: Text("Vendez vos produits",style: TextStyle(color:Colors.black,fontSize:
                       16,fontWeight: FontWeight.bold),) ),
                const    ListTile(
                    leading: Icon(Icons.price_check,size: 24,color: Color.fromRGBO(141, 109, 20, 1)),
                     title: Text("Faites des achats",style:TextStyle(color:Colors.black,fontSize:
                     16,fontWeight: FontWeight.bold)),
                     ),
                    ListTile(
                      title: TextButton(
                       onPressed: (){
                        Navigator.of(context).pushNamed('/inscription');
                       },
                       child:const  Text("S inscrire",style: TextStyle(color: Colors.brown,fontWeight: FontWeight.bold),)),
                    )
                      ]),
                       )
     
               ], )
        
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
}

