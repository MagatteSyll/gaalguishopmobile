// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import "../utils/apiservice.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';




class ModificationProduit extends StatefulWidget {
 final dynamic slug;
  const ModificationProduit(this.slug, {super.key});

  @override
  State<ModificationProduit> createState() => _ModificationProduitState();
}

class _ModificationProduitState extends State<ModificationProduit> {
  var nom;
  var description;
  var prix;
  var taille;
  var couleur;
  var qte;
  var cat;
  var reg;
  var poids;
  var mesure;
  late bool variation;
  late bool load;
  bool loading=false;
  var httpIns=HttpInstance();
  final  platform =  const MethodChannel("gaalguishop.native.com/auth");
  List<Map<String, dynamic>> produitimage=[] ;
  List<Map<String, dynamic>> category=[] ;
  List<Map<String, dynamic>> region=[] ;
  final formKeyunique = GlobalKey<FormState>();
  final formKeyvarie = GlobalKey<FormState>();
  final varieformkey= GlobalKey<FormState>();
  Future getdeviselocationcategory() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/deviselocationcategory/',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
  //print(result.body); 
   setState(() {
  for(var i=0;i<jsonResponse['category'].length;i++){
  category.add(jsonResponse['category'][i]);
      }
  for(var i=0;i<jsonResponse['location'].length;i++){
  region.add(jsonResponse['location'][i]);
      }
  });
   return ;
 }
 else{
 var response=convert.jsonDecode(result.body);
  return response;
 }  
 }
 Future getproduitandimage() async{
 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/getproduitandimage/',);
  var result=await  httpIns.post(url,body: {'slug':widget.slug});
  if(result.statusCode==200){
 //print(result.body);
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
   setState(() {
     for(var i=0;i<jsonResponse['image'].length;i++){
     produitimage.add(jsonResponse['image'][i]);
     }
     nom=jsonResponse['produit']['nom'];
     description=jsonResponse['produit']['description'];
     prix=jsonResponse['produit']['prix'];
     taille=jsonResponse['produit']['taille'];
     couleur=jsonResponse['produit']['couleur'];
     qte=jsonResponse['produit']['qte'];
     variation=jsonResponse['produit']['variation'];
     cat=jsonResponse['produit']['category']['id'];
     reg=jsonResponse['produit']['region']['id'];
     poids=jsonResponse['produit']['poids'];
     mesure=jsonResponse['produit']['unite_mesure_poids'];

   });
  }
else{
 // print(result.statusCode);
}
 }

@override
void initState(){
getproduitandimage();
getdeviselocationcategory();
setState((){
  load=true;
});
super.initState();
}
Widget buildnom(){
    return  TextFormField(
      controller: TextEditingController(text: nom),
       decoration:const  InputDecoration(labelText: 'Nom du produit',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         nom=value;
       //  print(value);
       },
       );
    }
   Widget buildpoids(){
    return  TextFormField(
          controller: TextEditingController(text: poids),
         keyboardType:const  TextInputType.numberWithOptions(decimal: true,
          signed: false,),
         inputFormatters:<TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
         ],
         decoration:const  InputDecoration(labelText: 'Poids du produit ',),
         validator: (value){
          if(value==null||value.isEmpty){
          return "Entrez un nombre valide ";
          }
          return null;},
         onChanged: (value){
           poids=value;
          // print(value);
         },
    );}
  buildunitemesure(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Unité de mesure",),
    items: ["g","kg"]
   .map((label) => DropdownMenuItem(
    value: label,
    child:label==mesure? 
    Text(label,style: const TextStyle(color: Color.fromRGBO(200, 104, 28, 1))):Text(label)
     ))
    .toList(), 
  onChanged: (value){
   mesure=value;
    // print(value);
       },
   );
  }
   Widget builddescription(){
    return  TextFormField(
      controller: TextEditingController(text: description),
       maxLines: 3,
       decoration:const  InputDecoration(labelText: 'Description du produit',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         description=value;
        // print(value);
       },
       );
       
   }
    Widget buildprix(){
    return  TextFormField(
       inputFormatters:<TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
         ],
      controller: TextEditingController(text: prix),
       keyboardType:const  TextInputType.numberWithOptions(decimal: true,
        signed: false,),
       decoration:const  InputDecoration(labelText: 'Prix du produit ',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un nombre valide ";
        }
        return null;},
       onChanged: (value){
         prix=value;
        // print(value);
       },
       );
      
   }

