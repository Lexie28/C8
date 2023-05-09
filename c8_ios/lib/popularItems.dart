import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'specificItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularItems extends StatefulWidget {
  const PopularItems({Key? key});

  @override
  State<PopularItems> createState() => _PopularItemsState();
}

class _PopularItemsState extends State<PopularItems> {
  Api _api = Api();
  late Future<List<dynamic>> _futureListings;

  @override
  void initState() {
    super.initState();
    _futureListings = fetchPopular();
  }

  Future<List<dynamic>> fetchPopular() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('uid');

    final response = await http.get(Uri.parse(
        '${_api.getApiHost()}/listing?sort=popular&exclude_user=$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA2BABF),
        title: Text('Popular Items'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<dynamic>>(
              future: _futureListings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listings = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listings.length,
                    itemBuilder: (BuildContext context, int index) {
                      final listing = listings[index];
                      return Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.01,
                          right: MediaQuery.of(context).size.width*0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 254, 254),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListingDetailPage(
                                  listingId: listings[index]['id'].toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width*0.3,
                                width: MediaQuery.of(context).size.width*0.3,
                          
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: ListTile(
                                leading: Container(
                                  height: MediaQuery.of(context).size.width*0.5,
                                  width: MediaQuery.of(context).size.width*0.3,
                                                      
                                  child: Image.network(
                                    'https://circle8.s3.eu-north-1.amazonaws.com/${listing['image_path']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(listing['name']),
                                subtitle: Text(listing['description']),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Failed to fetch listings');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    required this.string,
  });

  final String string;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 1,
      child: Card(
        color: theme.colorScheme.primary,
        elevation: 10,
        child: Align(
          alignment: FractionalOffset.center,
          child: Text(
            string,
            style: style,
          ),
        ),
      ),
    );
  }
}
