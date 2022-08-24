import 'package:flutter/material.dart';
import 'package:badges/badges.dart';






Widget myappbar(context,badge,islog,showdialogconnexion){
  
  return AppBar(
    backgroundColor:Colors.transparent,
     elevation: 0,
     automaticallyImplyLeading: false,
     title:islog? ListTile(
      selectedColor: Colors.white,
     leading:const  Icon(
     Icons.search,
     color: Colors.black,
     size: 28,), 
     title:  TextField(
     decoration: const InputDecoration(labelText: "Recherche",
     border: InputBorder.none,
     
     ),
     onSubmitted: (value){
       handlesearch(value,context);
     },
      ),
      trailing:badge==0? GestureDetector(
        onTap: (){Navigator.of(context).pushNamed('/panier');},
        child: const  Icon(Icons.shopping_cart,color: Colors.black), )
      :GestureDetector(
        onTap: (){Navigator.of(context).pushNamed('/panier');},
        child: Badge(
          elevation: 0,
          alignment: Alignment.topLeft,
          badgeContent: Text('$badge',style: const TextStyle(color:Colors.white)),
          child: const  Icon(Icons.shopping_cart,color: Colors.black),

        )
      )
      ): 
  ListTile(
      selectedColor: Colors.white,
     leading:const  Icon(
     Icons.search,
     color: Colors.black,
     size: 28,), 
     title:  TextField(
     decoration: const InputDecoration(labelText: "Recherche",
     border: InputBorder.none,
     
     ),
     onSubmitted: (value){
       handlesearch(value,context);
     },
      ),
      
      trailing: GestureDetector(
        onTap: (){showdialogconnexion();},
        child: const  Icon(Icons.shopping_cart,color: Colors.black), )
     
      )  
  );
}



 myappbarpage(context){
  
  return  AppBar(
       automaticallyImplyLeading: false,
       backgroundColor: const Color.fromRGBO(200, 104, 28, 1),
       leading: IconButton(
        icon:const  Icon(Icons.arrow_back_ios),color: Colors.white,
        onPressed: (){Navigator.of(context).pop();
        },),
      );
}

Future handlesearch(mot,context) async{
//  print(mot);
 Navigator.of(context).pushNamed('/recherche',arguments: mot);
}