buildcat(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Categorie",),
    items: category
          .map<DropdownMenuItem<String>>((caty) {
        return DropdownMenuItem<String>(
          value: caty['id'].toString(),
          child:caty['id']==cat? Text(caty['category'],
          style:const  TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),):Text(caty['category'],
          )
        );
      }).toList(),
    
  onChanged: (value){
   cat=value;
    // print(value);
       },
   );
  }
buildregion(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Region",),
    items:region
          .map<DropdownMenuItem<String>>((re) {
        return DropdownMenuItem<String>(
          value:re['id'].toString(),
          child:re['id']==reg? Text(re['region'],
          style:const  TextStyle(color: Color.fromRGBO(200, 104, 28, 1)),):
          Text(re['region'],)
        );
      }).toList(),
    
   onChanged: (value){
     reg=value;
      // print(value);
       }, 
   );
  }
   Widget buildtaille(){
    return  TextFormField(
      controller: TextEditingController(text: taille),
       decoration:const  InputDecoration(labelText: 'Taille du produit',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
     onChanged: (value){
         taille=value;
        // print(value);
       },
       );
       
   }
   Widget buildcouleur(){
    return TextFormField(
      controller: TextEditingController(text: couleur),
       decoration:const  InputDecoration(labelText: 'Couleur du produit',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
      onChanged: (value){
        couleur=value;
        // print(value);
       },
       );
   }
   Widget buildqte(){
    return  TextFormField(
        controller: TextEditingController(text:'$qte'),
        keyboardType:const  TextInputType.numberWithOptions(decimal: true,
        signed: false,),
       decoration:const  InputDecoration(labelText: 'Quantite disponible',),
       validator: (value){
        if(value==null||value.trim().isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
      onChanged: (value){
         qte=value;
        // print(value);
       },
       );
       
   }
  Future<String> gettoken() async{
   var token=await platform.invokeMethod('getoken');
   return token;
   }

  Future handledetail(context) async{
    setState(() {
      loading=true;
    });
 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitmanage/modifproduit/${widget.slug}/',);
    var response= await httpIns.put(url,body:{
      'nom':nom,
      'description':description,
      'prix':"$prix",
      "cat_id":"$cat",
      "region_id":"$reg",
      "variation":"$variation",
      "devise_id":"1",
      "taille":taille,
      "couleur":couleur,
      "qte":"$qte",
      "poids":poids,
      "unite_mesure_poids":mesure,

    });
 if(response.statusCode==200){
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
 showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Details du produit bien édités.",),
     //  persistent: true,
        );
 }
else{
 // print(response.statusCode);
  setState(() {
    loading=false;
  });
 showTopSnackBar(
  context,
  const CustomSnackBar.error(
      message:"Erreur!Echec de la modification .",),
     //  persistent: true,
        );
}}

Future suppressionproduitimg(pk) async{
  setState(() {
      loading=true;
    });
 var id=convert.jsonEncode(pk);
 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitmanage/suppression/${id}/',);
 var response= await httpIns.put(url);
 if(response.statusCode==200){
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
 // ignore: use_build_context_synchronously
 showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Image supprimée.",),
     //  persistent: true,
        );
 }
else{
 setState(() {
    loading=false;
  });
  // ignore: use_build_context_synchronously
  showTopSnackBar(
    context,
    const CustomSnackBar.error(
    message:"Erreur!Echec de la suppression de l image.",),
     //  persistent: true,
        );
      }
}
Future modificationimg(pk,) async{
  setState(() {
    loading=true;
  });

try{
   final img= await ImagePicker().pickImage(source: ImageSource.gallery);
  if(img==null) return;

  String filename=img.path.split('/').last;
    FormData formdata=FormData.fromMap(
      {
      'image':await MultipartFile.fromFile(img.path,filename: filename,),
      }
    );
  var id=convert.jsonEncode(pk);
  Dio dio =  Dio();
  var  token= await gettoken();
  dio.options.headers['content-Type'] = 'application/json';
   dio.options.headers["authorization"] = 'Bearer $token';
 var response = (await dio.put('https://gaalguishop.herokuapp.com/api/produit/produitmanage/modifimageproduit/${id}/',
 data: formdata));
 if(response.statusCode==200){
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
 // ignore: use_build_context_synchronously
 showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Image bien modifiée.",),
     //  persistent: true,
        );
  }
// ignore: duplicate_ignore
else{
setState(() {
    loading=false;
  });
// ignore: use_build_context_synchronously
showTopSnackBar(
    context,
    const CustomSnackBar.error(
    message:"Erreur!Echec de la modification  de l image.",),
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
 // print("Pas d autorisation pour utiliser la camera");
 }
}

Future modificationdetail() async{
   setState(() {
      loading=true;
    });
 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitmanage/modifproduit/${widget.slug}/',);
    var response= await httpIns.put(url,body:{
      'nom':nom,
      'description':description,
      'prix':"$prix",
      "cat_id":"$cat",
      "region_id":"$reg",
      "variation":"$variation",
      "devise_id":"1",
      "poids":poids,
      "unite_mesure_poids":mesure,
    });
 if(response.statusCode==200){
  //  print(response.body);
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
 // ignore: use_build_context_synchronously
 showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Details du produit bien édités.",),
     //  persistent: true,
        );
 }
else{
 // print(response.statusCode);
  setState(() {
    loading=false;
  });
 // ignore: use_build_context_synchronously
 showTopSnackBar(
  context,
  const CustomSnackBar.error(
      message:"Erreur!Echec de la modification .",),
     //  persistent: true,
        );
}
}
Future modifimgvarie(pk) async{
   setState(() {
    loading=true;
  });

try{
   final img= await ImagePicker().pickImage(source: ImageSource.gallery);
  if(img==null) return;

  String filename=img.path.split('/').last;
    FormData formdata=FormData.fromMap(
      {
      'image':await MultipartFile.fromFile(img.path,filename: filename,),
      }
    );
  var id=convert.jsonEncode(pk);
  Dio dio =  Dio();
  var  token= await gettoken();
  dio.options.headers['content-Type'] = 'application/json';
   dio.options.headers["authorization"] = 'Bearer $token';
 var response = (await dio.put('https://gaalguishop.herokuapp.com/api/produit/produitmanage/modifimageproduit/${id}/',
 data: formdata));
 if(response.statusCode==200){
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
  Navigator.of(context).pop();
  showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Image bien modifiée.",),
     //  persistent: true,
    );
  }
else{
setState(() {
    loading=false;
  });
// ignore: use_build_context_synchronously
showTopSnackBar(
    context,
    const CustomSnackBar.error(
    message:"Erreur!Echec de la modification  de l image.",),
     //  persistent: true,
        );
}
 }
 on PlatformException catch(e){
 // print("Pas d autorisation pour utiliser la camera");
 }
}
Future modifdetailimg(index) async{
  setState(() {
      loading=true;
    });
 var id=convert.jsonEncode(produitimage[index]['id']);

 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitmanage/modifimageproduit/${id}/',);
  var response= await httpIns.put(url,body:{
      'size':produitimage[index]['size'],
      'color':produitimage[index]['color'],
      'quantite':'${produitimage[index]['quantite']}'
    });
 if(response.statusCode==200){
  //  print(response.body);
  setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();
 // ignore: use_build_context_synchronously
 Navigator.of(context).pop();
 showTopSnackBar(
    context,
    const CustomSnackBar.success(
    message:"Details  bien édités.",),
     //  persistent: true,
        );
 }
else{
 // print(response.statusCode);
   setState(() {
    loading=false;
    produitimage=[];
  });
 getproduitandimage();

 showTopSnackBar(
  context,
  const CustomSnackBar.error(
      message:"Erreur!Echec de la modification .",),
     //  persistent: true,
        );
}
}
Future<void> showdialogimg( index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child:  Container(
           // margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                ListTile
              (leading: IconButton(onPressed: (){
                modifimgvarie(produitimage[index]['id']);
              }, icon:const  Icon(Icons.camera_alt,color: Colors.black,))),
                Row(
                  children: [
                  Image.network("https://gaalguishop.herokuapp.com${produitimage[index]['image']}",
                  width: 90,
                    height: 90,),
                    const SizedBox(width: 3,),
                    Container(
                      child: Expanded(child: Form(
                        key: varieformkey,
                        child: Column(children: [
                        TextFormField(
                        controller: TextEditingController(text: produitimage[index]['size']),
                         decoration:const  InputDecoration(labelText: 'Taille',),
                         validator: (value){
                          if(value==null||value.isEmpty){
                          return "Entrez un texte valide ";
                          }
                          return null;},
                         onChanged: (value){
                          produitimage[index]['size']=value;
                         },
                         ),
                         TextFormField(
                        controller: TextEditingController(text: produitimage[index]['color']),
                         decoration:const  InputDecoration(labelText: 'Couleur',),
                         validator: (value){
                          if(value==null||value.isEmpty){
                          return "Entrez un texte valide ";
                          }
                          return null;},
                         onChanged: (value){
                        produitimage[index]['color']=value;
                         },
                         ),
                         TextFormField(
                        controller: TextEditingController(text:  "${produitimage[index]['quantite']}"),
                        keyboardType:const  TextInputType.numberWithOptions(),
                         decoration:const  InputDecoration(labelText: 'Quantite disponible',),
                         validator: (value){
                          if(value==null||value.isEmpty){
                          return "Entrez un texte valide ";
                          }
                          return null;},
                         onChanged: (value){
                         produitimage[index]['quantite']=value;
                         }
                         ), 
                     ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
                      child: const  Text('Modifier',style: TextStyle(fontSize: 16),),onPressed: ()  {
                      if (varieformkey.currentState!.validate()){
                        modifdetailimg(index);
                      }
                       } )
                        ],),
                      )),
                    )
                  ],
                ),
              ],
            ),
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
Future suppressionproduit() async{
 var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/produitmanage/supprimer/${widget.slug}/',);
  var response= await httpIns.put(url,);
 if(response.statusCode==200){
 Navigator.of(context).pushNamed('/maboutique');
 }
else{
 
 showTopSnackBar(
  context,
  const CustomSnackBar.error(
      message:"Erreur!Echec de suppresion du produit.",),
     //  persistent: true,
        );
} 
}
  @override
  Widget build(BuildContext context) {
   if(load){
    return  Scaffold(appBar: AppBar(
       backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(icon:const  Icon(Icons.arrow_back_ios,color:Colors.white,),
        onPressed: (){
        Navigator.of(context).pop();
        },),
    ),
    body: !loading? SingleChildScrollView(child:variation?
    modifvariation(formKeyvarie, buildnom, buildprix, builddescription, buildcat,
     buildregion,produitimage,modificationdetail,showdialogimg,suppressionproduit,buildpoids,buildunitemesure)
    :modifsansvariation(buildnom, builddescription, buildprix, buildqte, 
    buildtaille, buildcouleur, buildcat, buildregion, category, region,
     formKeyunique, produitimage, handledetail,suppressionproduitimg,modificationimg,suppressionproduit, context,buildpoids,buildunitemesure) ) 
     :Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
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

Widget modifsansvariation(buildnom, builddescription, buildprix, buildqte, 
    buildtaille, buildcouleur, buildcat, buildregion, category, region,
     formKeyunique, produitimage, handledetail,suppressionproduitimg,modificationimg,
     suppressionproduit,context,buildpoids,buildunitemesure){
  return Container(
  margin: const EdgeInsets.only(left: 2,right: 2),
   child:Column(
     children: [
       Form(
        key: formKeyunique,
        child:Column(
          children:[
            buildnom(),
            builddescription(),
            Row(
              children: [
                Expanded(child: buildprix()),
                const SizedBox(width:5,),
                Expanded(child: buildqte()),
               ],
            ),  
            Row(
              children: [
                Expanded(child: buildtaille()),
                const SizedBox(width:5,),
                Expanded(child: buildcouleur()),
               ], ),  
              
            const SizedBox(height: 5,),
           Row(
          children: [
            Expanded(child: buildpoids()),
            const SizedBox(width:5,),
            Expanded(child: buildunitemesure()),
           ], ),  
        const SizedBox(height: 5,),
            buildcat(),
            const SizedBox(height:5,),
            buildregion(),      
         const SizedBox(height:5,), 
         ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
          child: const  Text('Modifier',style: TextStyle(fontSize: 16),),onPressed: ()  {
           if (formKeyunique.currentState!.validate()){
              handledetail(context);
           }
          
         }, )
          ]
        )
       ),
      produitimage.length==1?
      const  Text("Un produit doit avoir au moins une image",style: TextStyle(color: Colors.red),)
      :Container(),
      GridView.builder(shrinkWrap: true,
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: produitimage.length,
          itemBuilder: (context, index){
          var  prodimg=produitimage[index];
          return Card(
            margin: const EdgeInsets.all(2),
            child: Column(
                  children: [
                    Expanded(
                      child:Image.network("https://gaalguishop.herokuapp.com${prodimg['image']}",
                       width: 150,
                       height: 100,)
                    ),
                 
               Row(
                 children: [
                produitimage.length>1? Expanded(child: IconButton(onPressed: (){
                  suppressionproduitimg(prodimg['id']);
                 }, icon:const  Icon(Icons.delete,size: 12,color: Colors.red,))):Container(),
                 Expanded(child: IconButton(onPressed: (){
                    modificationimg(prodimg['id']);
                    }, icon:const  Icon(Icons.camera_alt,size: 12,color: Colors.blue,)))
                      ],
                    ),
                 
                  ],
                ),
          );
          }
    ),
   ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(238, 9, 9, 1)),),
 child: const  Text('Supprimer le produit',style: TextStyle(fontSize: 16),),onPressed: ()  {
            {
              suppressionproduit();
             }
             }, ) 
          
     ],
   )
  );
}

