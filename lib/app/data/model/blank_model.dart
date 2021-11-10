
import 'package:bradio/app/data/model/radio_stream/radio_stream.dart';

class BlankModel{
    static RadioStream get radioStream => RadioStream(
      bitrate: 0,
      favicon: '',
      homepage: '',
      language: '',
      languagecodes: '',
      name: '',
      state: '',
      tags: '',
      url: '',
      urlResolved: ''
    );
}