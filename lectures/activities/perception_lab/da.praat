# Creates a KlattGrid object called "da".
Create KlattGrid... da 0 0.3 6 1 1 6 1 1 1
# add formant loci for /d/, from 0 to 0.03s is closure
Add oral formant frequency point... 1 0.03 150
Add oral formant bandwidth point... 1 0.03 50
Add oral formant frequency point... 2 0.03 1800
Add oral formant bandwidth point... 2 0.03 50
# add voicing amplitude, vowel formants, and pitch targets
Add voicing amplitude point... 0.0 0
Add voicing amplitude point... 0.04 90
Add voicing amplitude point... 0.25 90
Add voicing amplitude point... 0.3 60
Add pitch point... 0.0 150
Add pitch point... 0.3 120
Add oral formant frequency point... 1 0.08 750
Add oral formant frequency point... 2 0.08 1250
# synthesis
To Sound
Play