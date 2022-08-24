// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:gaalguishop/page/souscomponent/avecvariation.dart';
import 'package:gaalguishop/page/souscomponent/sansvariation.dart';
import 'package:flutter/services.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum Variation { sans, avec }
class AjoutProduit extends StatefulWidget {
  const AjoutProduit({super.key});

  @override
  State<AjoutProduit> createState() => _AjoutProduitState();
}

class _AjoutProduitState extends State<AjoutProduit> {
var httpIns=HttpInstance();
List<Map<String, dynamic>> category=[] ;
 List  imagedispayunique=[] ;
 List  tablevarie=[] ;
 bool loading=false;
final formKeyunique = GlobalKey<FormState>();
List<Map<String, dynamic>> region=[] ;
final formKeyvarie = GlobalKey<FormState>();
final varieformkey = GlobalKey<FormState>();
final  platform =  const MethodChannel("gaalguishop.native.com/auth");

 Variation? nature = Variation.sans;
 late bool load;
 var nomunique;
 var prixunique;
 var taille;
 var qte;
 var couleur;
 var poids;
 var mesure;
 var descriptionunique;
 var catunique;
 var regionunique;
 var nomvarie;
 var prixvarie;
 var descriptionvarie;
 var catvarie;
 var regionvarie;
  var poidsvarie;
 var mesurevarie;
 
 Future getdeviselocationcategory() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/deviselocationcategory/',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
 // print(result.body); 
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
Widget buildnom(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Nom du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         nomunique=value;
       //  print(value);
       },
       );
    }
  Widget buildnomvarie(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Nom du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         nomvarie=value;
       //  print(value);
       },
       );
    }
   Widget builddescription(){
    return  TextFormField(
       maxLines: 3,
       decoration:const  InputDecoration(labelText: 'Description du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         descriptionunique=value;
        // print(value);
       },
       );
       
   }
  Widget builddescriptionvarie(){
    return  TextFormField(
       maxLines: 3,
       decoration:const  InputDecoration(labelText: 'Description du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
       onChanged: (value){
         descriptionvarie=value;
        // print(value);
       },
       );
       
   }
   Widget buildprix(){
    return  TextFormField(
         keyboardType:const  TextInputType.numberWithOptions(decimal: true,
          signed: false,),
         inputFormatters:<TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
         ],
         decoration:const  InputDecoration(labelText: 'Prix du produit ',),
         validator: (value){
          if(value==null||value.isEmpty){
          return "Entrez un nombre valide ";
          }
          return null;},
         onChanged: (value){
           prixunique=value;
          // print(value);
         },
    );
      
   }
   Widget buildpoids(){
    return  TextFormField(
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
    child: Text(label),
     ))
    .toList(), 
  onChanged: (value){
   mesure=value;
    // print(value);
       },
   );
  }
   Widget buildpoidsvarie(){
    return  TextFormField(
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
           poidsvarie=value;
          // print(value);
         },
    );}
  buildunitemesurevarie(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Unité de mesure",),
    items: ["g","kg"]
   .map((label) => DropdownMenuItem(
    value: label,
    child: Text(label),
     ))
    .toList(), 
  onChanged: (value){
   mesurevarie=value;
    // print(value);
       },
   );
  }
   Widget buildprivarie(){
    return  TextFormField(
       inputFormatters:<TextInputFormatter>[
       FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
         ],
       keyboardType:const  TextInputType.numberWithOptions(decimal: true,
        signed: false,),
       decoration:const  InputDecoration(labelText: 'Prix du produit ',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un nombre valide ";
        }
        return null;},
       onChanged: (value){
         prixvarie=value;
        // print(value);
       },
       );
      
   }
   Widget buildtaille(){
    return  TextFormField(
       decoration:const  InputDecoration(labelText: 'Taille du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
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
       decoration:const  InputDecoration(labelText: 'Couleur du produit',),
       validator: (value){
        if(value==null||value.isEmpty){
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
        keyboardType:const  TextInputType.numberWithOptions(decimal: true,
        signed: false,),
       decoration:const  InputDecoration(labelText: 'Quantite disponible',),
       validator: (value){
        if(value==null||value.isEmpty){
        return "Entrez un texte valide ";
        }
        return null;},
      onChanged: (value){
         qte=value;
        // print(value);
       },
       );
       
   }

buildcat(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Categorie",),
    items: category
          .map<DropdownMenuItem<String>>((cat) {
        return DropdownMenuItem<String>(
          value: cat['id'].toString(),
          child: Text(cat['category']),
        );
      }).toList(),
    
  onChanged: (value){
   catunique=value;
    // print(value);
       },
   );
  }
buildcatvarie(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Categorie",),
    items: category
          .map<DropdownMenuItem<String>>((cat) {
        return DropdownMenuItem<String>(
          value: cat['id'].toString(),
          child: Text(cat['category']),
        );
      }).toList(),
    
  onChanged: (value){
   catvarie=value;
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
          child: Text(re['region']),
        );
      }).toList(),
    
   onChanged: (value){
     regionunique=value;
      // print(value);
       }, 
   );
  }
