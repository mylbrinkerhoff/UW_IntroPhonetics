
# Praat script to generate sounds

# Pure sine wave
Create Sound from formula: "sine_1", 1, 0, 1, 44100, "0.25 * sin(2 * pi * 440 * x)"
Save as WAV file: "sine_1.wav"

Create Sound from formula: "sine_2", 1, 0, 1, 44100, "0.3 * sin(2 * pi * 100 * x)"
Save as WAV file: "sine_2.wav"

Create Sound from formula: "sine_3", 1, 0, 1, 44100, "0.75 * sin(2 * pi * 337 * x)"
Save as WAV file: "sine_3.wav"

Create Sound from formula: "sine_4", 1, 0, 1, 44100, "0.5 * sin(2 * pi * 74 * x)"
Save as WAV file: "sine_4.wav"

Create Sound as pure tone: "sine_5", 1, 0, 0.4, 44100, 437, 0.2, 0.01, 0.01
Save as WAV file: "sine_5.wav"

Create Sound as pure tone: "sine_6", 1, 0, 0.4, 44100, 200, 0.2, 0.01, 0.01
Save as WAV file: "sine_6.wav"


# Complex tone with harmonics 
Create Sound from formula: "harmonics_1", 1, 0, 1, 44100, "0.5*sin(2*pi*440*x) + 0.3*sin(2*pi*880*x) + 0.2*sin(2*pi*1320*x)"
Save as WAV file: "harmonics_1.wav"

Create Sound from formula: "harmonics_2", 1, 0, 1, 44100, "0.5*sin(2*pi*125*x) + 0.3*sin(2*pi*(125*2)*x) + 0.2*sin(2*pi*(125*3)*x)"
Save as WAV file: "harmonics_2.wav"

Create Sound from formula: "harmonics_3", 1, 0, 1, 44100, "0.5*sin(2*pi*334*x) + 0.3*sin(2*pi*(334*2)*x) + 0.2*sin(2*pi*(334*3)*x)"
Save as WAV file: "harmonics_3.wav"

# Harmonics missing
Create Sound from formula: "harmonics_missing", 1, 0, 1, 44100, "0.5*sin(2*pi*(125*3)*x) + 0.3*sin(2*pi*(125*4)*x) + 0.2*sin(2*pi*(125*5)*x) "
Save as WAV file: "harmonics_missing.wav"

# Gliding f0s over 1 second
Create Sound from formula: "glide_01", 1, 0, 1, 44100, "0.75 * sin(2*pi*(300 + (300 * x))*x)"
Save as WAV file: "glide_01.wav"

Create Sound from formula: "glide_02", 1, 0, 1, 44100, "0.75 * sin(2*pi*(100 + (300 * x))*x)"
Save as WAV file: "glide_02.wav"

# Create sine with noise
Create Sound from formula: "sineWithNoise", 1, 0, 1, 44100, "1/2 * sin(2*pi*377*x) + randomGauss(0,0.1)"
Save as WAV file: "sineWithNoise.wav"

# Create the source for source-filter demos
Create Sound as tone complex: "toneComplex", 0, 1, 44100, "cosine", 100, 100, 22000, 200
Save as WAV file: "source_1.wav"



