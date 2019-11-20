import processing.video.*;

ArrayList<blob> Obj;
Capture cam;
boolean showPic = true;
boolean found = false;
boolean modified = false;
boolean mod = false;
boolean doItNow = true;
boolean things = true;
float maxRGB = 25, maxCont = 80;
PImage cont; 
float diff[] = new float[3];
int choice = 1;
PImage lastF;
PImage eyes; 
float prop = 1;
PImage imgs[] = new PImage[10];
PImage eye;
float ang = 0;

int mX = 0;
int mY = 0;

void setup() {
  //size(640, 480);
  fullScreen();
  String[] cameras;

  for (int i = 0; i < 3; i++) {
    diff[i] = (255.0 / 7.5) * (i + 1.0);
  }

  imageMode(CENTER);

  for (int i = 0; i < 10; i++) {
    imgs[i] = loadImage((i + 1) + ".png");
  }

  eye = loadImage("eye.png");

  do {
    cameras = Capture.list(); 

    if (cameras.length == 0) {
      println("There are no cameras available for capture."); 
      exit();
    } else {
      println("Available cameras:" + cameras.length); 
      println(cameras[4]);

      cam = new Capture(this, cameras[4]); 
      cam.start();
    }
  } while (cameras.length == 0); 

  noFill(); 
  strokeWeight(0.5f);

  Obj = new ArrayList<blob>();
}

void draw() {
  if (modified) {
    push();
    //background(0);
    PImage catA, catB, catC;

    catB = cont.copy();
    catB.resize(int(height * prop), height);

    catC = eyes.copy();
    catC.resize(int(height * prop), height);

    catA = cam.copy();
    catA.resize(int(height * prop), height);

    image(catA, width / 2, height / 2);
    image(catC, width / 2, height / 2);

    if (mod) {
      image(catB, width / 2, height / 2);
    }

    if (showPic) {
      fill(255);
      for (blob b : Obj) {
        push();
        translate(((float(width) - int((float(height) * prop))) / 2) + (b.pos.x * ((float(height) * prop) / float(cam.pixelWidth))), b.pos.y * (float(height) / float(cam.pixelHeight)));
        circle(0, 0, 2f * prop);
        for (int i = 0; i < b.distArms.length; i++) {
          ang = float(i) * (TWO_PI / float(b.distArms.length));
          line(0, 0, int(b.distArms[i] * cos(ang)) * ((float(height) * prop) / float(cam.pixelWidth)), int(b.distArms[i] * sin(ang)) * (float(height) / float(cam.pixelHeight)));
          circle(int(b.distArms[i] * cos(ang)) * ((float(height) * prop) / float(cam.pixelWidth)), int(b.distArms[i] * sin(ang)) * (float(height) / float(cam.pixelHeight)), 0.5f * prop);
        }
        stroke(255, 255, 0);
        line(0, 0, b.averageArms.x * ((float(height) * prop) / float(cam.pixelWidth)), b.averageArms.y * (float(height) / float(cam.pixelHeight)));
        pop();

        //image(b.eyeCopy, b.pos.x, b.pos.y);
      }
    }
    pop();

    fill(255);
    textAlign(CENTER);
    textSize(width / 20);
    text(int(maxRGB), height / 16, height / 13);
    text(int(maxCont), width - (height / 16), height / 13);
  }



  //image(imgs[0], ((float(width) - int((float(height) * prop))) / 2) + (float(mX) * ((float(height) * prop) / float(cam.pixelWidth))), float(mY) * (float(height) / float(cam.pixelHeight)));
}
