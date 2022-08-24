import 'package:flutter/material.dart';
import 'package:gaalguishop/page/achat.dart';
import 'package:gaalguishop/page/ajoutproduit.dart';
import 'package:gaalguishop/page/boutiquevendeur.dart';
import 'package:gaalguishop/page/boutiquevuclient.dart';
import 'package:gaalguishop/page/commander.dart';
import 'package:gaalguishop/page/compte.dart';
import 'package:gaalguishop/page/confirmationphoneinscription.dart';
import 'package:gaalguishop/page/connexion.dart';
import 'package:gaalguishop/page/detail.dart';
import 'package:gaalguishop/page/detailcommande.dart';
import 'package:gaalguishop/page/inscription.dart';
import 'package:gaalguishop/page/mescommandes.dart';
import 'package:gaalguishop/page/modificationproduit.dart';
import 'package:gaalguishop/page/moyenpayement.dart';
import 'package:gaalguishop/page/notifannulationachat.dart';
import 'package:gaalguishop/page/notifannulationvente.dart';
import 'package:gaalguishop/page/notifavertissement.dart';
import 'package:gaalguishop/page/notifdesactivation.dart';
import 'package:gaalguishop/page/notifetatcommande.dart';
import 'package:gaalguishop/page/notifnotevendeur.dart';
import 'package:gaalguishop/page/notifproduitfollower.dart';
import 'package:gaalguishop/page/notifreactivation.dart';
import 'package:gaalguishop/page/notifvente.dart';
import 'package:gaalguishop/page/pagemeilleurvendeur.dart';
import 'package:gaalguishop/page/pageoccasion.dart';
import 'package:gaalguishop/page/panier.dart';
import 'package:gaalguishop/page/produitunecategorie.dart';
import 'package:gaalguishop/page/recherche.dart';
import 'package:gaalguishop/page/recucommande.dart';
import 'package:gaalguishop/page/verificationphonepay.dart';
import '../page/accueil.dart';
import '../page/notification.dart';





class RouteGenerator  {
 
  static Route<dynamic> generateRoute(RouteSettings settings) {
   final  args=settings.arguments;
    switch (settings.name) {
      case '/': 
        return(MaterialPageRoute(builder: (_) => const Accueil()));
      case '/panier': 
        return(MaterialPageRoute(builder: (_) => const Panier()));
      case '/login': 
        return(MaterialPageRoute(builder: (_) => const Connection ()));
      case '/compte': 
        return(MaterialPageRoute(builder: (_) => const Compte ()));
      case '/inscription': 
        return(MaterialPageRoute(builder: (_) => const Inscription ()));
      case '/confirmationphoneinscription': 
        return(MaterialPageRoute(builder: (_) => ConfirmationPhoneInscription (args)));  
      case '/produitunecategorie': 
        return(MaterialPageRoute(builder: (_) =>  ProduitUneCategorie(args)));
      case '/detail': 
        return(MaterialPageRoute(builder: (_) =>  Detail(args)));
      case '/boutiquevu': 
        return(MaterialPageRoute(builder: (_) =>  BoutiqueVuClient(args)));
      case '/maboutique': 
        return(MaterialPageRoute(builder: (_) => const MaBoutique()));
      case '/ajoutproduit': 
        return(MaterialPageRoute(builder: (_) => const AjoutProduit()));
      case '/modificationproduit': 
        return(MaterialPageRoute(builder: (_) => ModificationProduit(args)));
      case '/recherche': 
        return(MaterialPageRoute(builder: (_) => Recherche(args)));
      case '/notification': 
        return(MaterialPageRoute(builder: (_) =>  const Notif()));
      case '/notifannulationachat': 
        return(MaterialPageRoute(builder: (_) =>  NotificationAnulationAchat(args)));
      case '/notifannulationvente': 
        return(MaterialPageRoute(builder: (_) =>  NotificationAnnulationVente(args)));
      case '/notifavertissement': 
        return(MaterialPageRoute(builder: (_) =>  NotificationAvertissement(args)));
      case '/notifdesactivation': 
        return(MaterialPageRoute(builder: (_) =>  NotificationDesactivation(args)));
      case '/notifetatcommande': 
        return(MaterialPageRoute(builder: (_) =>  NotificationEtatCommande(args)));
      case '/notifnotevendeur': 
        return(MaterialPageRoute(builder: (_) =>  NotificationNoteVendeur(args)));
      case '/notifreactivation': 
        return(MaterialPageRoute(builder: (_) =>  NotificationReactivation(args)));
      case '/notifollower': 
        return(MaterialPageRoute(builder: (_) => NotificationFollower(args)));
      case '/notifvente': 
        return(MaterialPageRoute(builder: (_) =>  NotificationVente(args)));
      case '/verificationphonepay': 
        return(MaterialPageRoute(builder: (_) =>  VerificationPhonePay(args)));
      case '/recucommande': 
        return(MaterialPageRoute(builder: (_) =>  RecuCommande(args)));
      case '/commander': 
        return(MaterialPageRoute(builder: (_) =>  Commander(args)));
      case '/mescommandes': 
        return(MaterialPageRoute(builder: (_) => const MesCommandes()));
      case '/achat': 
        return(MaterialPageRoute(builder: (_) => const Achat()));
      case '/detailcommande': 
        return(MaterialPageRoute(builder: (_) =>  DetailCommande(args)));
      case '/occasion': 
        return(MaterialPageRoute(builder: (_) => const PageOccasion()));
      case '/meilleurvendeur': 
        return(MaterialPageRoute(builder: (_) => const PageMeilleurVendeur()));
       case '/moyendepayement': 
        return(MaterialPageRoute(builder: (_) => const MoyenPayement()));
      
      
        

      
      
      

      
      

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }

  }
}