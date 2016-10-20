

int w, h;
int abc = 100;
boolean showAudioUI = true;



void updateAudioUI()
{ 
  if ( frameCount > 5 )     // Workaround for null pointer error when ControlFrame's
  {                        // setup() function runs after main sketch's
    String controllerName;
    for ( int i=0; i<numZones; i++ )
    {
      controllerName = "freq" + (i+1);
      cp5.getController( controllerName ).setValue( audioFreqs[i] );
    }

    cp5.getController( "Bass" ).setValue( bassLevel );
    cp5.getController( "Mid" ).setValue( midLevel );
    cp5.getController( "Treb" ).setValue( trebLevel );
  }
  
}

public void toggleAudioAnalysisUI()
{
  showAudioUI = !showAudioUI;
  
  if( showAudioUI )
  {
    cp5.getController( "Bass"       ).show();
    cp5.getController( "Mid"        ).show();
    cp5.getController( "Treb"       ).show();
    cp5.getController( "masterGain" ).show();
    cp5.getController( "bassGain"   ).show();
    cp5.getController( "midGain"    ).show();
    cp5.getController( "trebGain"   ).show();
    cp5.getController( "easing"     ).show();
    for ( int i=0; i<numZones; i++ )
    {
      cp5.getController( "freq" + (i+1) ).show();
    }
  }
  else
  {
    cp5.getController( "Bass"       ).hide();
    cp5.getController( "Mid"        ).hide();
    cp5.getController( "Treb"       ).hide();
    cp5.getController( "masterGain" ).hide();
    cp5.getController( "bassGain"   ).hide();
    cp5.getController( "midGain"    ).hide();
    cp5.getController( "trebGain"   ).hide();
    cp5.getController( "easing"     ).hide();
    for ( int i=0; i<numZones; i++ )
    {
      cp5.getController( "freq" + (i+1) ).hide();
    }
  }
}


public void initAudioUI() 
{
  int uiX = 10;
  int uiY = 10;

  // ADD THE AUDIO FREQUENCY SLIDERS
  String sliderName;
  float freqMin = 0;
  float freqMax = 30;

  for ( int i=0; i<numZones; i++ )
  {
    sliderName = "freq" + (i+1);

    cp5.addSlider( sliderName )
      .setPosition( uiX + (i*50), uiY )
      .setSize(20, 100)
      .setRange( freqMin, freqMax )
      ;
  }

  uiY += 120;

  cp5.addSlider( "Bass" )
    .setPosition( uiX + 270, uiY )
    .setSize(30, 100)
    .setRange( 0, 1 )
    ;

  cp5.addSlider( "Mid" )
    .setPosition( uiX + 330, uiY )
    .setSize(30, 100)
    .setRange( 0, 1 )
    ;

  cp5.addSlider( "Treb" )
    .setPosition( uiX + 390, uiY )
    .setSize(30, 100)
    .setRange( 0, 1 )
    ; 

  uiY +=5;

  cp5.addSlider( "masterGain" )
    .setPosition( uiX, uiY )
    .setSize(200, 20)
    .setRange( 0, 5 )
    .plugTo("audioGain")
    .setDefaultValue(1f)
    .setValue(1f)
    ;

  uiY += 25;

  cp5.addSlider( "bassGain" )
    .setPosition( uiX, uiY )
    .setSize(200, 20)
    .setRange( 0, 3 )
    .plugTo("bassGain")
    .setDefaultValue(1f)
    .setValue(1f)
    ;

  uiY += 25;

  cp5.addSlider( "midGain" )
    .setPosition( uiX, uiY )
    .setSize(200, 20)
    .setRange( 0, 3 )
    .plugTo("midGain")
    .setDefaultValue(1f)
    .setValue(1f)
    ;

  uiY += 25;

  cp5.addSlider( "trebGain" )
    .setPosition( uiX, uiY )
    .setSize(200, 20)
    .setRange( 0, 3 )
    .plugTo("trebGain")
    .setDefaultValue(1f)
    .setValue(1f)
    ;

  uiY += 30;

  cp5.addSlider( "easing" )
    .setPosition( uiX, uiY )
    .setSize(200, 20)
    .setRange( 0.6, 0.01 )
    .plugTo("audioEaseDown")
    .setDefaultValue(0.1f)
    .setValue(0.1f)
    ;
}