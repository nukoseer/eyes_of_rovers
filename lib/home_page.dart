import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:eyes_of_rovers/user_account_page.dart';
import 'package:eyes_of_rovers/authentication.dart';
import 'package:eyes_of_rovers/photo_list_model.dart';

extension CapExtension on String {
  String get capitalize =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhotoListModel(),
      child: Consumer<PhotoListModel>(builder: (context, model, child) {
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            onTap: (int index) {
              model.resetCameraIndexAndPageIndex();
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.circle_lefthalf_fill),
                label: model.rovers[0].name.capitalize,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.circle_fill),
                label: model.rovers[1].name.capitalize,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.circle_righthalf_fill),
                label: model.rovers[2].name.capitalize,
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return CupertinoTabView(
              builder: (BuildContext context) {
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(
                        "${model.rovers[index].availableCameras[PhotoListModel.currentCameraIndex]}"),
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserAccountPage()));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              UserInformation.profilePictureUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text("Camera Filter"),
                      onPressed: () => {
                        _cameraPicker(
                            context, model.rovers[index].availableCameras),
                      },
                    ),
                  ),
                  child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
                        // NOTE: Swipe Left
                        model.previousPage();
                      } else if (details.primaryVelocity! < 0) {
                        // NOTE: Swipe Right
                        model.nextPage();
                      }
                    },
                    child: FutureBuilder<List<Photo>>(
                      future: model.fetchPhotos(http.Client(), index),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("ERROR!"));
                        }
                        if (snapshot.hasData) {
                          return PhotosList(photos: snapshot.data!);
                        } else {
                          return Center(
                            child: CupertinoActivityIndicator(
                              radius: 16.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  void _cameraPicker(BuildContext context, List<String> availableCameras) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: FixedExtentScrollController(
              initialItem: PhotoListModel.currentCameraIndex),
          itemExtent: 30.0,
          onSelectedItemChanged: (value) {
            PhotoListModel().changeCurrentCameraIndex(value);
          },
          children: List<Widget>.generate(availableCameras.length,
              (int index) => Text(availableCameras[index])),
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;
  final random = Random();
  final List<double> photoHeights = <double>[140.0, 240.0, 340.0];

  PhotosList({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return photos.length != 0
        ? StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: photos.length,
            itemBuilder: (BuildContext context, int index) => new Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: photoHeights[random.nextInt(photoHeights.length)],
                      //height: 200,
                      child: Image.network(
                        photos[index].imageSource,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: Icon(CupertinoIcons.photo),
                        title: Text(
                          "Sol: ${photos[index].sol.toString()}",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                          ),
                        ),
                        subtitle: Text(
                          "Earth Date: ${photos[index].earthDate}",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(
                2), //StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          )
        : Center(
            child: Material(
              child: Text(
                "No photos found",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          );
  }
}
