import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yoga_centre_app/data/api_service.dart';
import 'package:yoga_centre_app/presentation/dashboard/dashboardscreen.dart';
import 'package:yoga_centre_app/presentation/model/loginmodel.dart';
import 'package:yoga_centre_app/presentation/util/app_util.dart';
import 'package:yoga_centre_app/presentation/util/appcolor.dart';
import 'package:yoga_centre_app/presentation/util/curveclipper.dart';
import 'package:yoga_centre_app/presentation/util/pref.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginModel loginModel = LoginModel();
  bool loading = false;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Yoga Center ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      backgroundImage(size),
                      logincredential(size),
                    ],
                  ),
                  circleButton(size),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      persistentFooterButtons: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const Text('Powered By'),
              Image.asset(
                "assets/images/nijalogo.png",
                height: 80,
                width: 130,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget circleButton(size) {
    return Positioned(
      top: size.height * 0.42,
      right: size.width * 0.15,
      child: FloatingActionButton(
        onPressed: () {}, 
        elevation: 5.0,
        backgroundColor: AppColor.primary,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  Widget logincredential(size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please Log In',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Material(
            elevation: 10.0,
            color: AppColor.white,
            borderRadius: BorderRadius.circular(30.0),
            child: TextField(
              controller: usernamecontroller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintText: 'User Name',
                suffixIcon: Icon(
                  Icons.person,
                  size: 25.0,
                  color: AppColor.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Material(
            elevation: 10.0,
            color: AppColor.white,
            borderRadius: BorderRadius.circular(30.0),
            child: TextField(
              obscureText: true,
              controller: passwordcontroller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintText: 'Password',
                suffixIcon: Icon(
                  Icons.lock_outline,
                  size: 25.0,
                  color: AppColor.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          InkWell(
            onTap: () {
              if (usernamecontroller.text.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context, "Enter User Name", "Ok", exitpopup);
              } else if (passwordcontroller.text.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context, "Enter User password", "Ok", exitpopup);
              } else {
                getlogin();
              }
            },
            child: Material(
              elevation: 10.0,
              shadowColor: AppColor.primary,
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(30.0),
              child: SizedBox(
                width: size.width,
                height: size.width * 0.13,
                child: const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
          )
        ],
      ),
    );
  }

  Widget backgroundImage(size) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        height: size.height * 0.55,
        color: const Color(0xff002a61),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
          child: Center(
            child: Image(
              image: AssetImage('assets/images/maharishi1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Login function
  void getlogin() async {
    setState(() {
      loading = true;
    });

    Apiservice.getlogin(usernamecontroller.text, passwordcontroller.text)
        .then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData); // Debug print to verify response structure
        if (responseData['status'] == true) {
          loginModel = LoginModel.fromJson(responseData);
          addsharedpref(loginModel);
        } else {
          AppUtils.showSingleDialogPopup(
              context, responseData['message'].toString(), "Ok", exitpopup);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, "Login Failed! Please try again.", "Ok", exitpopup);
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    });
  }

  void exitpopup() {
    AppUtils.pop(context);
  }

  Future addsharedpref(LoginModel model) async {
    await Prefs.setLoggedIn("IsLoggedIn", true);
    await Prefs.setUserName("UserName", model.message![0].username.toString());
    print("Username set to: ${model.message![0].username.toString()}"); // Debug print

    await Prefs.setID("UserID", model.message![0].id!.toInt());
    await Prefs.setName(
        "Name",
        '${model.message![0].firstname.toString()} ${model.message![0].middlename.toString()} ${model.message![0].lastname.toString()}');
    await Prefs.setCenterID("CenterId", model.message![0].centerid!.toInt());
    await Prefs.setCenterName(
        "CenterName", model.message![0].centername!.toString());
    await Prefs.setMobileNo("MobileNo", model.message![0].phoneno!.toString());
    await Prefs.setGender("Gender", model.message![0].gender!.toString());

    // Navigate to the dashboard screen after successful login
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  DashboardScreen()),
      );
    }
  }
}
