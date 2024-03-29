# Tagros (points counter)

## What is this app about?
### What is tagros?
Tarot is a classical French card game, competitively played with 4 players (with variants for 3 and 5 players), designed in different rounds, where the "attack" plays against the "defense", in order to win a certain amount of points. The attack and defense are different in each round.

> The [full rules](https://fftarot.fr/assets/documents/Reglement%20FFT.pdf) can be found on [the official website](https://fftarot.fr/). But you do not have to understand the rules in order to understand the principle of this application.

Tagros (note the different orthography) -- literally meaning tarot-gros, which means "Big tarot" -- is a variant designed by colleagues at work, in order to be able to play with more players at once, up to 10. It changes the amount of players in the attack and the defense, is played with 2 decks of cards, and the way the game works is slightly altered in order to accommodate for more players.

### Reasoning for this app
**This is the app to count the points for "Tagros" and Tarot, for 3-5 players and 7-10 players.** (6 players is not a viable number for the game, for the balance of it, as well as for the gameplay)

In order to win, we have to accumulate a certain amount of points (usually 1000) by playing games until one player attains this amount. In one game, the players agree on a contract during the bidding phase, or the winner of the bid becomes the attacker in that game (with or without partners, depending on the number of players and the distribution of cards), and the rest becomes the defense. 

To simplify, a contract is worth different points (it is a multiplier as a matter of fact), and we have different other ways of earning additional points, such as:
* Petit au bout (counted as points to be multiplied)
* Poignée (added after the multiplier is applied)
  * simple
  * double
  * triple
  
The amount of points that a camp (defense or attack) has to reach in a game in order to win it is different, depending on the number of "oudlers" (3 special cards) that you have won in your tricks. 

As all these rules for counting points accumulate, such an application to count the points becomes almost necessary in order to save time and concentrate on playing, and not counting the points.

### Shortcomings
This application does not take into account "chelem", which is when one camp wins all the tricks in a game, because it happens so rarely that the effort-to-gain ratio wasn't worth it.

## Building and launching the application

### Compilation

#### Common
```shell script
export APPSPECTOR=<my-android-appspector-key> # it is for debugging, you can also remove appspector instead
export APPSPECTORIOS=<my-ios-appspector-key> # same as above
dart tool/env.dart
flutter clean # (except the first time)
flutter pub global activate intl_utils # if the first time
flutter pub global run intl_utils:generate
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
``` 

#### Android
flutter build apk --split-per-abi

#### iOS (only on mac)
##### First time only:
```shell
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo gem install cocoapods
flutter run -d <ios-device-id> # if not working, then do below
```
##### When upgrading dependencies
```shell
cd ios/
pod install
cd ../
```
##### For building
```shell
flutter build ios
```

## Diagram of providers
```mermaid
flowchart TB
  subgraph Arrows
    direction LR
    start1[ ] -..->|read| stop1[ ]
    style start1 height:0px;
    style stop1 height:0px;
    start2[ ] --->|listen| stop2[ ]
    style start2 height:0px;
    style stop2 height:0px;
    start3[ ] ===>|watch| stop3[ ]
    style start3 height:0px;
    style stop3 height:0px;
  end

  subgraph Type
    direction TB
    ConsumerWidget((widget));
    Provider[[provider]];
  end
  CleanPlayersScreen((CleanPlayersScreen));
  cleanPlayerProvider ==> CleanPlayersScreen;
  cleanPlayerProvider -.-> CleanPlayersScreen;
  DialogChooseGame((DialogChooseGame));
  databaseProvider ==> DialogChooseGame;
  gamesDaoProvider -.-> DialogChooseGame;
  currentGameIdProvider -.-> DialogChooseGame;
  DialogChoosePlayers((DialogChoosePlayers));
  choosePlayerProvider ==> DialogChoosePlayers;
  choosePlayerProvider -.-> DialogChoosePlayers;
  DialogPlayerBody((DialogPlayerBody));
  choosePlayerProvider ==> DialogPlayerBody;
  AddModifyEntry((AddModifyEntry));
  currentGameProvider ==> AddModifyEntry;
  tableauViewModelProvider ==> TableauBody;
  tableauViewModelProvider -.-> AddModifyEntry;
  messageObserverProvider -.-> AddModifyEntry;
  TableauPage((TableauPage));
  messageObserverProvider[[messageObserverProvider]];
  tableauViewModelProvider ==> TableauPage;
  messageObserverProvider --> TableauPage;
  messageObserverProvider -.-> TableauPage;
  TableauBody((TableauBody));
  cleanPlayerProvider[[cleanPlayerProvider]];
  playerDaoProvider ==> cleanPlayerProvider;
  databaseProvider[[databaseProvider]];
  gamesDaoProvider[[gamesDaoProvider]];
  databaseProvider ==> gamesDaoProvider;
  currentGameIdProvider[[currentGameIdProvider]];
  choosePlayerProvider[[choosePlayerProvider]];
  playerDaoProvider ==> choosePlayerProvider;
  playerDaoProvider[[playerDaoProvider]];
  databaseProvider ==> playerDaoProvider;
  tableauRepositoryProvider[[tableauRepositoryProvider]];
  currentGameIdProvider ==> tableauRepositoryProvider;
  gamesDaoProvider ==> tableauRepositoryProvider;
  currentGameProvider[[currentGameProvider]];
  currentGameIdProvider ==> currentGameProvider;
  gamesDaoProvider ==> currentGameProvider;
  tableauViewModelProvider[[tableauViewModelProvider]];
  tableauRepositoryProvider ==> tableauViewModelProvider;
```
