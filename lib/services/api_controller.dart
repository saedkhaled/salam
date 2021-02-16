
import 'package:http/http.dart' as http;

class ApiController {

  static Future<String> get(String url) async{
    print('request     '+ url);
    String response = (await http.get(url)).body;
    print('response    ' + response);
    return response;
  }

}