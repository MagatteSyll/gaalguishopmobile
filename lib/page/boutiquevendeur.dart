// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../utils/trunfunction.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




class MaBoutique extends StatefulWidget {
  const MaBoutique({super.key});

  @override
  State<MaBoutique> createState() => _MaBoutiqueState();
}

class _MaBoutiqueState extends State<MaBoutique> {
   var httpIns=HttpInstance();
  ScrollController scrollController=ScrollController();
  List<Map<String, dynamic>> items=[] ;
  final _formKey = GlobalKey<FormState>();
   late PhoneNumber phone;
  final formkey = GlobalKey<FormState>();
  bool loading=false;
int page=1;
 var next;
 var previous;
 late bool load;
  late String nom;
  late String prenom;
  late String description;
  late String logo;
  late String note;
  var image;
  late bool active;
  final  platform =  const MethodChannel("gaalguishop.native.com/auth");
  late var nbrefollower;
  late String nomboutique;
  bool allloaded=false;
  bool loaded=false;
   bool isabonned=false;
   late String decrit;
   var phonegaalguimoney;
  List<Map<String, dynamic>> produit=[] ;
  Future getboutique() async{
  
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/maboutique/',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    //print(response.body);
     setState(() {
       nom=jsonResponse['user']['nom'];
       prenom=jsonResponse['user']['prenom'];
       logo=jsonResponse['logo'];
       description=jsonResponse['description'];
       note=jsonResponse['note_vendeur'];
       nbrefollower =jsonResponse['nbrefollower'];
       active =jsonResponse['active'];
       phonegaalguimoney=jsonResponse['comptegaalguimoney'];
      }); 
    }
  }

 Future getproduit() async{
    setState(() {
      load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitboutiqueparlevendeur/',);
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
  return;
 //print(result.statusCode);
 // return response;
 }  
 }
Future getotherproduit() async{
 setState(() {
  load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitboutiqueparlevendeur/?page=${page}',);
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
  return;
// print(result.statusCode);
 // return response;
 } 
}
Future linkmoney(context)async{
  setState(() {
    loading=true;
  });
  var url=Uri.parse('https://gaalguimoney.herokuapp.com/api/client/verificationphonepourgaalguishop/',); 
  var result=await  http.post(url,body:{'phone':"$phone"});
  if(result.statusCode==200){
  var url2=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/liersoncomptegaalguimoney/',); 
    var response=await  httpIns.post(url2,body:{'phone':"$phone"});
    if(response.statusCode==200){
    getboutique();
    Navigator.of(context).pop();
    setState(() {
      loading=false;
    });
    showTopSnackBar(
  context,
   const CustomSnackBar.success(
    message:"Données bien éditées",),
     //  persistent: true,
   );
    }
  else{
  setState(() {
      loading=false;
    });
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Oups!Une erreur est survenue,veuillez réessayer ultérieument",),
     //  persistent: true,
   );
  }
  }
  else{
  setState(() {
      loading=false;
    });
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Erreur! Veuillez verifier les données entrées!",),
     //  persistent: true,
   );
  } }
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
Future<void> showdialogdatamoney() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return !loading? AlertDialog(
       insetPadding:const  EdgeInsets.all(5),
        content: SingleChildScrollView(
          child: Column(children: [
         const  Text("Données lieés au compte GaalguiMoney",style: TextStyle(
          fontSize: 14,fontWeight: FontWeight.bold
         ),),
         const SizedBox(height: 15,),
         Form(
          key: formkey,
          child: Column(
          children: [
           buildPhone(),
           const SizedBox(height: 10,),
           ElevatedButton(
           style: ButtonStyle(
           backgroundColor: MaterialStateProperty.all(Colors.brown),),
           child: const  Text(
           'Valider',
            style: TextStyle(fontSize: 16),),
            onPressed: () {
           if (formkey.currentState!.validate())
            {
           linkmoney(context);
             }  
      }, ),
          ],
         ))
        ]),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ):
      AlertDialog(
      insetPadding:const  EdgeInsets.all(5),
      content: SingleChildScrollView(
       child: Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),)
   ),
    )
      );
    },
  );
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
Future handledescription(context) async{
   var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/editboutiquedes/',);
   var response= await httpIns.post(url,body: {'description':decrit});
  if(response.statusCode==200){
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
 // print(response.body);
  getboutique();
  Navigator.of(context).pop();
    
}
else{
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Oups!Une erreur est survenue,veuillez réessayer ultérieument",),
     //  persistent: true,
   );
}
}
 Future<String> gettoken() async{
   var token=await platform.invokeMethod('getoken');
   return token;
   }
