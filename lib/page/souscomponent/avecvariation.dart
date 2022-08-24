import 'package:flutter/material.dart';



Widget avecvariation(buildnomvarie,builddescriptionvarie,buildprivarie,buildcatvarie,buildregionvarie,
handleimgvarie,formKeyvarie,handlesubmitvarie,buildpoidsvarie,buildunitemesurevarie,context){


  return Container(
  margin: const EdgeInsets.only(left: 2,right: 2),
  child: Form(
    key: formKeyvarie,
    child: Column(children: [
      const   Text('Ajouter les images du produit',
      style:  TextStyle(color:  Color.fromRGBO(200, 104, 28, 1)),),
       IconButton(
       onPressed: (){
       handleimgvarie();
          },
       icon:const  Icon(Icons.camera_alt),
       ),
      buildnomvarie(),
      buildprivarie(),
      builddescriptionvarie(),
        Row(
          children: [
            Expanded(child:buildpoidsvarie()),
            const SizedBox(width:5,),
            Expanded(child: buildunitemesurevarie()),
           ], ),  
        const SizedBox(height: 5,),
      buildcatvarie(),
      buildregionvarie(),
       ElevatedButton( style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(200, 104, 28, 1)),),
        child: const  Text('Ajouter',style: TextStyle(fontSize: 16),),onPressed: ()  {
       if (formKeyvarie.currentState!.validate()){
         // print("oy");
           handlesubmitvarie(context);
       }
        ;
       }, )
    ],),
  ),
  
  
  );



}