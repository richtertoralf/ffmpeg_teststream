#!/bin/bash

################################################################################
# FFmpeg Streaming Script
#
# This script demonstrates optimized FFmpeg command usage to generate a video
# stream with audio and output it to an SRT server address. It includes comments
# to explain each step of the command for clarity and readability.
################################################################################

# Set the target SRT server address
targetServer="srt://0.0.0.0:9999?mode=listener&pkt_size=1316"

# Use FFmpeg to perform the following tasks:
# - Create a video source using the testsrc filter
# - Create an audio source with a sine wave at 1000 Hz using the sine filter
# - Apply a filter complex to handle video scaling and nullify audio from testsrc
# - Map the processed video and audio streams
# - Set the output frame rate to 10 FPS
# - Use libx264 as the video codec with specific settings
# - Use mp3 as the audio codec with specific settings
# - Set the output format to MPEG-TS
# - Overwrite output files without prompting
ffmpeg \
  -f lavfi -i testsrc \
  -f lavfi -i sine=frequency=1000 \
  -filter_complex "[0:v]scale=720:480,format=yuv420p[v];[1:a]anull[aout]" \
  -map "[v]" -map "[aout]" \
  -r 10 \
  -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -b:v 500k \
  -c:a mp3 -b:a 160k -ar 44100 \
  -f mpegts \
  -y "$targetServer"
