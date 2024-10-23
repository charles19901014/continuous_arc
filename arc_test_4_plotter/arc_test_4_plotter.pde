import processing.pdf.*;

PVector[] points=new PVector[250];
boolean clockwise;
float count;
float firstR;

void setup() {
  size(800, 800);

  points[0]=new PVector(width/2, height/2);
  for (int i=1; i<points.length; i++) {
    float signX=0;
    float signY=0;
    if (random(-1, 1)>0) {
      signX=1;
    } else {
      signX=-1;
    }
    if (random(-1, 1)>0) {
      signY=1;
    } else {
      signY=-1;
    }
    points[i]=new PVector(points[i-1].x+signX*(abs(randomGaussian())*50+20), points[i-1].y+signY*(abs(randomGaussian())*50+20));
    points[i].x=(points[i].x+width)%width;
    points[i].y=(points[i].y+height)%height;
  }

  count=0;
  background(255);
}

void draw() {
  noStroke();
  fill(255, 55);
  rect(0, 0, width, height);

  noFill();
  clockwise=true;

  PVector nowCenter;
  PVector nextCenter;
  PVector preCenter;
  PVector nowPosition;
  PVector nextPosition=new PVector(0, 0);

  float nowR;
  float nextR=0;
  float startAngle;
  float endAngle;
  float nextStartAngle=0;

  for (int i=0; i<count; i++) {
    stroke(0, 80);
    strokeWeight(1);
    ellipse(points[i].x, points[i].y, 5, 5);

    strokeWeight(1);

    nowCenter=points[i].copy();
    nextCenter=points[(i+1)%points.length].copy();
    preCenter=points[(i-1+points.length)%points.length].copy();

    if (i==0) {
      startAngle=0;
      endAngle=atan2(nextCenter.y-nowCenter.y, nextCenter.x-nowCenter.x);
      float distance=dist(nowCenter.x, nowCenter.y, nextCenter.x, nextCenter.y);

      if (count==1) {
        firstR=random(distance);
      }

      nowR=firstR;
      nowPosition=new PVector(cos(0)*nowR+nowCenter.x, sin(0)*nowR+nowCenter.y);

      pushStyle();
      stroke(0, 20);
      strokeWeight(1);
      ellipse(nowPosition.x, nowPosition.y, 55, 55);
      popStyle();

      nextR=distance-nowR;
      nextStartAngle=endAngle;
      nextPosition=new PVector(cos(endAngle)*nowR+nowCenter.x, sin(endAngle)*nowR+nowCenter.y);

      startAngle = regulateAngle(startAngle);
      endAngle = regulateAngle(endAngle);

      if (clockwise) {
        stroke(0, 255, 0);
        if (startAngle<endAngle) {
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, startAngle, endAngle);
        } else {
          endAngle = endAngle+TWO_PI;
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, startAngle, endAngle);
        }
      } else {
        stroke(0, 0, 255);
        if (startAngle<endAngle) {
          startAngle = startAngle+TWO_PI;
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, endAngle, startAngle);
        } else {
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, endAngle, startAngle);
        }
      }
    } else if (i==points.length-1) {
      nowPosition=nextPosition.copy();
      stroke(0, 20);
      strokeWeight(1);
      ellipse(nowPosition.x, nowPosition.y, 55, 55);
    } else {
      endAngle=atan2(nextCenter.y-nowCenter.y, nextCenter.x-nowCenter.x);
      nowPosition=nextPosition.copy();
      if (nextR>0) {
        nowR=nextR;
      } else {
        nowR=dist(nowPosition.x, nowPosition.y, nowCenter.x, nowCenter.y);
      }

      if (nowPosition.x<max(nowCenter.x, preCenter.x) && nowPosition.x>min(nowCenter.x, preCenter.x)) {
        startAngle=nextStartAngle-PI;
        nextPosition=new PVector(cos(endAngle)*nowR+nowCenter.x, sin(endAngle)*nowR+nowCenter.y);
        clockwise = !clockwise;
      } else {
        startAngle=atan2(nowPosition.y-nowCenter.y, nowPosition.x-nowCenter.x);
        nextPosition=new PVector(cos(endAngle)*nowR+nowCenter.x, sin(endAngle)*nowR+nowCenter.y);
      }

      float distance=dist(nowCenter.x, nowCenter.y, nextCenter.x, nextCenter.y);
      nextR=distance-nowR;
      nextStartAngle=endAngle;

      startAngle = regulateAngle(startAngle);
      endAngle = regulateAngle(endAngle);

      if (clockwise) {
        stroke(0, 255, 0);
        if (startAngle<endAngle) {
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, startAngle, endAngle);
        } else {
          endAngle = endAngle+TWO_PI;
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, startAngle, endAngle);
        }
      } else {
        stroke(0, 0, 255);
        if (startAngle<endAngle) {
          startAngle = startAngle+TWO_PI;
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, endAngle, startAngle);
        } else {
          arc(nowCenter.x, nowCenter.y, nowR*2, nowR*2, endAngle, startAngle);
        }
      }
    }
  }

  pushStyle();
  fill(0);
  noStroke();
  text(count, 50, 60);
  popStyle();

  count++;
  if (count<points.length) {
  } else if (count == points.length) {
    beginRecord(PDF, "arc_test_2.pdf");
  } else {
    endRecord();
    exit();
  }
}

float regulateAngle(float angle) {
  if (angle<0) {
    angle+=TWO_PI;
  }
  return angle;
}