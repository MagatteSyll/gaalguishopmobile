package com.example.gaalguishop
import android.content.SharedPreferences
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val channel="gaalguishop.native.com/auth";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val authChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)

        authChannel.setMethodCallHandler{
                call,result ->
            if (call.method =="getoken") {
                val  sharedPref =getSharedPreferences("connexion", MODE_PRIVATE);
                val  jmpp  =sharedPref.getString("jmpp","pas de token");
                result.success(jmpp)
            }
            if(call.method =="setoken") {
                val arg= call.arguments()  as Map<String, String>?
                val jmpp= arg?.get("jmpp");
                val jvlf= arg?.get("jvlf");
                val sharedPref = getSharedPreferences("connexion", MODE_PRIVATE);
                val editor:SharedPreferences.Editor=sharedPref.edit();
                editor.apply{
                    putString("jmpp",jmpp)
                    putString("jvlf", jvlf) }
                editor.commit()
                val  resultat =sharedPref.getString("jmpp",null);
                result.success(resultat);


            }
            if(call.method =="deconnexion")
            {
                val  sharedPref =getSharedPreferences("connexion", MODE_PRIVATE);
                sharedPref.edit().remove("jmpp").commit()
                sharedPref.edit().remove("jvlf").commit()
                result.success("success remove key")
            }

            else {
                result.notImplemented()
            }

        }
    }
}


