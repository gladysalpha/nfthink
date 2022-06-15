import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nfthink/user.dart';

class ApiHelper {
  static const String kApiUrl = "https://onurgozcu.com/nfthink/api/";
  static const Map<String, String> kHeaders = {
    "Authorization": "Bearer xxx",
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  //For search page -- returns all verified NFTs including searchKey from database
  static Future<List> getAllNft(String searchKey) async {
    return await http
        .post(
      Uri.parse(kApiUrl + "nft/getAll"),
      body: {
        "searchKey": searchKey,
        "deviceId": User().getDeviceId(),
      },
      headers: kHeaders,
    )
        .then((value) {
      return jsonDecode(value.body)["nfts"];
    });
  }

  //For main page content -- user specific (specified by deviceId) -- returns only user's mainpage content
  static Future<List> getAllNftByDeviceId() async {
    return await http
        .get(
      Uri.parse(
          kApiUrl + "nft/getAllByDeviceId?deviceId=${User().getDeviceId()}"),
      headers: kHeaders,
    )
        .then((value) {
      return jsonDecode(value.body)["nfts"];
    });
  }

  //For DetailedNftView -- returns Map<dynamic> for NFT's details
  static Future<Map> getDetailedNftInfo({
    required int nftId,
  }) async {
    return await http
        .get(
      Uri.parse(kApiUrl + "nft/getDetailedInfo?nftId=$nftId"),
      headers: kHeaders,
    )
        .then((value) {
      return jsonDecode(value.body)["nft"];
    });
  }

  //For adding NFT to user's MainPage, Ones you do it, the NFT returns with getAllNftByDeviceId
  static Future<bool> addNftToMainPage({
    required int nftId,
  }) async {
    return await http
        .post(
      Uri.parse(kApiUrl +
          "nft/addNftToMainPage?deviceId=${User().getDeviceId()}&nftId=$nftId"),
      headers: kHeaders,
    )
        .then((value) {
      return jsonDecode(value.body)["success"];
    });
  }

  //For sending reliability score calculation request with current data and writing it to database
  static Future<bool> calculatePoints() async {
    return await http
        .patch(
      Uri.parse(kApiUrl + "nft/calculatePoints"),
      headers: kHeaders,
    )
        .then((value) {
      return jsonDecode(value.body)["success"];
    });
  }
}
