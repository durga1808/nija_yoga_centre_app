// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:yoga_centre_app/presentation/util/Appconstatnts.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// class MyVideo extends StatefulWidget {
//   const MyVideo({super.key});

//   @override
//   _MyVideoState createState() => _MyVideoState();
// }

// class _MyVideoState extends State<MyVideo> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String _name = '';
//   String _youtubelink = '';
//   bool _active = false;
//   DateTime? _fromdate;
//   DateTime? _todate;

//   List<Map<String, dynamic>> _videoData = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchVideoData();
//   }

//   Future<void> _fetchVideoData() async {
//     try {
//       final response = await http.get(Uri.parse('${AppConstants.LOCAL_URL}getVideos'));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == true) {
//           setState(() {
//             _videoData = List<Map<String, dynamic>>.from(data['data']);
//           });
//         } else {
//           print('Error fetching videos: ${data['message']}');
//         }
//       } else {
//         print('Failed to load videos. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching video data: $e');
//     }
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final fromdateFormatted = DateFormat('yyyy-MM-dd').format(_fromdate!);
//       final todateFormatted = DateFormat('yyyy-MM-dd').format(_todate!);

//       try {
//         final response = await http.post(
//           Uri.parse('${AppConstants.LOCAL_URL}addVideo'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'name': _name,
//             'youtubelink': _youtubelink,
//             'active': _active ? 1 : 0,
//             'fromdate': fromdateFormatted,
//             'todate': todateFormatted,
//           }),
//         );

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           if (data['status'] == true) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Video added successfully!')),
//             );
//             _fetchVideoData();
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Failed to add video: ${data['message']}')),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${response.statusCode}')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error occurred: $e')),
//         );
//       }
//     }
//   }

//   // Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: DateTime.now(),
//   //     firstDate: DateTime(2000),
//   //     lastDate: DateTime(2101),
//   //   );
//   //   if (picked != null && picked != (isFromDate ? _fromdate : _todate)) {
//   //     setState(() {
//   //       if (isFromDate) {
//   //         _fromdate = picked;
//   //       } else {
//   //         _todate = picked;
//   //       }
//   //     });
//   //   }
//   // }

 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Videos Details'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             // child: IconButton(
//             //   icon: const Icon(Icons.add, size: 25),
//             //   onPressed: _openAddVideoForm,
//             // ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _videoData.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _videoData.length,
//                     itemBuilder: (context, index) {
//                       final video = _videoData[index];
//                       String? videoId = YoutubePlayer.convertUrlToId(video['youtubelink']);
                      
//                       // Handle case where videoId is null
//                       if (videoId == null) {
//                         return ListTile(
//                           title: const Text('Invalid YouTube link'),
//                           subtitle: Text(video['youtubelink']),
//                         );
//                       }

//                       YoutubePlayerController controller = YoutubePlayerController(
//                         initialVideoId: videoId,
//                         flags: const YoutubePlayerFlags(
//                           autoPlay: false,
//                           mute: false,
//                         ),
//                       );

//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         child: Column(
//                           children: [
//                             YoutubePlayer(
//                               controller: controller,
//                               showVideoProgressIndicator: true,
//                               progressIndicatorColor: Colors.red,
//                             ),
//                             ListTile(
//                               title: Text(video['name']),
//                               subtitle: Text(video['youtubelink']),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