buildregionvarie(){
  return DropdownButtonFormField(
    decoration: const InputDecoration(labelText: "Region",),
    items:region
          .map<DropdownMenuItem<String>>((re) {
        return DropdownMenuItem<String>(
          value:re['id'].toString(),
          child: Text(re['region']),
        );
      }).toList(),
    
   onChanged: (value){
     regionvarie=value;
      // print(value);
       }, 
   );
  }
Future handleimgunique() async{
    try{
   final List<XFile>? img= await ImagePicker().pickMultiImage(maxHeight: 200,maxWidth:250);
  if(img==null) return;
    var nbreimg=img.length+imagedispayunique.length;
    if(img.length<=10||nbreimg<=10){
      setState(()=>{
      imagedispayunique.addAll(img)
    });
    }
  return;
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
Future handleimgvarie() async{
    try{
   final img= await ImagePicker().pickImage(source: ImageSource.gallery);
  if(img==null) return; 
    showdialogimage(img) ; 
  return;
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
@override
void initState (){
  getdeviselocationcategory();
  setState(() {
    load=true;
  });

  super.initState();
}
Future<String> gettoken() async{
   var token=await platform.invokeMethod('getoken');
   return token;
   }
Future handlesubmitunique(context) async{
  // ignore: prefer_is_empty
  setState(() {
    loading=true;
  });
  if(imagedispayunique.isEmpty||imagedispayunique.length>10){
    showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Erreur!Vous devez ajouter une photo au minimum et 10 au maximum.",),
     //  persistent: true,
        );
     setState(() {
    loading=false;
  });
    return;
  }
  if(nomunique==""||descriptionunique==""||prixunique==""||double.parse(prixunique)<=0||taille==""||qte==""||
  int.parse(qte)<=0||catunique==""||regionunique==""||couleur==""){
    showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Erreur!Veuilez normalement remplir tous les champs",),
     //  persistent: true,
        );
     setState(() {
    loading=false;
  });
    return;
  }
  else{
 Dio dio =  Dio();
   String filename=imagedispayunique[0].path.split('/').last;
    FormData formdata=FormData.fromMap(
      {
      'nom':nomunique,
      'description':descriptionunique,
      'prix':prixunique,
      "cat_id":catunique,
      "region_id":regionunique,
      "variation":false,
      "devise_id":1,
      "taille":taille,
      "couleur":couleur,
      "qte":qte,
      "poids":poids,
      "unite_mesure_poids":mesure,
      "thumbnail":await MultipartFile.fromFile(imagedispayunique[0].path,filename: filename,), 
      }
    );
 
  var  token= await gettoken();
  dio.options.headers['content-Type'] = 'application/json';
   dio.options.headers["authorization"] = 'Bearer $token';
 var response = (await dio.post('https://gaalguishop.herokuapp.com/api/produit/ajoutdetailproduit/',
 data: formdata));
 if(response.statusCode==200){
  // print(response.data['id']);
for(int i=0;i<imagedispayunique.length;i++){
 String imgname=imagedispayunique[i].path.split('/').last; 
 FormData data=FormData.fromMap(
      {
      'image':await MultipartFile.fromFile(imagedispayunique[i].path,filename: imgname,),
      'id':response.data['id']
      });
var result=(await dio.post('https://gaalguishop.herokuapp.com/api/produit/ajoutimageproduit/',
 data: data));
if(result.statusCode==200){
  
}
Navigator.of(context).pushNamedAndRemoveUntil('/maboutique', (Route route) => false);
}
}
else{
   setState(() {
    loading=false;
  });
  const CustomSnackBar.error(
      message:"Erreur!produit non ajouté"
     //  persistent: true,
        );
    return;
}
  }
  
}

Future handlesubmitvarie(context) async{
   setState(() {
    loading=true;
  });
  if(tablevarie.length<2||tablevarie.length>10){
    showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Erreur!Vous devez ajouter deux variations du produit  au minimum et 10 au maximum.",),
     //  persistent: true,
        );
     setState(() {
    loading=false;
  });
    return;
  }
  if(nomvarie==""||descriptionvarie==""||prixvarie==""||double.parse(prixvarie)<=0||catvarie==""||
  regionvarie==""){
    showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Erreur!Veuilez normalement remplir tous les champs",),
     //  persistent: true,
        );
     setState(() {
    loading=false;
  });
    return;
  }
  for(int i=0;i<tablevarie.length;i++){
    if(tablevarie[i].color==""||tablevarie[i].quantite==""||tablevarie[i].size==""||int.parse(tablevarie[i].quantite)<=0){
     showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Erreur!Veuilez normalement remplir tous les champs",),
     //  persistent: true,
        );
     setState(() {
    loading=false;
  });
    return; 
    }
  }
 Dio dio =  Dio();
 String filename=tablevarie[0].image.path.split('/').last;
  FormData formdata=FormData.fromMap(
      {
      'nom':nomvarie,
      'description':descriptionvarie,
      'prix':prixvarie,
      "cat_id":catvarie,
      "region_id":regionvarie,
      "variation":true,
      "devise_id":1,
      "poids":poidsvarie,
      "unite_mesure_poids":mesurevarie,
      "thumbnail":await MultipartFile.fromFile(tablevarie[0].image.path,filename: filename,), 
      }
    );
  var  token= await gettoken();
  dio.options.headers['content-Type'] = 'application/json';
   dio.options.headers["authorization"] = 'Bearer $token';
 var response = (await dio.post('https://gaalguishop.herokuapp.com/api/produit/ajoutdetailproduit/',
 data: formdata));
 if(response.statusCode==200){
  for(int i=0;i<tablevarie.length;i++){
    String imgname=tablevarie[i].image.path.split('/').last; 
 FormData data=FormData.fromMap(
      {
      'image':await MultipartFile.fromFile(tablevarie[i].image.path,filename: imgname,),
      'id':response.data['id'],
      'size':tablevarie[i].size,
      'quantite':tablevarie[i].quantite,
      'color':tablevarie[i].color
      });
var result=(await dio.post('https://gaalguishop.herokuapp.com/api/produit/ajoutimageproduit/',
 data: data));
 if(result.statusCode==200){

 }
  }
Navigator.of(context).pushNamedAndRemoveUntil('/maboutique', (Route route) => false);
 }
