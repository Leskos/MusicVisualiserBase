
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim      minim;       // Minim audio library
AudioInput audioIn;     // Audio input
FFT        fft;         // Frequency analysis
BeatDetect beat;        // Beat detection


// Audio analysis parameters
int   numZones         = 20;      
int   sampleRate       = 44100;
int   bufferSize       = 512;
int   minBassThreshold = 10;
int   minMidThreshold  = 2;
float minTrebThreshold = 0.4;

float[] audioFreqs;

float masterGain    = 1.0;
float bassGain      = 1.0;
float midGain       = 1.0;
float trebGain      = 1.0;

float audioEaseDown = 0.1f;

void initAudioAnalysis( Object mainApplet )
{
  audioFreqs = new float[numZones];
  minim   = new Minim( mainApplet );
  audioIn = minim.getLineIn( Minim.STEREO, bufferSize );
  fft     = new FFT( audioIn.bufferSize(), audioIn.sampleRate() );
  fft.logAverages( 86, 1 );  // first parameter specifies the size of the smallest octave to use (in Hz), second is how many bands to split each octave into results in 9 bands
  fft.window( FFT.HAMMING );
  numZones = fft.avgSize();  // avgSize() returns the number of averages currently being calculated
  
  initAudioUI();
}


void doAudioAnalysis()
{
  fft.forward( audioIn.mix ); // perform forward FFT on ins mix buffer
  int highZone = numZones - 1;

  // FOR EACH FREQUENCY RANGE -  9 bands / zones / averages
  for (int i = 0; i < numZones; i++) 
  {     
    float average = fft.getAvg(i); // return the value of the requested average band, ie. returns averages[i]
    float avg = 0;
    int lowFreq;
    
    // If i = 0 then set lowFreq to 0
    if ( i == 0 ) 
    {
      lowFreq = 0;
    }
    // if i doesn't equal 0, then set lowFreq to the highest possible frequency divided by 
    else 
    {
      lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
    }

    int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, highZone - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050

    // ***** ASK FOR THE INDEX OF lowFreq & hiFreq USING freqToIndex ***** //
    // freqToIndex returns the index of the frequency band that contains the requested frequency
    int lowBound = fft.freqToIndex(lowFreq);
    int hiBound  = fft.freqToIndex(hiFreq);

    for ( int j = lowBound; j <= hiBound; j++ )  // j is 0 - 256 
    { 
      float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[offset]
      avg += spectrum; // avg += spectrum[j];
    }

    avg /= (hiBound - lowBound + 1);
    
    float prevVal = audioFreqs[i];
    float newVal  = avg * masterGain;
    
    if( newVal < prevVal )
    {
      audioFreqs[i] += (newVal - prevVal) * audioEaseDown;
    }
    else
    {
      audioFreqs[i] = avg * masterGain;
    }
    updateAudioUI();
  } 
  
  bassLevel = audioFreqs[0] + audioFreqs[1] + audioFreqs[2];
  midLevel  = audioFreqs[3] + audioFreqs[4] + audioFreqs[5];
  trebLevel = audioFreqs[6] + audioFreqs[7] + audioFreqs[8]; 
  
  bassLevel *= 0.3;      // Arbitrary pre-scaling 
  midLevel  *= 2.0;      // Arbitrary pre-scaling
  trebLevel *= 10;        // Arbitrary pre-scaling
  
  bassLevel *= bassGain; // Applying gain
  midLevel  *= midGain;  // Applying gain
  trebLevel *= trebGain; // Applying gain
  
  bassLevel = constrain( bassLevel, 0, 100 ) / 100;  // Normalising 0-1
  midLevel  = constrain( midLevel,  0, 100 ) / 100;  // Normalising 0-1
  trebLevel = constrain( trebLevel, 0, 100 ) / 100;  // Normalising 0-1
}