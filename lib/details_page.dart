import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfthink/api_helper.dart';

class NftDetailsPage extends StatefulWidget {
  const NftDetailsPage({Key? key, required this.nftId}) : super(key: key);
  final int nftId;

  @override
  State<NftDetailsPage> createState() => _NftDetailsPageState();
}

class _NftDetailsPageState extends State<NftDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B51A0),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF627BDD),
        title: const Text("Search NFTs"),
      ),
      body: FutureBuilder<Map>(
          future: ApiHelper.getDetailedNftInfo(nftId: widget.nftId),
          builder: (context, nftDetails) {
            if (!nftDetails.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    imageUrl: nftDetails.data!["nft_photo"],
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                    placeholder: (context, imageUrl) {
                      return Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                    errorWidget: (context, imageUrl, error) {
                      return Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 48.0,
                        child: Text(
                          nftDetails.data!["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAD0E4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black54,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            nftDetails.data!["point"].toString(),
                            style: const TextStyle(
                              color: Color(0xFF20D982),
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 84.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Avg Price",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                nftDetails.data!["average_price_24h"]
                                        .toStringAsFixed(2) +
                                    " SOL",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 84.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Volume",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                nftDetails.data!["volume_all"]
                                        .toStringAsFixed(2) +
                                    " SOL",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 84.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Floor Price",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                nftDetails.data!["floor_price"]
                                        .toStringAsFixed(2) +
                                    " SOL",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 84.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Listed Count",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                nftDetails.data!["listed_count"].toString() +
                                    " NFTs",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 55.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAD0E4),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black54,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 12.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8292E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.discord,
                                    color: Colors.white,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 14.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nftDetails.data!["discord_member_count"]
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        nftDetails.data![
                                                "discord_online_member_count"]
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Container(
                                        height: 6.0,
                                        width: 6.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 55.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAD0E4),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black54,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 12.0,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.lightBlue,
                                size: 30.0,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                nftDetails.data!["twitter_follower_count"]
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
