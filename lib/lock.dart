//
// import 'package:flutter/material.dart';
// import 'package:saving_password/passwords.dart';
//
// class lock extends StatefulWidget {
//   const lock({Key? key}) : super(key: key);
//
//   @override
//   State<lock> createState() => _lockState();
// }
//
// class _lockState extends State<lock> {
//   @override List<String> searchTerms = [
//     "Apple",
//     "Banana",
//     "Mango",
//     "Pear",
//     "Watermelons",
//     "Blueberries",
//     "Pineapples",
//     "Strawberries"
//   ];
//   List matchQuery = []; List results = [];
//   void _runFilter(String enteredKeyword) {
//
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = searchTerms;
//     } else {
//       results = searchTerms
//           .where((user) =>
//           user.toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//     setState(() {
//       matchQuery=results;
//     });
//
//   }
//   Widget build(BuildContext context) {
//
//     return Scaffold(backgroundColor:Colors.deepPurple,
//       appBar: AppBar(title: const Text('Material Transitions')),
//       body:  ListView(
//         children: [
//           SizedBox(height: 50,),
//           Container(color: Colors.white,margin: EdgeInsets.all(10),
//               child: TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     _runFilter(value);
//                   });
//                 },
//
//               )),
//           SizedBox(height:30,),
//          ElevatedButton(onPressed: () {
//            // print(matchQuery);
//            showSearch(context: context, delegate:CustomSearchDelegate());
//            // matchQuery.clear();
//          }, child:Text("")),
//
//           Container(color: Colors.red,
//          child: matchQuery.isEmpty?
//          ListView.builder(shrinkWrap: true,physics: ClampingScrollPhysics(),
//       itemCount: searchTerms.length,
//       itemBuilder: (context, index) {
//           var result = searchTerms[index];
//           return ListTile(
//             title: Text(result),
//           );
//       },
//     ):ListView.builder(shrinkWrap: true,physics: ClampingScrollPhysics(),
//            itemCount: matchQuery.length,
//            itemBuilder: (context, index) {
//              var result = matchQuery[index];
//              return ListTile(
//                title: Text(result),
//              );
//            },
//          ),
//        )
//         ],
//       ),
//     );
//   }
// }
// // class CustomSearchDelegate extends SearchDelegate {
// //   // Demo list to show querying
// //
// //   // first overwrite to
// //   // clear the search text
// //   @override
// //   List<Widget>? buildActions(BuildContext context) {
// //     return [
// //       IconButton(
// //         onPressed: () {
// //           query = '';
// //         },
// //         icon: Icon(Icons.clear),
// //       ),
// //     ];
// //   }
// //
// //   // second overwrite to pop out of search menu
// //   @override
// //   Widget? buildLeading(BuildContext context) {
// //     return IconButton(
// //       onPressed: () {
// //         close(context, null);
// //       },
// //       icon: Icon(Icons.arrow_back),
// //     );
// //   }
// //
// //   // third overwrite to show query result
// //   @override
//   // Widget buildResults(BuildContext context) {
//   //   List<String> matchQuery = [];
//   //   for (var fruit in searchTerms) {
//   //     if (fruit.toLowerCase().contains(query.toLowerCase())) {
//   //       matchQuery.add(fruit);
//   //     }
//   //   }
//   //   return ListView.builder(
//   //     itemCount: matchQuery.length,
//   //     itemBuilder: (context, index) {
//   //       var result = matchQuery[index];
//   //       return ListTile(
//   //         title: Text(result),
//   //       );
//   //     },
//   //   );
//   // }
// //
// //   // last overwrite to show the
// //   // querying process at the runtime
// //   @override
// //   Widget buildSuggestions(BuildContext context) {
// //     List<String> matchQuery = [];
// //     for (var fruit in searchTerms) {
// //       if (fruit.toLowerCase().contains(query.toLowerCase())) {
// //         matchQuery.add(fruit);
// //       }
// //     }
// //     return ListView.builder(
// //       itemCount: matchQuery.length,
// //       itemBuilder: (context, index) {
// //         var result = matchQuery[index];
// //         return ListTile(
// //           title: Text(result),
// //         );
// //       },
// //     );
// //   }
// // }