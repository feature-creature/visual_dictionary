import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.pdf.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Visual_dict extends PApplet {

/////////////////////////////////////////
// A Visual Dictionary                //
// Lior Ben-Gai                      //
// November 2017                    //
/////////////////////////////////////

/////////////////////////////////////
// Acknowledgments:
// This Template is inspired by:

// RandomBook.pde example
// https://github.com/processing/processing/blob/master/java/libraries/pdf/examples/RandomBook/RandomBook.pde

// CountingStrings example
// https://github.com/processing/processing-docs/blob/master/content/examples/Topics/Advanced%20Data/CountingStrings/CountingStrings.pde

// Dictionary file source:
// https://raw.githubusercontent.com/sujithps/Dictionary/master/Oxford%20English%20Dictionary.txt
/////////////////////////////////////


PGraphicsPDF pdf;

int wordCounter, pageCounter, numWords;
ArrayList<String> words;

int gs = 256; // Grid Size
PFont wordFont, pageFont, titleFont;

///////////////////////////////////////////////
// SETUP
///////////////////////////////////////////////
public void setup()
{
  
  //textMode(SHAPE); // might need this for certain fonts!

  init();

  // start recording the output file
  pdf = (PGraphicsPDF)beginRecord(PDF, "Visual_Oxford_dict.pdf");
  beginRecord(pdf);
}

///////////////////////////////////////////////
// DRAW
///////////////////////////////////////////////
public void draw()
{
  background(255);

  if(pageCounter == 0){
    // FIRST PAGE
    drawCover();
    pdf.nextPage();
    pageCounter++;
  }else{

    // PAGE CONTENT
    pushMatrix();
    translate(216,482); // move to grid start position
    drawPageGrid();

    // move to each cell and draw a single word in it
    for(int i = 0; i < 11; i++){
      for(int k = 0; k < 8; k++){
        // Next word
        if(wordCounter < numWords){
          pushMatrix();
          translate(k*gs, i*gs);

          drawWord( words.get(wordCounter) );

          wordCounter++;
          popMatrix();
        }else{
          break; // if we run out of words - break the loop
        }
      }
    }
    popMatrix();

    drawPageInfo(); // (big letter and page number)

    // NEXT PAGE OR QUIT
    if(wordCounter >= numWords) {
      drawBackCover();
      //  and flush the file
      endRecord(); // close export
      exit(); // quit program
    } else {
      // move to the next page
      pdf.nextPage();
    }
  }
}

///////////////////////////////////////////////
// THIS IS WHERE THE MAGIC HAPPENS
///////////////////////////////////////////////

public void drawWord(String word){

  // The size in this context is: 256 by 256

  //draw the shape
  for(int i = 0; i < word.length(); i++){

    char letter = word.charAt(i);

    float val = map( PApplet.parseInt(letter) , 97, 122, 210, 10  );
    stroke(0);
    strokeWeight(4);
    line(i*10, 200, i*10, val);

  }

  // write the word
  textAlign(LEFT, CENTER);
  fill(64);
  textFont(wordFont);
  text(word,20,gs - 20);
}


///////////////////////////////////////////////
// HELPERS (to keep it tidy)
///////////////////////////////////////////////

public void drawPageInfo(){
  // current letter
  fill(0);
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  text(words.get(wordCounter-1).charAt(0),width/2, 241);
  // page number
  textFont(pageFont);
  text(pageCounter++,width/2,height-120);
}

public void drawCover(){
  // FIRST PAGE
  fill(0);
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  text("A Visual Dictionary",width/2, height/2);
  textFont(pageFont);
  text("Lior Ben-Gai",width/2, height/2+ 100);
  text("November 2017",width/2, height/2+ 200);
}

public void drawBackCover(){
  pdf.nextPage(); // add a blank page
}

public void drawPageGrid(){
  stroke(200);
  for(int i = 0; i < 12; i++){
    line(0,i*gs,2048,i*gs);
  }
  for(int i = 0; i < 9; i++){
    line(i*gs,0,i*gs, 2816);
  }
}

public void init(){
  // create fonts
  wordFont = createFont("Arial", 20);
  pageFont = createFont("Arial", 40);
  titleFont = createFont("Arial", 80);

  // Load the entire dictionary into an array of strings
  println("starting import... ");
  String[] lines = loadStrings("Oxford_English_Dictionary.txt");

  // Obtain just the first word in each line and store it
  words = new ArrayList<String>();
  for(int i = 0; i < lines.length; i++){

    int idx = lines[i].indexOf(" "); // index of the first space
    if(idx > 0){
      String word = lines[i].substring(0,idx); // get the word before it
      // igonre the "Usage" lines
      if(word.equals("Usage") == false){
        words.add(word); // store the word
      }
    }
  }

  // now the words ArrayList should have all the words!

  // initialize counters
  wordCounter = 0;
  pageCounter = 0;
  numWords = words.size();

  println("Ready! " + numWords + " words loaded.");
}
  public void settings() {  size( 2480, 3508); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Visual_dict" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
