import 'package:flutter/material.dart';

class SongSheetPage extends StatefulWidget {
  final Map<String, dynamic> data;

  SongSheetPage({required this.data});

  @override
  _SongSheetPageState createState() => _SongSheetPageState();
}

class _SongSheetPageState extends State<SongSheetPage> {
  late List<String> verses;
  int currentVerseIndex = 0;
  late String chordKey;

  @override
  void initState() {
    super.initState();
    _getDataFromJson();
    verses = widget.data['data'].keys.toList();
  }

  void _getDataFromJson() {
    chordKey = widget.data['key'];
  }

  void _nextVerse() {
    setState(() {
      if (currentVerseIndex < verses.length - 2) {
        currentVerseIndex += 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  int verseIndex = currentVerseIndex + index;
                  if (verseIndex < verses.length) {
                    String verseTitle = verses[verseIndex];
                    List<dynamic> verseData = widget.data['data'][verseTitle];
                    return VerseWidget(
                      verseTitle: verseTitle,
                      verseData: verseData,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _nextVerse,
              child: const Text('Next Verses'),
            ),
          ],
        ),
      ),
    );
  }
}

class VerseWidget extends StatelessWidget {
  final String verseTitle;
  final List<dynamic> verseData;

  VerseWidget({required this.verseTitle, required this.verseData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verseTitle,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            ...verseData.map((item) {
              if (item is Map<String, dynamic>) {
                List<List<dynamic>> chords = List<List<dynamic>>.from(item['chords']);
                String lyrics = item['lyrics'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildChordLyricPair(chords, lyrics),
                );
              } else {
                return Container();
              }
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChordLyricPair(List<List<dynamic>> chords, String lyrics) {
    // Split lyrics into individual characters
    List<String> lyricsChars = lyrics.split('');

    // List to hold text spans with chords and lyrics
    List<InlineSpan> textSpans = [];

    int chordIndex = 0;
    for (int i = 0; i < lyricsChars.length; i++) {
      // Check if the current position has a chord
      if (chordIndex < chords.length && chords[chordIndex][1] == i) {
        textSpans.add(
          WidgetSpan(
            child: Column(
              children: [
                Text(
                  chords[chordIndex][0],
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(lyricsChars[i]),
              ],
            ),
          ),
        );
        chordIndex++;
      } else {
        textSpans.add(
          TextSpan(
            text: lyricsChars[i],
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        children: textSpans,
      ),
    );
  }
}
