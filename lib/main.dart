import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfthink/api_helper.dart';
import 'package:nfthink/details_page.dart';
import 'package:nfthink/fade_route.dart';
import 'package:nfthink/search_page.dart';
import 'package:nfthink/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await User().fetchDeviceId();
  await ApiHelper.calculatePoints();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nfthink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB5BBBE),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF627BDD),
        title: const Text("NFThink"),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
          future: ApiHelper.getAllNftByDeviceId(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeRoute(
                          page: NftDetailsPage(
                            nftId: snapshot.data![index]["id"],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 44.0,
                            decoration: BoxDecoration(
                                color: const Color(0xFF3B51A0),
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    snapshot.data![index]["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70.0),
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.5),
                                    thickness: 1.3,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                    vertical: 20.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 110.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 12.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFF8292E9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      child: Icon(
                                                        Icons.discord,
                                                        color: Colors.white,
                                                        size: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 24.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot.data![index][
                                                                "discord_member_count"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11.0),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index][
                                                                    "discord_online_member_count"]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11.0),
                                                          ),
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          Container(
                                                            height: 6.0,
                                                            width: 6.0,
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .greenAccent,
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6.0,
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 110.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal: 12.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    FontAwesomeIcons.twitter,
                                                    color: Colors.lightBlue,
                                                    size: 18.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 24.0,
                                                  ),
                                                  Text(
                                                    snapshot.data![index][
                                                            "twitter_follower_count"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.45),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Text(
                                            snapshot.data![index]["point"]
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.greenAccent,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: snapshot.data![index]["nft_photo"],
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: 75,
                              width: 75,
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
                              height: 75,
                              width: 75,
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                          errorWidget: (context, imageUrl, error) {
                            return Container(
                              height: 75,
                              width: 75,
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(
              page: const SearchPage(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        backgroundColor: const Color(0xFF627BDD),
        child: const Icon(Icons.add),
      ),
    );
  }
}