else{
  showTopSnackBar(
      context,
     const CustomSnackBar.error(
      message:"Oups! Une erreur est survenue,veuillez réessayer ultérieurement",),
     //  persistent: true,
        );
}
}
Future<void> showdialogimage(image) async {
   var imgvarie=datavarie();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
       // insetPadding:const  EdgeInsets.all(3),
        child: SingleChildScrollView(
          child:Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Image.file(File(image.path),
                width: 90,
                height: 90,),
                Container(
                  child: Expanded(child: Form(
                    key: varieformkey,
                    child: Column(children: [
                    TextFormField(
                     decoration:const  InputDecoration(labelText: 'Taille',),
                     validator: (value){
                      if(value==null||value.isEmpty){
                      return "Entrez un texte valide ";
                      }
                      return null;},
                     onChanged: (value){
                      imgvarie.size=value;
                     },
                     ),
                     TextFormField(
                     decoration:const  InputDecoration(labelText: 'Couleur',),
                     validator: (value){
                      if(value==null||value.isEmpty){
                      return "Entrez un texte valide ";
                      }
                      return null;},
                     onChanged: (value){
                     imgvarie.color=value;
                     },
                     ),
                     TextFormField(
                      keyboardType:const  TextInputType.numberWithOptions(),
                     decoration:const  InputDecoration(labelText: 'Quantite disponible',),
                     validator: (value){
                      if(value==null||value.isEmpty){
                      return "Entrez un texte valide ";
                      }
                      return null;},
                     onChanged: (value){
                      imgvarie.quantite=value;
                     }
                     ), 
                 ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
                  child: const  Text('Ajouter',style: TextStyle(fontSize: 16),),onPressed: ()  {
                  if (varieformkey.currentState!.validate()){
                    setState(() {
                     imgvarie.image=image;
                     tablevarie.add(imgvarie); });
                     Navigator.of(context).pop();
                 }
        
       }, )
                    ],),
                  )),
                )
              ],
            ),
          ) 

        
       ) );
    },
  );
}

