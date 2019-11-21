String[]kuloer = {"Hjerter", "Spar", "Kløver", "Ruder"};
String[]emblem = {"A", "Konge", "Dronning", "Knægt", "10", "9", "8", "7", "6", "5", "4", "3", "2"};
StringList bunke; //bunke er en stringlist der bliver forklaret senere i setup

int kortnummer; //tidligere traktor, den går op med 1 hver gang et kort trækkes, og bruges til at diktere hvilket kort vi er ved i bunken ud af de 52
int hftidspunkt; //hjerterfritidspunkt sættes til at være framecount og sættes sammen med compDelay for at lave en reaktionstid hos computeren i singleplayer
int compDelay; //reaktionstid hos computeren, se hftidspunkt
int drawDelay; //mængden af tid mellem kort i frames.
int player2Points, player1Points; //pointsystemet, de bruges ikke så meget bagom alt der sker og er kun for det visuelle
boolean kortikkebanket=true; //kort ikke banket, gør så man ikke kan banke adskillige gange på samme kort den bliver checket false når kort bliver banket.

boolean menu=true; //når de her booleans er true, er man i det stadie booleans hedder.
boolean singleplayer=false;
boolean multiplayer=false;
boolean tutorial=false;
boolean endscreen=false;

PImage ag;
PImage card;

void setup() {
  frameRate(30);
  size(800, 600);

  ag = loadImage("ag.jpg");

  bunke = new StringList(); //her bliver bunke defineret og nedenunder er der er for loop der sætter det op

  for (int x=0; x<13; x++) { //det her for loop sætter strings ind i bunke der består af kulør og emblem. Emblem bliver sat op med 13.
    for (int y=0; y<4; y++) { //og så bliver Kulør sat op 4 gange. Så den kører igennem alle hjeterne og tilføjer dem til bunken. Så spar, klør og ruder.
      bunke.append(kuloer[y]+" "+emblem[x]);
    }
  }
  bunke.shuffle(); //til sidst bruger vi shuffle funktionen, der er ligetil hvad vi har brug for. Nu har vi et spil af blandede kort.
} 

void keyPressed() { //den tjekker hver frame for om en tast er trykket controls ligger øverst i compileren fordi de kan ændre på variabler der har effekt på resten af framet.
  if (singleplayer) { //det her er hvad der sker når der bliver spillet singleplayer
    if (key=='d' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //Hvis tasten d bliver trykket og det er et hjerte og kort ikke er banket. indexOf() tjekker om et string indeholder for eksempel "Hjerter"
      player1Points++; //player 1 får tilføjet 1 point
      compDelay=0; //compDelay bliver 0, så CPUen ikke trækker et kort selvom player har.
      kortikkebanket = false; //kort er så banket.
    } else {
      if (key=='d' & kortikkebanket) { //hvis kort bankes af spilleren, det var ikke banket før, og det ikke var et hjerte
        player1Points--; //spiller mister point
        kortikkebanket = false; //kort er så banket
      }
    }
  }

  if (multiplayer) { //det her sker hvis der er multiplayer
    if (key=='d' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //spiller 1 står for at "d" trykkes. Der sker det samme som i singleplayer her, bortset fra at compDelay ikke sættes til 0.
      player1Points++;
      kortikkebanket = false;
    } else {
      if (key=='d' & kortikkebanket) {
        player1Points--;
        kortikkebanket = false;
      }
    }

    if (key=='k' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //spiller 2 står for at "k" trykkes
      player2Points++;
      kortikkebanket = false;
    } else {
      if (key=='k' & kortikkebanket) { 
        player2Points--;
        kortikkebanket = false;
      }
    }
  }
}

void drawCard() { //det her er draw card funktionen der trækker et kort
  kortnummer++; //kortnummer determinerer hvor langt nede i bunken af kort man er. Så hvis kortnummer er 8 er man på det 8. kort i den blandede bunke.
  if (kortnummer>51) {
    endscreen=true;
    singleplayer=false;
    multiplayer=false;
    bunke.shuffle();
    kortnummer = 0;
  }
  if (player1Points-player2Points>7||player2Points-player1Points>7) {
    endscreen=true;
    singleplayer=false;
    multiplayer=false;
    bunke.shuffle();
    kortnummer = 0;
  }
  kortikkebanket = true; //når end der trukket et nyt kort kan man banke på det

  compDelay=0; //compDelay reset

  if (bunke.get(kortnummer).indexOf("Hjerter")==0) { //hvis hjerter bliver trukket
    hftidspunkt = frameCount; //hftidspunkt er frameCount når hjertet bliver trukket
    compDelay = (int)random(10, 30); //og compDelay, som er det CPUens reaktionstid er bliver sat mellem 10 og 30 frames
  }
}

