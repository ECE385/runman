This is a SD card .WAV player made for the Real Digital Urbana Board.
It is compatible with 44.1KHz stereo 16-bit PCM data.
It can play up to 8 songs (tracks 0-7) from an SD card, each song up to 9.5 minutes long.

To load files copy all the data after the DATA subchunk header in a .wav file (start copying from offset 0x28)
The FPGA player expects the beginning of each song at blocks divisible by 0x30000 (first song at 0x0, second at block 0x3000/byte 0x6000000, etc.)

The player starts up in the pause state, ready to play track 0. 

Button Mapping
Button 0: Reset
Button 1: Play/pause
Button 2: Next track
Button 3: Previous track