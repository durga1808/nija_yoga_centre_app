import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoga_centre_app/presentation/dashboard/enrollnow.dart';
import 'package:yoga_centre_app/presentation/dashboard/logoutpage.dart';
import 'package:yoga_centre_app/presentation/dashboard/myscore.dart';
import 'package:yoga_centre_app/presentation/dashboard/myreports.dart';
import 'package:yoga_centre_app/presentation/loginscreen/loginscreen.dart';
import 'package:yoga_centre_app/presentation/util/Appconstatnts.dart';
import 'package:yoga_centre_app/presentation/util/app_util.dart';
import 'package:yoga_centre_app/presentation/util/appcolor.dart';
import 'package:yoga_centre_app/presentation/util/pref.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  DateTime? currentBackPressTime;
  List<YoutubePlayerController> _controllers = [];
  List<Map<String, dynamic>> _videoData = [];
  bool _isError = false;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    fetchVideoUrls();
  }

  Future<void> fetchVideoUrls() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.LOCAL_URL}getVideos'),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded API Data: $data');

        if (data['status'] == true && data['data'].isNotEmpty) {
          _videoData = List<Map<String, dynamic>>.from(data['data']);
          List<String> videoUrls = _videoData
              .map((video) => video['youtubelink'] as String)
              .toList();
          setState(() {
            loading = false;
          });
          _initializeYoutubeControllers(videoUrls);
        } else {
          setState(() {
            loading = false;
          });
          _handleError("No videos found or API returned an error");
        }
      } else {
        setState(() {
          loading = false;
        });
        _handleError(
            'Failed to load videos, server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      _handleError('Error occurred while fetching video URLs: $e');
    }
  }

  void _initializeYoutubeControllers(List<String> videoUrls) {
    List<YoutubePlayerController> controllers = [];

    for (String url in videoUrls) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        controllers.add(
          YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          ),
        );
      }
    }

    setState(() {
      _controllers = controllers;
    });
  }

  void _handleError(String message) {
    print(message);
    setState(() {
      _isError = true;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          var snackBar =
              const SnackBar(content: Text('Press again to exit the app'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body:!loading? Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 80,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            Prefs.getName("Name").toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Yoga Center',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white54),
                          ),
                          trailing: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              Prefs.getGender("Gender")
                                          .toString()
                                          .toUpperCase() ==
                                      "FEMALE"
                                  ? 'assets/icons/female.png'
                                  : 'assets/icons/male.png',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _controllers.isNotEmpty
                      ? CarouselSlider.builder(
                          itemCount: _controllers.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: YoutubePlayer(
                                        controller: _controllers[index],
                                        showVideoProgressIndicator: true,
                                        progressIndicatorColor:
                                            const Color.fromRGBO(0, 42, 97, 1),
                                        bottomActions: [],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(' ${_videoData[index]['coursename']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Container(
                                       padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.all(5),
                                      child: Text(
                                        '${_videoData[index]['content']}',
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _enrollInCourse(
                                              _videoData[index]['id']
                                                  .toString(),
                                              _videoData[index]['coursename']);
                                        },
                                        child: const Text('Enroll Now',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 480,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            viewportFraction: 0.8,
                          ),
                        )
                      : _isError
                          ? const Text(
                              'Error loading videos',
                              style: TextStyle(color: Colors.red),
                            )
                          : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.primary,
                          child: IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/icons/Group.png'),
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Myscore()));
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('My Score',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.primary,
                          child: IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/icons/Group 34082.png'),
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Myreports()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('My Reports',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.primary,
                          child: IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () {
                              Prefs.setLoggedIn("IsLoggedIn", false);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const LoginScreen();
                                }),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('Log Out',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Future<void> _enrollInCourse(String courseId, String courseName) async {
    setState(() {
      loading=true;
    });
    var body = {
      'courseId': courseId,
      'courseName': courseName,
      'createdBy': Prefs.getID("UserID").toString(),
    };
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.LOCAL_URL}addenroll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print(jsonEncode(body));
      setState(() {
      loading=false;
    });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          AppUtils.showSingleDialogPopup(
              context, data['message'], "Ok", exitpopup);
        } else {
          AppUtils.showSingleDialogPopup(
              context, data['message'], "Ok", exitpopup);
        }
      } else {
        setState(() {
      loading=false;
    });
        _handleError('Failed to enroll, server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
      loading=false;
    });
      _handleError('Error occurred while enrolling in course: $e');
    }
  }

  void exitpopup() {
    AppUtils.pop(context);
  }

  void onrefresh() {
    AppUtils.pop(context);
    AppUtils.pop(context);
  }
}
