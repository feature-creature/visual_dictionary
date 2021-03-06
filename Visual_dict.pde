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

// CountincellSizetrincellSize example
// https://github.com/processing/processing-docs/blob/master/content/examples/Topics/Advanced%20Data/CountincellSizetrincellSize/CountincellSizetrincellSize.pde

// Dictionary file source:
// https://raw.githubusercontent.com/sujithps/Dictionary/master/Oxford%20English%20Dictionary.txt
/////////////////////////////////////

/*
 Author: Luke Demarest
 Name: visual dictionary
 Date: November 2017
 License: GLP 3
 */

/*
   TODO: create your own alphabyte font
 */

// import pdf library
import processing.pdf.*;
// draw into offscreen graphics buffer
PGraphicsPDF pdf;

// delcare and intialize constants
// cell size
static int cellSize = 256;

// declare global variables
int wordCounter;
int pageCounter;
int numWords;
ArrayList<String> words;
PFont wordFont, pageFont, titleFont;


void setup()
{
    // ?? why this size, standard paper size by pixels?
    size( 2480, 3508);
    //textMode(SHAPE); // might need this for certain fonts!

    // ?? what does this do specifically?
    init();
    // initialize graphics buffer
    pdf = (PGraphicsPDF)beginRecord(PDF, "Visual_Oxford_dict.pdf");
    // start recording the output file
    beginRecord(pdf);
}


void draw()
{
    background(255);

    if (pageCounter == 0) {
        // FRONT COVER PAGE
        drawCover();
        pdf.nextPage();
        pageCounter++;
    } else {

        // CONTENT PAGE
        pushMatrix();
        stroke(155);
        fill(155);
        rect(0,0,width,height);
        // translate entire matrix to start position
        translate(216, 482);
        // draw series of lines to form a grid outline
        //drawPageGrid();
        // !! perhaps redundant looping
        // iterate across the current page rows by columns
        // 11 rows
        // 8 colums
        for (int i = 0; i < 8; i++) {
            for (int k = 0; k < 8; k++) {
                if (wordCounter < numWords) {
                    pushMatrix();
                    // translate to cell's location on page
                    translate(k*cellSize, i*cellSize);
                    // draw current word
                    drawWord( words.get(wordCounter) );
                    // update index of the dictionary
                    wordCounter++;
                    popMatrix();
                } else {
                    // break loop if there are no more words
                    break;
                }
            }
        }
        popMatrix();

        // draw page metadata (page Letter and page number)
        drawPageInfo();

        // ?? why is back cover in a subroutine and front cover not
        // create NEXT PAGE or (draw BACK COVER PAGE and quit program)
        if (wordCounter >= numWords) {
            // create blank back cover page
            drawBackCover();
            //  export the pdf
            endRecord();
            // quit program
            exit();
        } else {
            // create a successive page
            pdf.nextPage();
        }
    }
}


void drawWord(String word) {
    //draw the shape
    for (int i = 0; i < word.length(); i++) {
        pushMatrix();
        translate(25, cellSize/1.35);
        String bi = binary(word.charAt(i)).substring(8, 16);
        int bi0 = 0;
        int bi1 = bi.charAt(1) == '1' ? 10 : 0;
        int bi2 = bi.charAt(2) == '1' ? 20 : 10;
        int bi3 = bi.charAt(3) == '1' ? 20 : 10;
        int bi4 = bi.charAt(4) == '1' ? -10 : 0;
        int bi5 = bi.charAt(5) == '1' ? 10 : 0;
        int bi6 = bi.charAt(6) == '1' ? 20 : 10;
        int bi7 = bi.charAt(7) == '1' ? 20 : 10;
        if (i > 0) {
            int startingX  = 0;
            int startingY = 0;
            for (int j = 0; j < i; j++) {
                int bj1 = binary(word.charAt(j)).substring(8, 16).charAt(1) == '1' ? 10 : 0;
                int bj5 = binary(word.charAt(j)).substring(8, 16).charAt(4) == '1' ? 10 : 0;
                int bj4 = binary(word.charAt(j)).substring(8, 16).charAt(5) == '1' ? -10 : 0;
                startingX += (bj1 + bj5);
                startingY += bj4;
            }
            translate(startingX, startingY);
        }
        fill(255);
        stroke(255);
        ellipse(0, 0, 5, 5);
        line(0, 0, bi1, bi0);
        translate(bi1, bi0);
        ellipse(0, 0, 5, 5);
        noFill();
        ellipse(0, 0, bi2, bi3);
        fill(255);
        line(0, 0, 0, bi4);
        ellipse(0,bi4,5,5);
        line(0, bi4, bi5, bi4);
        translate(bi5, bi4);
        ellipse(0, 0, 5, 5);
        noFill();
        ellipse(0, 0, bi6, bi7);



        popMatrix();
    }

    // write the word
    textAlign(LEFT, CENTER);
    fill(255);
    textFont(wordFont);
    text(word, 20, cellSize - 30);
}


///////////////////////////////////////////////
// HELPERS (to keep it tidy)
///////////////////////////////////////////////

void drawPageInfo() {
    // write current letter as title
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(titleFont);
    text(words.get(wordCounter-1).charAt(0), width/2, 241);
    // write page number in footer
    textFont(pageFont);
    text(pageCounter++, width/2, height-120);
}

void drawCover() {
    // BOOK TITLE
    fill(0);
    textFont(titleFont);
    textAlign(CENTER, CENTER);
    text("Alphabyte", width/2, height/2);
    textFont(pageFont);
    text("Luke Demarest", width/2, height/2+ 100);
    text("November 2017", width/2, height/2+ 200);
}

void drawBackCover() {
    // blank page
    pdf.nextPage();
}

void drawPageGrid() {
    // grid outline
    stroke(200);
    for (int i = 0; i < 12; i++) {
        line(0, i*cellSize, 2048, i*cellSize);
    }
    for (int i = 0; i < 9; i++) {
        line(i*cellSize, 0, i*cellSize, 2816);
    }
}

void init() {
    // create fonts
    wordFont = createFont("Arial", 20);
    pageFont = createFont("Arial", 40);
    titleFont = createFont("Arial", 80);

    // Load the entire dictionary into an array of strincellSize
    println("starting import... ");
    String[] lines = loadStrings("Oxford_English_Dictionary.txt");

    // !! rewrite this for clarity and accuracy
    // Obtain just the first word in each line and store it
    words = new ArrayList<String>();
    for (int i = 0; i < lines.length; i++) {

        int idx = lines[i].indexOf(" "); // index of the first space
        if (idx > 0) {
            String word = lines[i].substring(0, idx); // get the word before it
            // igonre the "Usage" lines
            if (word.equals("Usage") == false) {
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