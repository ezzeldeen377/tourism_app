// ignore_for_file: dead_code, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Componants/search_bar.dart';
import 'package:new_flutter/features/Data/ussr_data/get_data.dart';
import 'package:new_flutter/features/Data/hotels/hotels_data.dart';
import 'package:new_flutter/features/Data/places/places_data.dart';
import 'package:new_flutter/features/Data/packages/Packages.dart';
import 'package:new_flutter/features/Data/transport/transport.dart';
import 'package:new_flutter/features/Home/details.dart';

class Home1 extends StatefulWidget {
  const Home1({super.key});
  static int selectedPage = 0;
  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  final List items = const [
    {
      "image": 'images/image 3.png',
      "Title": "Temple Of Isis (Philae)",
      "subtitle":
          "The temple was in danger of being submerged forever with the construction of the new Aswan dam (1960-1970), which flooded the area. Fortunately, the Egyptian government and UNESCO worked together to pump the area dry and relocate the entire temple, stone by stone (50,000 stones!), to a nearby island called Agilka, where it stands today.",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/image 4.png',
      "Title": "Tomb Of Ramses III",
      "subtitle":
          "King Ramses III was the second ruler of the Twentieth Dynasty, and the last of great pharaohs on the throne. Ramses III, son of Setnakht, ruled Egypt for 31 years. Shortly before his death, there was a conspiracy to kill him by several members of his household including one of his minor wives, Queen Tiy. It was essentially an attempt to ensure her son's ascending to the throne. The trial of this conspiracy is shown upon the walls of his mortuary temple at Madint Habu. The tomb was begun by Setnakht, who then abandoned it and turned to KV14 where he was buried. Setnakht's son, Ramses III, then resumed work on KV11. James Bruce was the first European traveler to enter this tomb in 1768. He was struck by the painted figures of the two blind harpists that he called it the Tomb of the Harpists. Nowadays, the Tomb of Ramses III is considered one of the most visited tombs in the Valley of the Kings as there are many impressive reliefs and paintings to be seen on this tomb.",
      "price": "Starting 10 EGP / Ticket",
    },
    {
      "image": 'images/image 1.png',
      "Title": "Abu Simbel Temples",
      "subtitle":
          "Abu Simbel today is no longer in the same location as it was in ancient times. The area where the temples were originally located is now flooded. The temples were moved and raised to escape the rising water caused by the construction of the Aswan High Dam, built between 1960 and 1970. Between 1964 and 1968, the temples were dismantled and relocated on an artificial hill made from a domed structure that is 200 feet (64 meters) above and 600 feet (180 meters) west of their original site. This relocation project, completed under the direction of UNESCO, is one of the most impressive engineering feats in history",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/image 2.png',
      "Title": "Kom Ombo Temple",
      "subtitle": "Kom Ombo Temple, a unique structure in Ancient Egypt, was primarily constructed during the Ptolemaic Dynasty (180 - 47 BCE), although it likely stands on the site of an earlier temple. What sets it apart is its dual dedication to two distinct deities: Sobek, the local crocodile-headed god, and Horus the Elder, the falcon-headed god considered the god of the Kingdom. This intentional duality is reflected not only in the architectural design, with two sets of courts, halls, and sanctuaries, but also in its symbolic representation of local and universal themes embodied by the deities"
          'Despite enduring significant damage over time, Kom Ombo Temple has undergone partial reconstruction and still boasts well-preserved reliefs, including intricately carved columns and friezes depicting both Sobek and Horus The layout of the temple complex, aside from its duality, bears resemblance to the Temple of Edfu'
          "Historically, the Nile surrounding Kom Ombo was inhabited by crocodiles, which evoked fear among the Ancient Egyptians. However, they believed that by worshiping these creatures, they could ward off attacks. The temple even housed a pool for raising crocodiles. A notable aspect of visiting Kom Ombo Temple is the Crocodile Museum, which showcases mummified crocodiles found in the area, accompanied by fascinating explanations",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/image 5.png',
      "Title": "Hubu Temple",
      "subtitle":
          " While it is not among the most well traveled sites on the West Bank, Medinat Habu is considered by many visitors to be among the most impressive sights they see in Luxor."
              "This temple complex is impressively preserved, especially in comparison to the Ramesseum, on which its plan is based",
      "price": "Starting 10 EGP / Ticket",
    },
    {
      "image": 'images/image 6.png',
      "Title": "Qaitbay Citadel",
      "subtitle": "Sultan Qaitbey built this picturesque fortress during the 14th century to defend Alexandria from the advances of the Ottoman Empire. His efforts were in vain since the Ottomans took control of Egypt in 1512, but the fortress has remained, strategically located on a thin arm of land that extends out into Alexandria’s harbor from the corniche"
          'The fortress’ current form is not the original. It was heavily damaged during the British bombardment of Alexandria during a nationalist uprising against British hegemony in 1882 and rebuilt around the turn of the 20th century'
          'As with most things in Alexandria, the building itself is not what is most significant about this location. Qaitbey built the fortress here to take advantage of an exist foundation on the site—that of the legendary Pharos Lighthouse, which by the 14th century had fallen into ruins due to repeated damage by earthquakes'
          'The largest stones of the citadel, forming the lintel and doorway of its entrance, as well as the red granite columns in the mosque within the walls, are probably also salvaged from the huge tower that once stood here'
          'The citadel has long since given up any military function. Today it houses a small naval museum, but it might be worth a visit to explore the inside of the fortress and imagine the huge structure that once stood on its foundation'
          'The peninsula leading to the citadel is also a popular area with fishermen and families alike. It is usually crowded with a pleasant crowd enjoying the sea views, restaurants and ice cream shops that line the street up to the fortress',
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/image 7.png',
      "Title": "Pyramids Of Giza",
      "subtitle": "info",
      "price": "Starting 5 EGP / Ticket",
    },
    {
      "image": 'images/image 8.png',
      "Title": "Mosque Of Amr Ibn Al-As",
      "subtitle": "info",
      "price": "Starting 5 EGP / Ticket",
    },
  ];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              MySearchBar(),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Text("Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                          highlightColor: kMainColor,
                          iconSize: 50,
                          alignment: Alignment.center,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Packages()));
                          },
                          icon: Icon(Icons.collections_rounded)),
                      Text("Packages",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
Column(
                    children: [
                      IconButton(
                          highlightColor: kMainColor,
                          iconSize: 50,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HotelsData()));
                          },
                          icon: Icon(Icons.hotel)),
                      Text("Hotels",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),

              const Row(
                children: [
                  Text("Most Recent",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                height: 520,
                child: CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                        padding: const EdgeInsets.all(0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            mainAxisSpacing: 5.0,
                            //crossAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int v) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          details(data: items[v])));
                                },
                                child: Card(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          items[v]['image'],
                                          fit: BoxFit.cover,
                                          height: 110,
                                          width: 200,
                                        ),
                                        Text(items[v]['Title'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                height: 1.50)),
                                        Text(items[v]['price'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                            )),
                                      ]),
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/