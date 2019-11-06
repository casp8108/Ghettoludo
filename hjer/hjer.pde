String[]kuloer = {"Hjerter", "Spar", "Klør", "Ruder"};
String[]emblem = {"es", "konge", "dame", "knægt", "10", "9", "8", "7", "6", "5", "4", "3", "2"};
StringList bunke;

int traktor;
int hftidspunkt;
int compDelay;
int drawDelay;
int cpuPoints, playerPoints;
boolean ahegao=true;

void setup() {
  frameRate(30);
  size(500, 500);
  bunke = new StringList();

  for (int x=0; x<13; x++) {
    for (int y=0; y<4; y++) {
      bunke.append(kuloer[y]+" "+emblem[x]);
    }
  }
  bunke.shuffle();
}

void mousePressed() {
  if (bunke.get(traktor).indexOf("Hjerter")==0 & ahegao) {
    println("nice du fik et point");
    playerPoints++;
    compDelay=0;
    ahegao = false;
  } else {
    if (ahegao) {
      println("lmao din idiot det var ikke et hjerte");
      playerPoints--;
      ahegao = false;
    }
  }
}

void drawCard() {
  traktor++;
  ahegao = true;

  println(bunke.get(traktor));
  compDelay=0;

  if (bunke.get(traktor).indexOf("Hjerter")==0) {
    hftidspunkt = frameCount;
    compDelay = (int)random(20, 100);
  }
}

void draw() {
  drawDelay++;
  if (drawDelay==101) {
    drawCard();
    drawDelay=0;
  }

  // dette giver pcen delay 
  if ((hftidspunkt + compDelay)==frameCount) {
    println("computer banker i bordet!");
    cpuPoints++;
    compDelay=0;
  }
  clear();
  textSize(32);
  text("du har "+playerPoints+" cpu har "+cpuPoints, 100, 100);
  text("Kortet er "+bunke.get(traktor), 100, 164);
}
