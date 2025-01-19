// Last modified: 2024-01-23
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:punarjani/custom/inputformatters/timeinput.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../custom/inputformatters/dateinput.dart';
import '../../custom/location/locationdetermine.dart';
import '../../theme/theme.dart';

class Reportpage extends StatefulWidget {
  const Reportpage({super.key, this.id});
  final dynamic id;

  @override
  State<Reportpage> createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  final TextEditingController _violationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  XFile? video;
  bool _isMediaSelected = false;
  String? _videoThumbnail;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _image = pickedFile;
      _videoThumbnail = null; // Clear video thumbnail if a new image is picked
      _isMediaSelected = pickedFile != null;
    });
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: pickedFile.path,
        imageFormat: ImageFormat.PNG,
        quality: 25,
      );
      setState(() {
        video = pickedFile;
        _image = null; // Clear image if a new video is picked
        _videoThumbnail = thumbnail;
        _isMediaSelected = true;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _violationController.clear();
      _detailsController.clear();
      _datecontroller.clear();
      _timecontroller.clear();
      _locationcontroller.clear();
      _image = null;
      video = null;
      _videoThumbnail = null;
      _isMediaSelected = false;
    });
  }

  Future<void> _uploadToFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      String? videoUrl;
      final storageRef = FirebaseStorage.instance.ref();

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploading report...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Upload image if exists
      if (_image != null) {
        final imageRef = storageRef.child('reports/${widget.id}/image.jpg');
        await imageRef.putFile(File(_image!.path));
        imageUrl = await imageRef.getDownloadURL();
      }

      // Upload video if exists
      if (video != null) {
        final videoRef = storageRef.child('reports/${widget.id}/video.mp4');
        await videoRef.putFile(File(video!.path));
        videoUrl = await videoRef.getDownloadURL();
      }

      // Upload report data to Firestore
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.id)
          .set({
        'violationType': _violationController.text,
        'details': _detailsController.text,
        'date': _datecontroller.text,
        'time': _timecontroller.text,
        'location': _locationcontroller.text,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'status': 'pending', // Add this line
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear all fields and loading state after successful upload
      setState(() {
        _isLoading = false;
        _clearAllFields();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report uploaded successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Reset loading state and show error
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading report: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 20, bottom: 70), // Adjusted padding
          child: Column(
            children: [
              _documentaddwidget(context),
              if (_isMediaSelected) _documentcontainer(context),
              _formfield('Violation Type', 'Enter Violation', 50, 2,
                  maxWords: 10),
              _formfield('Details', 'Enter Details about violation', 160, 6,
                  maxWords: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _datefield('Date', 'DD-MM-YYYY', 50),
                  Expanded(child: _timefield('Time', 'HH:MM', 50)),
                ],
              ),
              _locationformfield('Location', 'Enter Location', 100, 3,
                  maxWords: 10),
              GestureDetector(
                onTap: _uploadToFirebase,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF5A75F0),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A75F0)),
              ),
            ),
          ),
      ],
    );
  }

  Padding _datefield(
    String title,
    String hint,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return Text('$title : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        themeprovider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.black));
          }),
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return SizedBox(
              width: 150,
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _datecontroller,
                      inputFormatters: [DateInputFormatter()],
                      maxLines: 1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor,
                        hintText: '$hint ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: themeprovider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors
                                      .white), // Set the border color to black
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: themeprovider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors
                                      .white), // Set the border color to black
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final selectedDatetemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 10)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDatetemp == null) {
                        return;
                      } else {
                        setState(() {
                          _datecontroller.text = DateFormat('dd-MM-yyyy')
                              .format(selectedDatetemp)
                              .toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Padding _locationformfield(
      String title, String hint, double height, int maxLines,
      {int maxWords = 10}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return Text('$title : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        themeprovider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.black));
          }),
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  child: TextFormField(
                    controller: _locationcontroller,
                    inputFormatters: [MaxWordsInputFormatter(maxWords)],
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      hintText: '$hint ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeprovider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors
                                    .white), // Set the border color to black
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeprovider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors
                                    .white), // Set the border color to black
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () async {
                      Position position = await determinePosition();
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              position.latitude, position.longitude);
                      Placemark place = placemarks[0];
                      setState(() {
                        _locationcontroller.text =
                            '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
                      });
                    },
                    icon: const Icon(Icons.location_on),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Padding _formfield(String title, String hint, double height, int maxLines,
      {int maxWords = 10}) {
    final controller =
        title == 'Violation Type' ? _violationController : _detailsController;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return Text('$title : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        themeprovider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.black));
          }),
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: height,
              child: TextFormField(
                controller: controller, // Add controller here
                inputFormatters: [MaxWordsInputFormatter(maxWords)],
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  hintText: '$hint ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeprovider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white), // Set the border color to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeprovider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white), // Set the border color to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Padding _documentcontainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 300,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            if (_videoThumbnail != null)
              Expanded(
                child: Image.file(
                  File(_videoThumbnail!),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            else
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Padding _documentaddwidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              return _showPhotoPicker(context);
            },
            child: Container(
              height: 75,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      size: 35,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Photo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              return _showVideoPicker(context);
            },
            child: Container(
              height: 75,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam, size: 40),
                  Text(
                    'Video',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _timefield(
    String title,
    String hint,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return Text('$title : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        themeprovider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.black));
          }),
          Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
            return SizedBox(
              width: 150,
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: _timecontroller,
                      inputFormatters: [TimeInputFormatter()],
                      maxLines: 1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).primaryColor,
                        hintText: '$hint ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: themeprovider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors
                                      .white), // Set the border color to black
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: themeprovider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors
                                      .white), // Set the border color to black
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final now = DateTime.now();
                        final formattedTime = DateFormat('hh:mm a').format(
                          DateTime(now.year, now.month, now.day,
                              pickedTime.hour, pickedTime.minute),
                        );
                        setState(() {
                          _timecontroller.text = formattedTime;
                        });
                      }
                    },
                    icon: const Icon(Icons.timer),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showPhotoPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Video Library'),
                onTap: () {
                  _pickVideo(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Camera'),
                onTap: () {
                  _pickVideo(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _violationController.dispose();
    _detailsController.dispose();
    _datecontroller.dispose();
    _timecontroller.dispose();
    _locationcontroller.dispose();
    super.dispose();
  }
}

class MaxWordsInputFormatter extends TextInputFormatter {
  final int maxWords;

  MaxWordsInputFormatter(this.maxWords);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.split(' ').length > maxWords) {
      return oldValue;
    }
    return newValue;
  }
}
