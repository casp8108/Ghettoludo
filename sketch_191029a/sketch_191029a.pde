String[]kuloer = {"Hjerter", "Spar", "Klør", "Ruder"};

String[]emblem = {"es", "Konge", "dame", "knægt", "10", "9", "8", "7", "6", "5", "4", "3", "2"};

String[] tjek = new String[52];

String[] bob = {kuloer[0], emblem[0]};

int x, y;

void setup() {

  size(500, 500);
}

void mousePressed() {
  x = int(random(kuloer.length));
  y = int(random(emblem.length));

  println("du trak ", kuloer[x], " af ", emblem[y], "");
  
  String[] bob = {kuloer[x], emblem[y]};
  println(bob);
}


void draw() {

  clear();

  textSize(32);

  text("du trak "+ kuloer[x]+ " af "+ emblem[y], 100, 100);



  text("bare klik for at trække ", 100, 200);
}
