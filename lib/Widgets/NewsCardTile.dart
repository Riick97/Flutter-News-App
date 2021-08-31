import 'package:flutter/material.dart';
import '../Pages/ArticlePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsCardTile extends StatefulWidget {
  final String? imgUrl, title, desc, content, posturl;
  User? user;
  NewsCardTile(
      {this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.user,
      @required this.posturl});

  @override
  _NewsCardTileState createState() => _NewsCardTileState();
}

class _NewsCardTileState extends State<NewsCardTile> {
  bool saved = false;

  CollectionReference? bookMarksRef;

  _onTap(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(
          postUrl: widget.posturl,
        ),
      ),
    );
  }

  _onBookmark() {
    if (widget.user == null) {
      final snackBar = SnackBar(
        content: Text(
          'You must be logged in to save articles',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (!saved) {
      bookMarksRef!.doc(widget.title).set({
        'image': widget.imgUrl,
        'description': widget.desc,
        'title': widget.title,
        'content': widget.content,
        'url': widget.posturl,
      });
    } else {
      bookMarksRef!
          .doc(widget.title)
          .delete()
          .then((value) => print('Bookmark Removed'));
    }
    if (mounted) {
      setState(() {
        saved = !saved;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String collectionName = widget.user != null ? widget.user!.uid : 'none';
    bookMarksRef = FirebaseFirestore.instance.collection(collectionName);
    _hasArticle();
  }

  _hasArticle() {
    bookMarksRef!
        .doc(widget.title)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (mounted) {
          setState(() {
            saved = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   child: SizedBox(
    //     height: 150.0,
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(8.0),
    //           child: Image.asset(
    //             'lib/Assets/images/img_not_found.jpg',
    //             fit: BoxFit.cover,
    //             width: 100.0,
    //             height: 100.0,
    //           ),
    //         ),
    //         SizedBox(width: 24.0),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Expanded(
    //                 child: Text(
    //                   widget.title!,
    //                   maxLines: 2,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: TextStyle(
    //                     fontSize: 26.0,
    //                   ),
    //                 ),
    //               ),
    //               widget.desc! == null
    //                   ? Container()
    //                   : Text(
    //                       widget.desc!,
    //                       style: TextStyle(
    //                         color: Colors.grey,
    //                         fontSize: 18.0,
    //                       ),
    //                     ),
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 children: <Widget>[
    //                   Text(
    //                     'null',
    //                     style: TextStyle(
    //                       color: Colors.grey,
    //                       fontSize: 14.0,
    //                     ),
    //                   ),
    //                   Text(
    //                     ' | ',
    //                     style: TextStyle(
    //                       color: Colors.grey,
    //                       fontSize: 18.0,
    //                     ),
    //                   ),
    //                   Text(
    //                     widget.title!,
    //                     style: TextStyle(
    //                       color: Colors.grey,
    //                       fontSize: 14.0,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _onTap(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: widget.imgUrl != ""
                          ? Image.network(
                              widget.imgUrl!,
                              height: 100,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/Assets/images/img_not_found.jpg',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              _onTap(context);
                            },
                            child: Text(
                              widget.title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.desc!,
                                maxLines: 2,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  _onBookmark();
                                },
                                child: saved
                                    ? Icon(Icons.bookmark_add)
                                    : Icon(Icons.bookmark_add_outlined),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
