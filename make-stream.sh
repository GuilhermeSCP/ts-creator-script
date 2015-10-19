#!/bin/bash

export INPUT1="video.mp4"

mkdir tmp

echo "##STARTED##"

echo "PROCESSING VIDEO"
echo "Isolating video"
ffmpeg -i $INPUT1 -an -vcodec mpeg2video -r 25 -f mpeg2video -b 5000k -maxrate 5000k -minrate 5000k -bf 2 -bufsize 1835008 -y tmp/video1.mp2
echo "Creating video PES"
esvideompeg2pes tmp/video1.mp2 > tmp/video1.pes
echo "Creating video TS"
pesvideo2ts 2064 25 112 5270000 0 tmp/video1.pes > tmp/video.ts

echo "PROCESSING AUDIO"
echo "Isolating audio"
ffmpeg -i $INPUT1 -ac 2 -vn -acodec mp2 -f mp2 -ab 128000 -ar 48000 -y tmp/audio2.mp2
echo "Creating audio PES"
esaudio2pes tmp/audio2.mp2 1152 48000 384 -1 3600 > tmp/audio2.pes
echo "Creating audio TS"
pesaudio2ts 2068 1152 48000 384 -1 tmp/audio2.pes > tmp/audio.ts


echo "##FINISHED##"
