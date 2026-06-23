import 'package:music_player/features/music/data/models/song_model.dart';

abstract class MusicLocalDataSource {
  Future<List<SongModel>> getSongs();
}

class MusicLocalDataSourceImpl implements MusicLocalDataSource {
  @override
  Future<List<SongModel>> getSongs() async {
    // Artificial small delay to simulate reading database
    await Future<void>.delayed(const Duration(milliseconds: 300));
    
    return const [
      SongModel(
        id: '0',
        title: 'Eminim Mix',
        artist: 'Eminem',
        audioPath: 'assets/audio/music.mp3',
        imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/eminem_photo_by_dave_j_hogan_getty_images_entertainment_getty_187596325.jpg?resize=1200:*',
      ),
      SongModel(
        id: '1',
        title: 'Saaban Aleky',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Saaban-Aleky.mp3',
        imageUrl: 'https://mediaaws.almasryalyoum.com/news/large/2023/03/10/2052244_0.jpeg',
      ),
      SongModel(
        id: '2',
        title: 'Mesh Nadman',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Mesh-Nadman.mp3',
        imageUrl: 'https://i.ytimg.com/vi/RBOhI_2I2Qo/default.jpg',
      ),
      SongModel(
        id: '3',
        title: 'Meen Kan Sabab',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Meen-Kan-Sabab.mp3',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273fb7a625e739662cb3aac982e',
      ),
      SongModel(
        id: '4',
        title: 'Aleb Fel Dafater',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Aleb-Fel-Dafater.mp3',
        imageUrl: 'https://img.youtube.com/vi/uv2_g7wCvdw/0.jpg',
      ),
      SongModel(
        id: '5',
        title: 'Etnaset',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Etnaset.mp3',
        imageUrl: 'https://www.matb3aa.com/wp-content/uploads/2021/10/Etnasina-200x270.jpg',
      ),
      SongModel(
        id: '6',
        title: 'Abl Mawsalek',
        artist: 'MUSliM',
        audioPath: 'assets/audio/Abl-Mawsalek.mp3',
        imageUrl: 'https://artwork.anghcdn.co/webp/?id=144816215&size=296',
      ),
      SongModel(
        id: '7',
        title: 'Ghasb Anny',
        artist: 'MUSliM & Zap Tharwat',
        audioPath: 'assets/audio/Ghasb-Anny.mp3',
        imageUrl: 'https://i.ytimg.com/vi/M4g-21W_ey8/default.jpg',
      ),
    ];
  }
}