@override
  Widget build(BuildContext context) {
    if(load){
      return Scaffold(
      appBar: AppBar(
        backgroundColor:const  Color.fromARGB(200, 104, 28, 1),
        leading: IconButton(
        icon:const  Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body:!loading? SingleChildScrollView(child:
       Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(children: [
         ListTile(
          title: const Text('Produit sans variation (taille et couleur unique)'),
          leading: Radio<Variation>(
            value: Variation.sans,
            groupValue:nature,
            onChanged: (Variation? value) {
              setState(() {
               nature = value;
               // print(value);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Produit avec des variations (tailles et/ou couleurs variées)'),
          leading: Radio<Variation>(
            value: Variation.avec,
            groupValue: nature,
            onChanged: (Variation? value) {
              setState(() {
               nature = value;
              // print(value);
              });
            },
          ),
        ),
         imagedispayunique.isNotEmpty && nature==Variation.sans?
        GridView.builder(
          shrinkWrap: true,
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: imagedispayunique.length,
          itemBuilder: 
        ((context, index){
          return Container(
            margin: const EdgeInsets.only(top: 5,bottom: 5),
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.file(
                       File( imagedispayunique[index].path),
                        width: 150,
                        height: 100,
                      ),
                  ),
               // const   SizedBox(height: 5,width: 5,),
                  Expanded(child: IconButton(onPressed: (){
                    setState(() {
                      imagedispayunique.removeAt(index);
                    //  print(imagedispayunique.length);
                    });
                  }, icon:const  Icon(Icons.delete,size: 12,)))
                ],
              ),
            ),
          )
          ;
        })
      ):Container(), 
      tablevarie.isNotEmpty && nature==Variation.avec?
       GridView.builder(
          shrinkWrap: true,
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          itemCount: tablevarie.length,
          itemBuilder: 
        ((context, index){
          return Container(
            margin: const EdgeInsets.all(3),
            child: Card(
              elevation: 5,
              child: Row(
                children: [
                Expanded(
                  child: Image.file(
                       File( tablevarie[index].image.path),
                        width: 100,
                        height: 100,
                      ),
                ),
                Expanded(child: Column(children: [
                 Text("couleur: ${tablevarie[index].color}"),
                 const   SizedBox(height: 5,),
                 Text("Taille: ${tablevarie[index].size}"),
                 const   SizedBox(height: 5,),
                 Text("quantité: ${tablevarie[index].quantite}"),
                 const   SizedBox(height: 5,),
                 IconButton(onPressed: (){
                    setState(() {
                      tablevarie.removeAt(index);
                    //  print(imagedispayunique.length);
                    });
                  }, icon:const  Icon(Icons.delete,size: 12,))

                ],))
                  
                ],
              ),
            ),
          );
        })
      ):Container(),  
      nature==Variation.sans?
      sansvariation(buildnom,builddescription,buildprix,buildqte,buildtaille,buildcouleur
     ,buildcat,buildregion,category,region,formKeyunique,handleimgunique,imagedispayunique,
      handlesubmitunique,buildpoids,buildunitemesure,context):
      avecvariation(buildnomvarie,builddescriptionvarie,buildprivarie,buildcatvarie,buildregionvarie,
handleimgvarie,formKeyvarie,handlesubmitvarie,buildpoidsvarie,buildunitemesurevarie,context)
        ],),
      )):
    Container(
      decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitHourGlass(
     color: Color.fromARGB(200, 104, 28, 1),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
    ) 
    ));
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

class datavarie{
  var index;
  var size;
  var color;
  var quantite;
  var image;
}