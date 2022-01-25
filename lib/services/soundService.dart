
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
    //Just pass the file name only.
    return await cache.play("swipe.mp3");
  }

  Future<AudioPlayer> Click1() async {
    AudioCache cache = new AudioCache();
    //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
    //Just pass the file name only.
    return await cache.play("click-1.mp3");
  }

  Future<AudioPlayer> dialog() async {
    AudioCache cache = new AudioCache();
    //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
    //Just pass the file name only.
    return await cache.play("gquiz pop.mp3");
  }
}
