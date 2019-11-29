import peasy.*;

PeasyCam cam;
  
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];
int zoom = dim * 150;

String[] allMoves = {"f","b","u","d","l","r"};
String sequence = "";
int counter = 0;

boolean started = false;
void setup(){
  size(600, 600, P3D);
  cam = new PeasyCam(this, zoom);
  int index = 0;
  for(int x = -1; x <= 1 ; x++){
    for(int y = -1; y <= 1; y++){
      for(int z = -1; z <= 1; z++){
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(x,y,z);
        cube[index] = new Cubie(matrix,x, y, z);
        index++;
      }
    }
  }
  //cube[0].c = color(255,0,0);
  //cube[2].c = color(0,0,255);
  
  for(int i = 0; i < 10; i++){
    int r = int(random(allMoves.length));
    if(random(1) < 0.5){
      sequence += allMoves[r];
    }
    else{
      sequence += allMoves[r].toUpperCase();
    }
  }
  for(int i = sequence.length()-1; i >= 0; i--){
    String nextMove = flipCase(sequence.charAt(i));
    sequence += nextMove;
  }
//  print(sequence);
}

String flipCase(char c){
  String s = "" + c;
  if(s.equals(s.toLowerCase())){
    return s.toUpperCase();
  } else{
    return s.toLowerCase();
  }
}

void turnZ(int index, int dir){
  for(int i = 0; i < cube.length; i++){
     if(cube[i].z == index){     
       PMatrix2D matrix2 = new PMatrix2D();
       matrix2.rotate(dir*HALF_PI);
       matrix2.translate(cube[i].x, cube[i].y);
       cube[i].update(round(matrix2.m02), round(matrix2.m12), round(cube[i].z));
       cube[i].turnFacesZ(dir);
     }
  }
}

void turnY(int index, int dir){
  for(int i = 0; i < cube.length; i++){
     if(cube[i].y == index){     
       PMatrix2D matrix2 = new PMatrix2D();
       matrix2.rotate(dir*HALF_PI);
       matrix2.translate(cube[i].x, cube[i].z);
       cube[i].update(round(matrix2.m02), cube[i].y, round(matrix2.m12));
       cube[i].turnFacesY(dir);
     }
  }
}

void turnX(int index, int dir){
  for(int i = 0; i < cube.length; i++){
     if(cube[i].x == index){     
       PMatrix2D matrix2 = new PMatrix2D();
       matrix2.rotate(dir*HALF_PI);
       matrix2.translate(cube[i].y, cube[i].z);
       cube[i].update(cube[i].x, round(matrix2.m02), round(matrix2.m12));
       cube[i].turnFacesX(dir);
     }
  }
}

void draw(){
  background(51);
  if(started){
    if(frameCount % 1 == 0){
      if(counter < sequence.length()){
        char move = sequence.charAt(counter);
        applyMoves(move);
        counter++;
      }
    }
  }
  scale(50);
  for(int i = 0; i < cube.length; i++){
      cube[i].show();
  }
}
