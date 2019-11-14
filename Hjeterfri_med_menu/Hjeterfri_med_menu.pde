String[]kuloer = {"Hjerter", "Spar", "Kløver", "Ruder"};
String[]emblem = {"Es", "Konge", "Dronning", "Knægt", "10", "9", "8", "7", "6", "5", "4", "3", "2"};
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
    if (key=='k' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //Hvis tasten k bliver trykket og det er et hjerte og kort ikke er banket. indexOf() tjekker om et string indeholder for eksempel "Hjerter"
      player1Points++; //player 1 får tilføjet 1 point
      compDelay=0; //compDelay bliver 0, så CPUen ikke trækker et kort selvom player har.
      kortikkebanket = false; //kort er så banket.
    } else {
      if (key=='k' & kortikkebanket) { //hvis kort bankes af spilleren, det var ikke banket før, og det ikke var et hjerte
        player1Points--; //spiller mister point
        kortikkebanket = false; //kort er så banket
      }
    }
  }

  if (multiplayer) { //det her sker hvis der er multiplayer
    if (key=='k' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //spiller 1 står for at "k" trykkes. Der sker det samme som i singleplayer her, bortset fra at compDelay ikke sættes til 0.
      player1Points++;
      kortikkebanket = false;
    } else {
      if (key=='k' & kortikkebanket) {
        player1Points--;
        kortikkebanket = false;
      }
    }

    if (key=='d' & bunke.get(kortnummer).indexOf("Hjerter")==0 & kortikkebanket) { //spiller 2 står for at "d" trykkes
      player2Points++;
      kortikkebanket = false;
    } else {
      if (key=='d' & kortikkebanket) { 
        player2Points--;
        kortikkebanket = false;
      }
    }
  }
}

void drawCard() { //det her er draw card funktionen der trækker et kort
  kortnummer++; //kortnummer determinerer hvor langt nede i bunken af kort man er. Så hvis kortnummer er 8 er man på det 8. kort i den blandede bunke.
  kortikkebanket = true; //når end der trukket et nyt kort kan man banke på det

  println(bunke.get(kortnummer));
  compDelay=0; //compDelay reset

  if (bunke.get(kortnummer).indexOf("Hjerter")==0) { //hvis hjerter bliver trukket
    hftidspunkt = frameCount; //hftidspunkt er frameCount når hjertet bliver trukket
    compDelay = (int)random(20, 100); //og compDelay, som er det CPUens reaktionstid er bliver sat mellem 20 og 100 frames
  }
}

void drawSinglePlayer() { //det her er ligesom en draw funktion, bare at den kun kører når der spilles singleplayer.
  drawDelay++; //drawDelay er hvor mange frames før det næste kort trækkes. Det er normalt 101 frames fordi 
  if (drawDelay==101) { //hvis drawDelay er 101
    drawCard(); //kort trækkes
    drawDelay=0; //og drawDelay reset
  }

  // dette giver pcen delay 
  if ((hftidspunkt + compDelay)==frameCount) { //det her er CPUens reaktionstid, hvis den reagerer sker dette
    println("computer banker i bordet!");
    player2Points++; //CPUens point 
    compDelay=0;
  }

  clear();
  background(25, 25, 112);
  textSize(32);
  image(card, 100, 100, 300, 450);
  text("du har "+player1Points+" cpu har "+player2Points, 100, 50);
}

void drawTutorial() {
  clear();

  rect(50, 500, 400, 50);
  if (mousePressed&&mouseX>50&mouseX<450&mouseY>500&mouseY<550) {
    menu=true;
    tutorial=false;
  }

  textSize(32);
  text("Regler: Hvis du taber kastes du overbord\n\nNår der kommer et hjerte skal spiller 1\ntrykke K og spiller 2 skal trykke D\n\nHvis du spiller singleplayer trykker du kun K\n\nDen der har flest hjerter vinder spillet", 50, 50);
}

void drawMultiPlayer() { //Multiplayer draw funktionen fungerer ligesom singleplayer bortset fra CPUen
  drawDelay++;
  if (drawDelay==101) {
    drawCard();
    drawDelay=0;
  }

  clear();
  background(0, 100, 0);
  image(card, 100, 100, 300, 450);
  textSize(32);
  text("spiller 1 har "+player1Points+"\nspiller 2 har "+player2Points, 500, 100);
}

void draw() {
  card = loadImage(bunke.get(kortnummer)+".jpg");
  if (menu) { //menu er det eneste der sker uden en funktion. Der bliver i stedet brugt et if-statement
    image(ag, 0, 0);
    textSize(32);
    text("Ghettoludo", 500, 90);
    rect(50, 50, 400, 50); //de rects er to knappre
    rect(50, 110, 400, 50);
    rect(50, 170, 400, 50);
    if (mousePressed&&mouseX>50&mouseX<450&mouseY>50&mouseY<100) { //når knapperne bliver trykket er hhv. single- og multiplayer sande
      singleplayer=true;
      menu=false;
    }
    if (mousePressed&&mouseX>50&mouseX<450&mouseY>110&mouseY<160) {
      multiplayer=true;
      menu=false;
    }
    if (mousePressed&&mouseX>50&mouseX<450&mouseY>170&mouseY<220) {
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
}
