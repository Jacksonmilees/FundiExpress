import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../screens/Login/login_screen.dart'; // Import the login screen
import '../screens/Signup/signup_screen.dart'; // Import the signup screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get Current Location and Convert to Address
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = "Location permissions permanently denied.";
        });
        return;
      }
    }

    try {
      // Updated code to use LocationSettings instead of desiredAccuracy
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // Convert Lat & Long to Address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _currentLocation =
              "${place.locality}, ${place.subLocality}, ${place.country}";
        });
      } else {
        setState(() {
          _currentLocation = "Unable to find location.";
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = "Error fetching location.";
      });
    }
  }

  void _onAccountButtonPressed() {
    // Show login/signup prompt
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Account'),
        content: Text('Please log in or sign up to access your account.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen()), // Navigate to login screen
              );
            },
            child: Text('Log In'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignUpScreen()), // Navigate to signup screen
              );
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 3) {
            _onAccountButtonPressed(); // Handle Account button click
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Notification Icon + Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        _currentLocation,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Notification Icon
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {
                      // Handle notification click
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Advertisement Section (Not Banner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Limited Offer! 🚀",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Get 10% off your first handyman booking. Offer valid until March 30!",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title "Find a Handyman"
              Text(
                'Find a handyman',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // First row of handyman categories
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 0.9,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildCategoryItem('assets/icons/housemaid.svg', 'Housemaid'),
                  _buildCategoryItem('assets/icons/plumber.svg', 'Plumber'),
                  _buildCategoryItem(
                      'assets/icons/electrician.svg', 'Electrician'),
                  _buildCategoryItem(
                      'assets/icons/install.svg', 'Installation'),
                ],
              ),

              const SizedBox(height: 20),

              // Subtitle "More services"
              Text(
                'More services',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // Second row of more services
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 0.9,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildCategoryItem('assets/icons/locksmith.svg', 'Locksmith'),
                  _buildCategoryItem(
                      'assets/icons/pestcontrol.svg', 'Pest Control'),
                  _buildCategoryItem(
                      'assets/icons/babysitters.svg', 'Babysitters'),
                  _buildCategoryItem('assets/icons/tutor.svg', 'Tutor'),
                  _buildCategoryItem('assets/icons/painter.svg', 'Painter'),
                  _buildCategoryItem('assets/icons/carpenter.svg', 'Carpenter'),
                  _buildCategoryItem('assets/icons/yard.svg', 'Yard Work'),
                  _buildCategoryItem('assets/icons/delivery.svg', 'Delivery'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for category icon + label
  Widget _buildCategoryItem(String iconPath, String label) {
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          height: 40,
          width: 40,
          colorFilter: ColorFilter.mode(
              Colors.black, BlendMode.srcIn), // Updated to use colorFilter
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
