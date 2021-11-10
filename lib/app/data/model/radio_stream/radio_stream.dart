// To parse this JSON data, do
//
//     final radioStream = radioStreamFromMap(jsonString);

import 'dart:convert';

class RadioStream {
  RadioStream({
    required this.name,
    required this.url,
    required this.urlResolved,
    required this.homepage,
    required this.favicon,
    required this.tags,
    required this.state,
    required this.language,
    required this.languagecodes,
    required this.bitrate
  });

  String name;
  String url;
  String urlResolved;
  String homepage;
  String favicon;
  String tags;
  String state;
  String language;
  String languagecodes;
  int bitrate;

  factory RadioStream.fromJson(String str) => RadioStream.fromMap(json.decode(str));


  factory RadioStream.fromMap(Map<String, dynamic> json) => RadioStream(
    name: json["name"].trim(),
    url: json["url"].trim(),
    urlResolved: json["url_resolved"].trim() ,
    homepage: json["homepage"].trim(),
    favicon: json["favicon"].trim(),
    tags: json["tags"].trim(),
    state: json["state"].trim(),
    language: json["language"].trim(),
    languagecodes: json["languagecodes"].trim(),
    bitrate: json["bitrate"]
  );
}