void drawSinglePlayer() { //det her er ligesom en draw funktion, bare at den kun kører når der spilles singleplayer.
  drawDelay++; //drawDelay er hvor mange frames før det næste kort trækkes. Det er normalt 101 frames fordi 
  if (drawDelay==31) { //hvis drawDelay er 31
    drawCard(); //kort trækkes
    drawDelay=0; //og drawDelay reset
  }

  // dette giver pcen delay 
  if ((hftidspunkt + compDelay)==frameCount) { //det her er CPUens reaktionstid, hvis den reagerer sker dette
    player2Points++; //CPUens point 
    compDelay=0;
    kortikkebanket=false;
  }

  clear();
  background(25, 25, 112);
  fill(255);
  rect(10, 10, 50, 50);
  if (mousePressed&&mouseX>10&mouseX<60&mouseY>10&mouseY<60) {
    menu=true;
    singleplayer=false;
  }
  textSize(32);
  textAlign(LEFT);
  image(card, 250, 50, 300, 500);
  text("Du har\n"+player1Points, 90, 100);
  text("CPU har\n"+player2Points, 600, 100);
  fill(0);
  textAlign(CENTER);
  text("<", 35, 45);
}

void drawTutorial() {
  clear();
  background(25, 25, 112);
  fill(10, 10, 100);
  rect(50, 50, 700, 500);
  fill(230);
  textSize(32);
  text("Regler: En bunke kort trækkes\n\nMan banker på hjerter\nFor at banke skal spiller 1\ntrykke D og spiller 2 skal trykke K\n\nHvis du spiller singleplayer trykker du kun D\n\nDen der har banket på flest hjerter\nnår bunken er tom vinder spillet", 400, 100);

  fill(255);
  rect(10, 10, 50, 50);
  if (mousePressed&&mouseX>10&mouseX<60&mouseY>10&mouseY<60) {
    menu=true;
    tutorial=false;
  }

  fill(0);
  textAlign(CENTER);
  text("<", 35, 45);
}

void drawMultiPlayer() { //Multiplayer draw funktionen fungerer ligesom singleplayer bortset fra CPUen
  drawDelay++;
  if (drawDelay==31) {
    drawCard();
    drawDelay=0;
  }

  clear();
  background(0, 100, 0);
  fill(255);
  rect(10, 10, 50, 50);
  if (mousePressed&&mouseX>10&mouseX<60&mouseY>10&mouseY<60) {
    menu=true;
    multiplayer=false;
  }
  image(card, 250, 50, 300, 500);
  textSize(32);
  textAlign(LEFT);
  text("spiller 1 har \n"+player1Points, 50, 100);
  text("spiller 2 har \n"+player2Points, 560, 100);
  fill(0);
  textAlign(CENTER);
  text("<", 35, 45);
}

void drawEndscreen() {
  clear();

  image(ag, 0, 0);
  textAlign(CENTER);
  fill(30, 30, 30, 100);
  rect(100, 150, 600, 100);
  fill(30);
  text("Spillet er færdigt.\nHer er resultaterne.\n\n Spiller 1 har "+player1Points+" point.\nSpiller 2 har "+player2Points+" point.", 400, 90);
  fill(240);
  rect(10, 10, 50, 50);
  fill(30);
  textAlign(CENTER);
  text("<", 35, 45);

  if (mousePressed&&mouseX>10&mouseX<60&mouseY>10&mouseY<60) {
    menu=true;
    endscreen=false;
  }
}

void draw() {
  card = loadImage(bunke.get(kortnummer)+".jpg");
  if (menu) { //menu er det eneste der sker uden en funktion. Der bliver i stedet brugt et if-statement
    player1Points = 0;
    player2Points = 0;
    image(ag, 0, 0);
    textSize(90);
    textAlign(CENTER, CENTER);
    fill(30);
    text("Ghettohjerterfri", 400, 90);
    fill(30, 30, 30, 100);

    rect(100, 150, 600, 100); //Rects der fungerer som knapper
    rect(100, 260, 600, 100);
    rect(100, 370, 600, 100);

    textSize(72);
    fill(230);
    text("Singleplayer", 400, 200);
    text("Multiplayer", 400, 310);
    text("Tutorial", 400, 420);

    if (mousePressed&&mouseX>100&mouseX<700&mouseY>150&mouseY<250) { //når knapperne bliver trykket er hhv. single- og multiplayer sande
      singleplayer=true;
      menu=false;
    }
    if (mousePressed&&mouseX>100&mouseX<700&mouseY>260&mouseY<360) {
      multiplayer=true;
      menu=false;
    }
    if (mousePressed&&mouseX>100&mouseX<700&mouseY>370&mouseY<470) {
      tutorial=true;
      menu=false;
    }
  }

  if (singleplayer) { //singleplayer kalder drawSinglePlayer() mens multiplayer kalder drawMultiPlayer()
    drawSinglePlayer(); //singleplayer og multiplayer er booleans, det ville være et alternativ at lave ints, og have et ID-system.
  }

  if (multiplayer) { //drawsingleplayer og drawmultiplayer er funktioner fordi det var nemmere at lave det i deres egne "draw" funktioner og så ellers holde den rigtige draw() enkel
    drawMultiPlayer();
  }
  if (tutorial) {
    drawTutorial();
  }
  if (endscreen) {
    drawEndscreen();
  }
}
