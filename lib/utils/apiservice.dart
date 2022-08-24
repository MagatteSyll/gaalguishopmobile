import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;



  
class HttpInstance extends http.BaseClient{
  static const platform =  MethodChannel("gaalguishop.native.com/auth");
  final  _inner=http.Client();
  
  Future<String> gettoken() async{
   var token=await platform.invokeMethod('getoken');
   return token;
   }
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // intercept each call and add the Authorization header if token is available
   var  token= await gettoken();
   if(token!="pas de token"){
    request.headers['Authorization'] ='Bearer $token';
   //request.headers['Content-type'] = 'application/json';
  // request.headers['Accept'] = 'application/json';
   }
 // print(token);
 
  

  return _inner.send(request);
  }


}