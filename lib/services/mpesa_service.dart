import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  static const String consumerKey = "CgMkfMHV4CinNuHQHISTO2XFmAmaTgG8JknX1F5TlAokdPuo"; 
  static const String consumerSecret = "4TXv9QPYe4XmXYnnIwy6ZLrrI3k1KFINrNjzRWiU2EGKL6UMutXxvteLZyMoPmn0"; 
  static const String tillNumber = "3239738"; // Your actual Buy Goods Till Number
  static const String passkey = "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"; 
  static const String callbackUrl = " https://3921-2c0f-fe38-2335-6b18-79f0-1472-695e-b784.ngrok-free.app"; // Must be HTTPS
  static const String baseUrl = "https://sandbox.safaricom.co.ke"; // Change to "https://api.safaricom.co.ke" for live

  // 🔹 Get OAuth Token
  static Future<String?> _getAccessToken() async {
    String credentials = base64Encode(utf8.encode("$consumerKey:$consumerSecret"));

    var response = await http.get(
      Uri.parse("$baseUrl/oauth/v1/generate?grant_type=client_credentials"),
      headers: {"Authorization": "Basic $credentials"},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("✅ Access Token: ${jsonResponse['access_token']}");
      return jsonResponse["access_token"];
    } else {
      print("❌ Error Getting Token: ${response.body}");
      return null;
    }
  }

  // 🔹 Initiate STK Push
  static Future<void> initiatePayment(String phoneNumber) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      print("❌ Access Token is NULL. Exiting...");
      return;
    }

    // 🔹 Ensure phone number is in 2547XXXXXXXX format
    if (!phoneNumber.startsWith("254")) {
      phoneNumber = "254${phoneNumber.substring(1)}";
    }

    // 🔹 Generate Timestamp
    DateTime now = DateTime.now();
    String timestamp = "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}";

    // 🔹 Encode Password
    String password = base64Encode(utf8.encode("$tillNumber$passkey$timestamp"));

    // 🔹 Create API Request
    Map<String, dynamic> requestData = {
      "BusinessShortCode": 3239738,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerBuyGoodsOnline", // ✅ Correct Transaction Type for Buy Goods
      "Amount": 20,
      "PartyA": 254700088271,
      "PartyB": 3239738, // ✅ Ensure this is the correct Buy Goods Till Number
      "PhoneNumber": 254700088371,
      "CallBackURL": callbackUrl,
      "AccountReference": "FundiSmart",
      "TransactionDesc": "Unlock Handyman Contact"
    };

    // 🔹 Send STK Push Request
    var response = await http.post(
      Uri.parse("$baseUrl/mpesa/stkpush/v1/processrequest"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode(requestData),
    );

    // 🔹 Handle Response
    if (response.statusCode == 200) {
      print("✅ STK Push Sent Successfully: ${response.body}");
    } else {
      print("❌ Error Sending STK Push: ${response.body}");
    }
  }

  // 🔹 Helper Function to Format Timestamp
  static String _twoDigits(int n) {
    return n >= 10 ? "$n" : "0$n";
  }
}
