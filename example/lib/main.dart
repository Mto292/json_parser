import 'dart:io';

import 'package:example/http_client.dart';
import 'package:example/model/model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PhotoModel> responseList = [];
  late List<PostModel> list;

  @override
  void initState() {
    super.initState();
    list = List.generate(400000, (index) => PostModel(title: 'title', body: 'body', userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: get,
                  child: const Text('Get'),
                ),
                ElevatedButton(
                  onPressed: getAndParserInBackground,
                  child: const Text('Get & Background Parser'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: post,
                  child: const Text('Post'),
                ),
                ElevatedButton(
                  onPressed: postAndParseBodyInBackground,
                  child: const Text('Post & Background Body Parser'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: convertListToJson,
              child: const Text('Convert 400000 Row To Json'),
            ),
            ElevatedButton(
              onPressed: backgroundConvertListToJson,
              child: const Text('Background Convert 400000 Row To Json'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: responseList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 0,
                    color: Colors.blueGrey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(responseList[index].title!),
                          const SizedBox(height: 15),
                          Image.network(responseList[index].url!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  get() async {
    _clearList();
    try {
      LoadingDialog.start(context);
      final response = await HttpClient().get('photos', header: {});
      if (response!.statusCode == HttpStatus.ok) {
        responseList = PhotoModel().jsonParser(response.bodyBytes);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }

  getAndParserInBackground() async {
    _clearList();
    try {
      LoadingDialog.start(context);
      final response = await HttpClient().get('photos', header: {});
      if (response!.statusCode == HttpStatus.ok) {
        responseList = await PhotoModel().backgroundJsonParser(response.bodyBytes);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }

  void _clearList() {
    responseList = [];
    setState(() {});
  }

  post() async {
    try {
      LoadingDialog.start(context);
      PostModel model = PostModel(title: 'title', body: 'body', userId: 1);
      String body = model.convertToJson();
      final response = await HttpClient().post('posts', header: {}, encodedBody: body);
      if (response!.statusCode == HttpStatus.created) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }

  postAndParseBodyInBackground() async {
    try {
      LoadingDialog.start(context);
      PostModel model = PostModel(title: 'title', body: 'body', userId: 1);
      String body = await model.backgroundConvertToJson();
      final response = await HttpClient().post('posts', header: {}, encodedBody: body);
      if (response!.statusCode == HttpStatus.created) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }

  convertListToJson() async {
    try {
      LoadingDialog.start(context);
      await Future.delayed(const Duration(milliseconds: 200));
      String bodyList = PostModel().convertToJson(list);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }

  backgroundConvertListToJson() async {
    try {
      LoadingDialog.start(context);
      await Future.delayed(const Duration(milliseconds: 200));
      String bodyList = await PostModel().backgroundConvertToJson(list);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      LoadingDialog.stop(context);
    }
  }
}

class LoadingDialog {
  static start(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.20),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
              decoration:
                  const BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }

  static stop(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).pop();
  }
}
