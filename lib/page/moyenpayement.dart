import 'package:flutter/material.dart';



class MoyenPayement extends StatefulWidget {
  const MoyenPayement({super.key});

  @override
  State<MoyenPayement> createState() => _MoyenPayementState();
}

class _MoyenPayementState extends State<MoyenPayement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
        leading: IconButton(
        icon:const  Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){
         Navigator.of(context).pop();
          },),
        ),
      body: SingleChildScrollView(child: 
      Container(
        margin: const EdgeInsets.only(top: 20,left: 5,right: 5),
        child: Column(children: [
          Container(
            child: Text('A travers GaalguiMoney , vous payez vos achats en toute sécurité '),
          )
        ],),
      )),
    );
  }
}