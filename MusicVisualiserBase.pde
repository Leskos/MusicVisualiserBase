import controlP5.*;

private ControlP5 cp5;

// Use these to control your sketch
float bassLevel;
float midLevel;
float trebLevel;


void setup() 
{
  fullScreen();
  cp5 = new ControlP5(this);
  initAudioAnalysis( this );
}


void draw() 
{
  background(0);
  doAudioAnalysis();
  
  // Draw circles corresponding to bass/mid/treb levels
  ellipse( width/3,   height/2, bassLevel*100, bassLevel*100 );
  ellipse( width/2,   height/2, midLevel*100,  midLevel*100  );
  ellipse( width/3*2, height/2, trebLevel*100, trebLevel*100 );
  
}

// Press space to toggle audio analysis UI on/off 
void keyPressed()
{
  if ( key == ' ' )
  {
    toggleAudioAnalysisUI();
  }
}