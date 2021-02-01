set ffmpeg="D:\Sal\tools\ffmpeg\bin\ffmpeg.exe"
set awk="D:\Sal\tools\awk.exe"

set file=%1
set ovrfile=%2

echo %file%, %ovrfile%
type %file% | %awk% "BEGIN { 
    if(length(\"$ovrfile\")!=0){
      printf(\"OVRFILE \\\"%s\\\" WAVE\n\",\"$ovrfile\")
    }
  } {print}" | %awk% -F"( )+|:" ' ^
  BEGIN { ^
    inpoint=0;
    track=0;
    outpoint=0;
  }
  /OVRFILE/ {
    split($0,ovrfile,"\"");
    split($0,ext,/[".]/);
    (ext[3]=="flac")? codec="flac" : codec="copy";
    printf("# OVERRIDING cuesheet source with \"%s\" \n",ovrfile[2]);
    file=ovrfile[2];
  }
  /FILE/ {
    if(length(ovrfile[2])==0){
      split($0,fileLn,"\"");
      split($0,ext,/[".]/);
      (ext[3]=="flac")? codec="flac" : codec="copy";
      file=fileLn[2];
    }
  }
  /TITLE/ {
    if(track!=0){
      split($0,tracktitle,"\"");
    } else {
      split($0,album,"\"");
    }
  }
  /TRACK / {
    track=$3;
  }
  /INDEX 01/ {
    if(track==1){
      outpoint=($4*60)+$5+($6/75);
      inpoint=outpoint
      title=tracktitle[2];
    } else {
      outpoint=($4*60)+$5+($6/75);
      printf("ffmpeg -nostdin -n -i \"%s\" -ss %s -to %s -c: %s \"%02d - %s.%s\"\n",file,inpoint,outpoint,codec,(track-1),title,ext[3]);
      inpoint=outpoint
      title=tracktitle[2];
    }
  }
  END {
    outpoint=($4*60)+$5+($6/75);
    printf("ffmpeg -nostdin -n -i \"%s\" -ss %s -c: %s \"%02d - %s.%s\"\n",file,inpoint,codec,track,title,ext[3]);
    inpoint=outpoint
}'
