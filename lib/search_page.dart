import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfthink/api_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKey = "";
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB5BBBE),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF627BDD),
        title: const Text("Search NFTs"),
      ),
      body: FutureBuilder<List>(
          future: ApiHelper.getAllNft(searchKey),
          builder: (context, filteredNFTList) {
            if (!filteredNFTList.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (filteredNFTList.data!.isEmpty) {
              return const Center(
                child: Text(
                  "There is no new NFT for adding to your homepage.",
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: filteredNFTList.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: index == 0 ? 32.0 : 16.0,
                      ),
                      if (index == 0)
                        TextField(
                          controller: _searchController,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          onChanged: (String? newText) {
                            setState(() {
                              searchKey = newText!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Search NFT",
                            hintStyle: const TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  searchKey = _searchController.text;
                                });
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                      if (index == 0)
                        const SizedBox(
                          height: 32.0,
                        ),
                      InkWell(
                        onTap: () {
                          ApiHelper.addNftToMainPage(
                            nftId: filteredNFTList.data![index]["id"],
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 48.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B4292),
                            borderRadius: BorderRadius.circular(48.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4.0,
                                offset: const Offset(0.0, 3.0),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: filteredNFTList.data![index]
                                      ["nft_photo"],
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      width: 70,
                                      height: 70,
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
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.blueGrey,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, imageUrl, error) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.blueGrey,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    filteredNFTList.data![index]["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "POINT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      filteredNFTList.data![index]["point"]
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
