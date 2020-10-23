# rpp-to-cue

Simple awk and bash script to scrape the markers out of a [REAPER](https://www.reaper.fm/) project and format them to a .cue sheet suitable for CD burning or playback in audio apps like [foobar2000](https://www.foobar2000.org/).

## Usage
```bash
rpp-to-cue "awesome-vinyl-rip.RPP" > "awesome-vinyl-rip.cue"
```

By default it just puts everything into stdout. This is in case you want to pipe it into other tools. To get a file, just use redirects as above.

## Reaper project format
Reaper projects need markers with track marks. The format is the same as for the old ReaBurn (which is well unmaintained and windows only).

- drop a marker for every index
  - index 0 marks (track pre-gap) have no label but the "*" character
  - index 1 marks (the beginning of a track) are prefixed with a "#" and the track title, eg: `#The Rain Song`
  - currently markers that cover a region are treated like tracks with their length ignored.

# cue-split

This does almost the opposite. It reads a cuesheet and splits the source file (losslessly) by the track marks within, naming the files by the track number and title. 

This will likely work for video too if you were inclined to try such a thing.

## Dependencies

- ffmpeg somewhere in path and a functioning bash terminal with awk

## Usage

```bash
cue-split "my-cuefile.cue" ["alternate-source-audio.mp3"]
```
Run without a second argument it will read the "FILE" line and grab the input filename from there. Make sure it's in the right place, as with any cue file.

Run it with a second argument and that will override the file specified in the cue. A use case here is chopping an already compressed file by the cue sheet for the original uncompressed audio.

## To do
- It would be reasonably simple to have ffmpeg write tags to the output files based on the artist, album and title fields.
- Some cuesheets also have replaygain info written in REM lines which I could read, translate and apply as a tag to the output files too.