import 'package:flutter/material.dart';



Widget sansvariation( buildnom,builddescription,buildprix,buildqte,buildtaille,buildcouleur
     ,buildcat,buildregion,category,region,formKeyunique,handleimgunique,imagedispayunique,
      handlesubmitunique,buildpoids,buildunitemesure,context){
  
  return Container(
  margin: const EdgeInsets.only(left: 2,right: 2),
   child:Form(
    key: formKeyunique,
    child:Column(
      children:[ 
    imagedispayunique.isEmpty?  const   Text('Ajouter les images du produit',
      style:  TextStyle(color:  Color.fromRGBO(200, 104, 28, 1)),):Container(),
      imagedispayunique.length<10?
        IconButton(
        onPressed: (){
          handleimgunique();
        },
        icon:const  Icon(Icons.camera_alt),
      ):Container(),
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
      child: const  Text('Ajouter',style: TextStyle(fontSize: 16),),onPressed: ()  {
       if (formKeyunique.currentState!.validate()){
          handlesubmitunique(context);
       }
      ;
     }, )
      ]
    )
   )
  );
}


/*
 <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),*/