import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Rover {
  final String name;
  final List<String> availableCameras;

  Rover({required this.name, required this.availableCameras});
}

class Photo {
  final int id;
  final int sol;
  final String imageSource;
  final String earthDate;

  // Camera
  final int cameraId;
  final String cameraName;
  final String cameraFullName;
  //

  // Rover
  final int roverId;
  final String roverName;
  final String landingDate;
  final String launchDate;
  final String status;
  //

  Photo({
    required this.id,
    required this.sol,
    required this.imageSource,
    required this.earthDate,
    required this.cameraId,
    required this.cameraName,
    required this.cameraFullName,
    required this.roverId,
    required this.roverName,
    required this.landingDate,
    required this.launchDate,
    required this.status,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"] as int,
      sol: json["sol"] as int,
      imageSource: json["img_src"] as String,
      earthDate: json["earth_date"] as String,
      cameraId: json["camera"]["id"] as int,
      cameraName: json["camera"]["name"] as String,
      cameraFullName: json["camera"]["full_name"] as String,
      roverId: json["rover"]["id"] as int,
      roverName: json["rover"]["name"] as String,
      landingDate: json["rover"]["landing_date"] as String,
      launchDate: json["rover"]["launch_date"] as String,
      status: json["rover"]["status"] as String,
    );
  }
}

class PhotoListModel extends ChangeNotifier {
  final List<Rover> rovers = <Rover>[
    Rover(
      name: "curiosity",
      availableCameras: <String>[
        "ALL",
        "FHAZ",
        "RHAZ",
        "MAST",
        "CHEMCAM",
        "MAHLI",
        "MARDI",
        "NAVCAM",
        "PANCAM",
        "MINITES"
      ],
    ),
    Rover(
      name: "opportunity",
      availableCameras: <String>[
        "ALL",
        "FHAZ",
        "RHAZ",
        "NAVCAM",
        "PANCAM",
        "MINITES"
      ],
    ),
    Rover(
      name: "spirit",
      availableCameras: <String>[
        "ALL",
        "FHAZ",
        "RHAZ",
        "NAVCAM",
        "PANCAM",
        "MINITES"
      ],
    )
  ];

  static int currentPageIndex = 1;
  static int currentCameraIndex = 0;

  Future<List<Photo>> fetchPhotos(http.Client client, int roverIndex) async {
    String roverName = rovers[roverIndex].name;
    String apiKey = "api_key=XCLhD2eJckmypXgWxcfRXWQ7p3Yc7Cr8eXJyq85C";
    String camera = currentCameraIndex == 0
        ? ""
        : "camera=${rovers[roverIndex].availableCameras[currentCameraIndex]}";
    final response = await client.get(Uri.parse(
        "https://api.nasa.gov/mars-photos/api/v1/rovers/$roverName/photos?sol=1000&page=$currentPageIndex&$camera&$apiKey"));

    return compute(parsePhotos, response.body);
  }

  static List<Photo> parsePhotos(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    return parsed["photos"].map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  void setPageIndex(int pageIndex) {
    currentPageIndex = pageIndex;
    notifyListeners();
  }

  void setCameraIndex(int cameraIndex) {
    currentCameraIndex = cameraIndex;
    notifyListeners();
  }

  void nextPage() {
    setPageIndex(++currentPageIndex);
  }

  void previousPage() {
    if (currentPageIndex > 1) {
      setPageIndex(--currentPageIndex);
    }
  }

  void changeCurrentCameraIndex(int cameraIndex) {
    setCameraIndex(cameraIndex);
  }

  void resetCameraIndexAndPageIndex() {
    currentPageIndex = 1;
    currentCameraIndex = 0;

    notifyListeners();
  }
}
