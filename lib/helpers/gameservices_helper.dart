import 'package:games_services/games_services.dart';

class GamesServicesHelper {
  void loadGamesService() async {
    await GamesServices.isSignedIn
        ? print("\n1: GAMESERVICES: SIGN")
        : print("\n1: GAMESERVICES: NOT SIGN");
    if (!await GamesServices.isSignedIn) {
      GamesServices.signIn();
    }
    await GamesServices.isSignedIn
        ? print("\n2: GAMESERVICES: SIGN")
        : print("\n2: GAMESERVICES: NOT SIGN");
  }
}
