String[]kuloer = {"Hjerter", "Spar", "Klør", "Ruder"};

String[]emblem = {"es", "Konge", "dame", "knægt", "10", "9", "8", "7", "6", "5", "4", "3", "2"};

String[] tjek = new String[52];

String[] bob = {kuloer[0], emblem[0]};
int hftidspunkt;
boolean hfTrukket = false;
int compDelay;
boolean bankerkunengang = false; 
int x, y;

void setup() {
  frameRate(30);
  size(500, 500);
}

void mousePressed() {
  x = int(random(kuloer.length));
  y = int(random(emblem.length));

  println("du trak ", kuloer[x], " af ", emblem[y], "");
  
  String[] bob = {kuloer[x], emblem[y]};
  println(bob);
  bankerkunengang= true;
}


void draw() {
// dette tjekker om kortet er blive trukket og giver pcen delay 
  if (kuloer[x].equals("Hjerter") && !hfTrukket){
    hftidspunkt = frameCount;
    hfTrukket=true;
    compDelay = (int)random(20,200);
    println(hftidspunkt,hfTrukket,compDelay);
  }
  
  if((hfTrukket && (hftidspunkt + compDelay)<frameCount) && (bankerkunengang = true)){
    println("computer banker i bordet!");
    hfTrukket = false;
    bankerkunengang= false;
  }
  
  
  
  clear();

  textSize(32);

  text("du trak "+ kuloer[x]+ " af "+ emblem[y], 100, 100);



  text("bare klik for at trække ", 100, 200);
}