Future handleprofil (context) async{
 try{
   final img= await ImagePicker().pickImage(source: ImageSource.gallery);
  if(img==null) return;

  String filename=img.path.split('/').last;
    FormData formdata=FormData.fromMap(
      {
      'logo':await MultipartFile.fromFile(img.path,filename: filename,),
      'note_vendeur':note,
      'active':active
      }
    );
  Dio dio =  Dio();
  var  token= await gettoken();
  dio.options.headers['content-Type'] = 'application/json';
   dio.options.headers["authorization"] = 'Bearer $token';
 var response = (await dio.post('https://gaalguishop.herokuapp.com/api/produit/editboutiquepic/',
 data: formdata));
 if(response.statusCode==200){
  getboutique();
  Navigator.of(context).pop();    
}
else{
  Navigator.of(context).pop();
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Oups!Une erreur est survenue,veuillez réessayer ultérieument",),
     //  persistent: true,
   );
}

 }
 on PlatformException {
  showTopSnackBar(
  context,
   const CustomSnackBar.error(
    message:"Pas d autorisation pour acceder a la galarie",),
     //  persistent: true,
   );
 }
  
}
Widget buildtext(){
      return Container(
        margin:const EdgeInsets.only(left: 5),
        child: Row(children: [
         Flexible(
           child: Container(
          child: TextFormField(
          maxLines: 4,
          decoration:const  InputDecoration(labelText: 'Description',
          border: OutlineInputBorder(
          borderSide:BorderSide(color:Colors.black,width: 1,style: BorderStyle.solid),
          )),
         validator: (value){
        if(value==null||value.isEmpty){
          return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         decrit=value;
        // print(value);
       },
       ),
       )) ]),
      );
   }
Future<void> showdialogdescription() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Décrire sa boutique'),
        content: SingleChildScrollView(
          child: Form(
             key: _formKey ,
            child: ListBody(
              children: [
                buildtext(),
               const  SizedBox(height: 15,),
               ElevatedButton(
                     style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.brown),
                   ),
                      child: const  Text(
                      'Soumettre',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                      if (_formKey.currentState!.validate()) {
                          handledescription(context);
                         } }, ), 
              ],
            ),

          ),
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
Future<void> showdialogprofil() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content:  SingleChildScrollView(
          child:  TextButton(onPressed: (){
             handleprofil(context);
          },
        child:Row(
          children:const  [
           Icon(Icons.camera_alt),
           Text('Modifiez son profil'),
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
        Text('$prenom $nom',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
         ],), ),
      body:Container(
        margin: EdgeInsets.only(top:15),
        child: Column(children: [
          Container(
            margin:const  EdgeInsets.only(left: 10,right: 0),
            child: Row(
            children: [
         GestureDetector(
           onTap: (){
            showdialogprofil();
           },
           child: CircleAvatar(
           radius: 40,
        backgroundImage:NetworkImage("https://gaalguishop.herokuapp.com${logo}",
        scale: 45),
       ), ),  
      const SizedBox(width: 5,),
      Expanded(child: Column(children: [
            Text("$nbrefollower",),
            const SizedBox(height: 5,),
            const Text("abonné(s)")
      ],)),
      Expanded(
      child:GestureDetector(
      onTap: (){},
      child: Column(children: [
      Text("($note)"),
     const  Text("note",style: TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),)
       ]),
     ) ), ],),  ),
     Container(
      child: ListTile(
        title: Text(description),
        trailing: IconButton(onPressed:(){
          showdialogdescription();
        },
        icon: const Icon(Icons.edit),color:const  Color.fromRGBO(200, 104, 28, 1),),
      ), ),
    const SizedBox(height: 10,),
    active?
    Container(
      child: phonegaalguimoney!=null?  ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
        child: const  Text('Ajouter un produit',style: TextStyle(fontSize: 16),),onPressed: ()  {
        Navigator.of(context).pushNamed('/ajoutproduit'); }, ):
        TextButton( 
        child: const  Text('Ajouter un compte gaalguimoney a sa boutique pour commencer à vendre ',
        style: TextStyle(fontSize: 16,
        decoration:TextDecoration.underline),
        ),
        onPressed: ()  {
         showdialogdatamoney();
        }, )
    ):
      Container(),
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
           // margin: const EdgeInsets.only(left: 2,right: 2),
            child: Card(
               elevation: 1.5,
               child: Column(
              children: [
              Image.network(item['thumbnail'],
              width: 140,
              height: 110,),
               Row(
                 children: [
                   TextButton(
                     onPressed: (){
                   Navigator.of(context).pushNamed('/detail',arguments: item['slug']);
                        },
                        child: Text(truncateString(item['nom'],10) ,
                        style:const  TextStyle(fontWeight: FontWeight.bold),),
                      ),
                  IconButton(onPressed: (){
                    Navigator.of(context).pushNamed('/modificationproduit',arguments: item['slug']);
                  }, icon: const  Icon(Icons.edit,color: Color.fromRGBO(200, 104, 28, 1)))
                 ],
               ), 
                
               ], 
              ),
            )
        ); }
        )):
    Container(
          child: const ListTile(
          title: Text("Oups votre boutique est vide.",style: TextStyle(
           fontWeight: FontWeight.bold
            ),),
        
          ),
        )
    ) ,
    image!=null?
    Expanded(child: 
    Image.file(image))
    :Container()
     ]),  )
    );
  }
}
