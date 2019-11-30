import peasy.*;
PeasyCam cam;
  
float speed = 0.2;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];
int zoom = dim * 150;

Move[] allMoves = new Move[]{
  new Move(0,1,0,1),
  new Move(0,1,0,-1),
  new Move(0,-1,0,1),
  new Move(0,-1,0,-1),
  new Move(1,0,0,1),
  new Move(1,0,0,-1),
  new Move(-1,0,0,1),
  new Move(-1,0,0,-1),
  new Move(0,0,1,1),
  new Move(0,0,1,-1),
  new Move(0,0,-1,1),
  new Move(0,0,-1,-1),
};

ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;

boolean started = false;

Move currentMove;

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
  
  for(int i = 0; i < 50; i++){
    int r = int(random(allMoves.length));
    Move m = allMoves[r];
    sequence.add(m);
  }
  
  currentMove = sequence.get(counter);
  for(int i = sequence.size()-1; i >= 0; i--){
    Move nextMove = sequence.get(i).copy();
    nextMove.reverse();
    sequence.add(nextMove);
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
  
  fill(255);
  textSize(32);
  text(counter,100,100);
  
  rotateX(-0.5);
  rotateY(0.4);
  rotateZ(0.1);
  
    currentMove.update();
    if(currentMove.finished()){
      if(counter < sequence.size()-1){
        counter++;
        currentMove = sequence.get(counter);
        currentMove.start();
      }
    }
  
  scale(50);
  for(int i = 0; i < cube.length; i++){
    push();  
    if(abs(cube[i].z) > 0 && cube[i].z == currentMove.z){
        rotateZ(currentMove.angle);
    }else if(abs(cube[i].x) > 0 && cube[i].x == currentMove.x){
        rotateX(currentMove.angle);
    }
    else if(abs(cube[i].y) > 0 && cube[i].y == currentMove.y){
        rotateY(-currentMove.angle);
    }
    cube[i].show();
    pop();
  }
}
