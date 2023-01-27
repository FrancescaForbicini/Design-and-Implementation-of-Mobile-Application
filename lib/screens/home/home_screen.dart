import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/services/questions_artist.dart';
import 'package:dima_project/services/questions_playlist.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;
import '../../customized_app_bar.dart';
import '../../generated/l10n.dart';
import '../quiz/quiz_generator.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();
  late var _userId;
  late List _playlists;
  late List _artists;
  late Future<bool> _done;
  late sp.Playlists  _playlists_quiz;
  late sp.Artists _artists_quiz;
  late sp.Pages<sp.Track> _tracksPages;
  late Iterable<sp.Track> _tracksIterator;
  late List<sp.Track> _tracks;

  @override
  void initState() {
    _done = _startup();
    super.initState();
  }

  Future<bool> _startup() async{

    print("Debugging here in startup method");
    var _user = await _spotifyService.spotify.me.get();
    print("User spotify: $_user");
    print("User spotify info: ${_user.displayName}, ${_user.country}, ${_user.product}, ${_user.id}");
    _userId = _user.id;
    print("Got the userid");
    print("UserID: $_userId");
    var _playlistsRef = _spotifyService.spotify.playlists;
    print("Got reference to playlists: ${_playlistsRef.runtimeType}");
    if(_playlistsRef != null){
      print("The reference exists!");
    }
    print(_playlistsRef.me.all().runtimeType);
    Iterable<sp.PlaylistSimple> playlists = await _playlistsRef.me.all();
    print(_playlistsRef.me.all().runtimeType);
    print("Got the playlists");
    print(playlists.runtimeType);
    _playlists = playlists.toList();
    _playlists_quiz = sp.Playlists(_spotifyService.spotify);
    _artists_quiz = sp.Artists(_spotifyService.spotify);
    Iterable<sp.Artist> artists = await _spotifyService.spotify.me.topArtists();
    print(artists.runtimeType);
    _artists = artists.toList();

    return true;
  }

  @override
  Widget build(BuildContext context) {

    final _appBar = CustomizedAppBar(
      leading: IconButton(
        icon: const Icon(Icons.logout, color: Colors.lightGreen,size: 30),
        onPressed: () => {
          _authenticationService.signOut(),
          Navigator.pop(context),
          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationScreen()))
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.lightGreen,size: 30),
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()))
          },
        ),
      ],
      title: AutoSizeText(
        S.of(context).HomeTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: const Key('home_scaffold'),
      appBar: _appBar,
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildHomeBody(_screenHeight - _appBarHeight - _statusBarHeight, _screenWidth, context),
    );
  }

  Widget _buildHomeBody(height, width, BuildContext context){
    Color? textColor = Theme.of(context).textTheme.bodyText1?.color;
    return ListView(
      key: const Key('home_screen'),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width,
                height: height * 0.1,
                child: AutoSizeText(
                  S.of(context).HomeStart,
                  style:  TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: width,
                height: height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width,
                      height: height * 0.05,
                      child: AutoSizeText(
                        S.of(context).HomePlaylist,
                        style: const TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.4,
                      child: _buildPlaylists(height, width, context),
                    )
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width,
                      height: height * 0.05,
                      child: AutoSizeText(
                        S.of(context).HomeArtists,
                        style: const TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.4,
                      child: _buildArtists(height, width, context),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPlaylists(height, width, BuildContext context) {
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          if(_playlists.length > 0){
            child = ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _playlists.length,
              itemBuilder: (context, index){

                return Container(
                  width: width * 0.35,
                  height: height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Ink.image(
                            width: width * 0.25,
                            height: height * 0.25,
                            image: getImage(_playlists[index].images),
                          ),
                          onTap:() async{
                            _tracksPages = await _playlists_quiz.getTracksByPlaylistId(_playlists[index].id);
                            _tracksIterator = await _tracksPages.all();
                            _tracks = _tracksIterator.toList();
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => QuizGenerator(_tracks,"playlists",0,1)));
                          } ,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.25,
                        height: height * 0.1,
                        child: AutoSizeText(
                          _playlists[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText2?.color,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          else{
            child = Container(
              width: width,
              height: height * 0.35,
              child: AutoSizeText(
                S.of(context).HomeErrPlaylist,
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Colors.lightGreen,
                  fontSize: 18,
                ),
              ),
            );
          }

          return child;
        }
        else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.lightGreen,
            ),
          );
        }
      },
    );
  }

  Widget _buildArtists(height, width, BuildContext context){
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          if(_artists.length > 0){
            child = ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _artists.length,
              itemBuilder: (context, index){
                return Container(
                  width: width * 0.35,
                  height: height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Ink.image(
                            width: width * 0.25,
                            height: height * 0.25,
                            //fit: BoxFit.cover,
                            image: getImage(_artists[index].images),
                          ),
                          onTap:() async{
                            sp.Artist artist = await _artists_quiz.get(_artists[index].id);
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => QuizGenerator(artist,"artists",0,1)));

                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.25,
                        height: height * 0.1,
                        child: AutoSizeText(
                          _artists[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:Theme.of(context).textTheme.bodyText2?.color,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          else{
            child = Container(
              width: width,
              height: height * 0.35,
              child: AutoSizeText(
                S.of(context).HomeErrArtists,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 18,
                ),
              ),
            );
          }

          return child;
        }
        else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.lightGreen,
            ),
          );
        }
      },
    );
  }
}

ImageProvider<Object> getImage(image){
  if (image.isEmpty) {
    return Image.asset('images/wolf_user.png').image;
  }
  return Image.network(image[0].url).image;
}


