import 'dart:convert'; // ✅ Required for utf8, base64Encode, jsonDecode, and jsonEncode
import 'package:http/http.dart' as http; // ✅ Required for API calls

class MpesaService {
  static const String consumerKey = "CgMkfMHV4CinNuHQHISTO2XFmAmaTgG8JknX1F5TlAokdPuo";
  static const String consumerSecret = "4TXv9QPYe4XmXYnnIwy6ZLrrI3k1KFINrNjzRWiU2EGKL6UMutXxvteLZyMoPmn0";
  static const String shortcode = "0700088271"; // Replace with actual PayBill or Till Number
  static const String passkey = "YOUR_PASSKEY"; // Replace with actual Daraja PassKey
  static const String callbackUrl = "https://yourdomain.com/callback"; // Must be HTTPS
  static const String baseUrl = "https://sandbox.safaricom.co.ke";

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
    String password = base64Encode(utf8.encode("$shortcode$passkey$timestamp"));

    // 🔹 Create API Request
    Map<String, dynamic> requestData = {
      "BusinessShortCode": shortcode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": 20, // Change amount if needed
      "PartyA": phoneNumber,
      "PartyB": shortcode,
      "PhoneNumber": phoneNumber,
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