Widget modifvariation(formKeyvarie, buildnom, buildprix, builddescription, buildcat, buildregion,
produitimage,modificationdetail,showdialogimg,suppressionproduit,buildpoids,buildunitemesure){

  return  Container(
  margin: const EdgeInsets.only(left: 2,right: 2,top: 15),
  child: Column(children: [
    Container(
      margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
      child: Form(
        key: formKeyvarie,
           child:Column(
            children:[
              buildnom(),
              builddescription(),
              buildprix(),
              const SizedBox(height: 5,),
             Row(
          children: [
            Expanded(child: buildpoids()),
            const SizedBox(width:5,),
            Expanded(child: buildunitemesure()),
           ], ),  
        const SizedBox(height: 5,),
              buildcat(),
              const SizedBox(height:5,),
               buildregion(),
              const SizedBox(height:5,), 
              ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
            child: const  Text('Modifier',style: TextStyle(fontSize: 16),),onPressed: ()  {
             if (formKeyvarie.currentState!.validate()){
              modificationdetail();
             }
             }, )
            ]
          )),
    ),
     const SizedBox(height:5,),
      produitimage.length==2?
      const  Text("Un produit doit avoir au minimum  deux variations",style: TextStyle(color: Colors.red),)
      :Container(),
      GridView.builder(shrinkWrap: true,
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: produitimage.length,
          itemBuilder: (context, index){
          var  prodimg=produitimage[index];
          return Card(
            margin: const EdgeInsets.all(2),
            child: Column(
                  children: [
                  Expanded(
                  child:Image.network("https://gaalguishop.herokuapp.com${prodimg['image']}",
                  width: 150,
                  height: 100,)
                    ),
                Row(
                  children: [
                  produitimage.length>2?
                  IconButton(onPressed: (){}, 
                  icon: const Icon(Icons.delete,color: Colors.red,)):Container(),
                  IconButton(onPressed: (){
                    showdialogimg(index);
                  }, 
                  icon: const Icon(Icons.edit,color: Color.fromRGBO(200, 104, 28, 1),)),
                  ],
                )
                 
                  ],
                ),
          );
          }
    ),
 ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(238, 9, 9, 1)),),
 child: const  Text('Supprimer le produit',style: TextStyle(fontSize: 16),),onPressed: ()  {
            {
            suppressionproduit();
             }
             }, )
  
        
     ]),
  
  
  );
  
}