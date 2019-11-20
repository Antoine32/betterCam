void captureEvent(Capture ca) {
  boolean modi = !modified; 
  modified = false; 
  ca.loadPixels();
  lastF = ca.copy();
  lastF.loadPixels(); 
  ca.read();
  ca.updatePixels();
  if (!found) {
    lastF = ca.copy();
    cont = createImage(cam.pixelWidth, cam.pixelHeight, ARGB);
    eyes = createImage(cam.pixelWidth, cam.pixelHeight, ARGB);
    found = true;
  }
  ca.loadPixels(); 
  PImage ba = ca.copy(); 
  prop = float(cam.pixelWidth) / float(cam.pixelHeight);
  ba.loadPixels(); 
  cont.loadPixels(); 
  for (int p = 0; p < ca.pixelWidth * ca.pixelHeight; p++) {
    color c = ba.pixels[((ca.pixelWidth - 1) - (p % ca.pixelWidth)) + (int(p / ca.pixelWidth) * ca.pixelWidth)];
    float r = 0, g = 0, b = 0;
    if (!modi) {
      int contC;
      //abc = (abs((lastF.pixels[p] >> 16 & 0xFF) - (c >> 16 & 0xFF)) + abs((lastF.pixels[p] >> 8 & 0xFF) - (c >> 8 & 0xFF)) + abs((lastF.pixels[p] & 0xFF) - (c & 0xFF))) / 3.0;
      if (int(p % ca.pixelWidth) > 0) {
        contC = rep(ba, p - 1);
        r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
        g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
        b += abs((c & 0xFF) - (contC & 0xFF));
        if (int(p / ca.pixelWidth) > 0) {
          contC = rep(ba, p - (ca.pixelWidth + 1));
          r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
          g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
          b += abs((c & 0xFF) - (contC & 0xFF));
        }
        if (int(p / ca.pixelWidth) < ca.pixelHeight - 1) {
          contC = rep(ba, p + (ca.pixelWidth - 1));
          r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
          g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
          b += abs((c & 0xFF) - (contC & 0xFF));
        }
      }
      if (int(p % ca.pixelWidth) < ca.pixelWidth - 1) {
        contC = rep(ba, p + 1);
        r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
        g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
        b += abs((c & 0xFF) - (contC & 0xFF));
        if (int(p / ca.pixelWidth) > 0) {
          contC = rep(ba, p - (ca.pixelWidth - 1));
          r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
          g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
          b += abs((c & 0xFF) - (contC & 0xFF));
        }
        if (int(p / ca.pixelWidth) < ca.pixelHeight - 1) {
          contC = rep(ba, p + (ca.pixelWidth + 1));
          r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
          g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
          b += abs((c & 0xFF) - (contC & 0xFF));
        }
      }
      if (int(p / ca.pixelWidth) > 0) {
        contC = rep(ba, p - ca.pixelWidth);
        r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
        g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
        b += abs((c & 0xFF) - (contC & 0xFF));
      }
      if (int(p / ca.pixelWidth) < ca.pixelHeight - 1) {
        contC = rep(ba, p + ca.pixelWidth);
        r += abs((c >> 16 & 0xFF) - (contC >> 16 & 0xFF));
        g += abs((c >> 8 & 0xFF) - (contC >> 8 & 0xFF));
        b += abs((c & 0xFF) - (contC & 0xFF));
      }

      //r = constrain(r, 0, abs((lastF.pixels[p] >> 16 & 0xFF) - (c >> 16 & 0xFF)) * 2.0);
      //g = constrain(g, 0, abs((lastF.pixels[p] >> 8 & 0xFF) - (c >> 8 & 0xFF)) * 2.0);
      //b = constrain(b, 0, abs((lastF.pixels[p] & 0xFF) - (c & 0xFF)) * 2.0);
    }

    if (max(r, g, b) >= maxCont) {
      cont.pixels[p] = color(max(r, g, b));
    } else {
      cont.pixels[p] = color(0, 0, 0, 0);
    }

    if ((abs((c >> 16 & 0xFF) - (lastF.pixels[p] >> 16 & 0xFF)) + abs((c >> 8 & 0xFF) - (lastF.pixels[p] >> 8 & 0xFF)) + abs((c & 0xFF) - (lastF.pixels[p] & 0xFF))) > maxRGB || doItNow) {
      ca.pixels[p] = c;
    } else {
      ca.pixels[p] = color(0);
    }
    if (doItNow) {
      lastF.pixels[p] = color(lerp((lastF.pixels[p] >> 16 & 0xFF), (c >> 16 & 0xFF), 0.9), lerp((lastF.pixels[p] >> 8 & 0xFF), (c >> 8 & 0xFF), 0.9), lerp((lastF.pixels[p] & 0xFF), (c & 0xFF), 0.9));
    }
  }
  cont.updatePixels(); 
  lastF.updatePixels(); 
  ca.updatePixels();

  cont.loadPixels(); 
  ca.loadPixels(); 

  //PImage copy = ca.copy();
  //copy.loadPixels();

  eyes = createImage(cam.pixelWidth, cam.pixelHeight, ARGB);
  eyes.loadPixels();

  for (blob b : Obj) {
    b.eyeCopy.loadPixels();
    ArrayList<PVector> winner = new ArrayList<PVector>(); 

    for (int p = 0; p < ca.pixelWidth * ca.pixelHeight; p++) {
      color colA[] = new color[9];
      colA[0] = ca.pixels[int(p % ca.pixelWidth) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
      if (int(p % ca.pixelWidth) > 0) {
        colA[1] = ca.pixels[(int(p % ca.pixelWidth) - 1) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
        if (int(p / ca.pixelWidth) > 0) {
          colA[2] = ca.pixels[(int(p % ca.pixelWidth) - 1) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
        }
        if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
          colA[3] = ca.pixels[(int(p % ca.pixelWidth) - 1) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
        }
      }
      if (int(p % ca.pixelWidth) < cam.pixelWidth - 1) {
        colA[4] = ca.pixels[(int(p % ca.pixelWidth) + 1) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
        if (int(p / ca.pixelWidth) > 0) {
          colA[5] = ca.pixels[(int(p % ca.pixelWidth) + 1) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
        }
        if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
          colA[6] = ca.pixels[(int(p % ca.pixelWidth) + 1) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
        }
      }
      if (int(p / ca.pixelWidth) > 0) {
        colA[7] = ca.pixels[int(p % ca.pixelWidth) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
      }
      if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
        colA[8] = ca.pixels[int(p % ca.pixelWidth) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
      }

      color colB[] = new color[9];
      colB[0] = cont.pixels[int(p % ca.pixelWidth) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
      if (int(p % ca.pixelWidth) > 0) {
        colB[1] = cont.pixels[(int(p % ca.pixelWidth) - 1) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
        if (int(p / ca.pixelWidth) > 0) {
          colB[2] = cont.pixels[(int(p % ca.pixelWidth) - 1) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
        }
        if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
          colB[3] = cont.pixels[(int(p % ca.pixelWidth) - 1) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
        }
      }
      if (int(p % ca.pixelWidth) < cam.pixelWidth - 1) {
        colB[4] = cont.pixels[(int(p % ca.pixelWidth) + 1) + (int(p / ca.pixelWidth) * cam.pixelWidth)];
        if (int(p / ca.pixelWidth) > 0) {
          colB[5] = cont.pixels[(int(p % ca.pixelWidth) + 1) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
        }
        if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
          colB[6] = cont.pixels[(int(p % ca.pixelWidth) + 1) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
        }
      }
      if (int(p / ca.pixelWidth) > 0) {
        colB[7] = cont.pixels[int(p % ca.pixelWidth) + ((int(p / ca.pixelWidth) - 1) * cam.pixelWidth)];
      }
      if (int(p / ca.pixelWidth) < cam.pixelHeight - 1) {
        colB[8] = cont.pixels[int(p % ca.pixelWidth) + ((int(p / ca.pixelWidth) + 1) * cam.pixelWidth)];
      }

      boolean ans = false;
      for (int i = 0; i < 9; ++i) {
        if ((abs((colA[i] >> 16 & 0xFF) - (b.colA[i] >> 16 & 0xFF)) < maxRGB && abs((colA[i] >> 8 & 0xFF) - (b.colA[i] >> 8 & 0xFF)) < maxRGB && abs((colA[i] & 0xFF) - (b.colA[i] & 0xFF)) < maxRGB) && (abs((colB[i] >> 16 & 0xFF) - (b.colB[i] >> 16 & 0xFF)) < maxRGB && abs((colB[i] >> 8 & 0xFF) - (b.colB[i] >> 8 & 0xFF)) < maxRGB && abs((colB[i] & 0xFF) - (b.colB[i] & 0xFF)) < maxRGB)) {
          ans = true;
        }
      }

      if (sqrt(sq((p % ca.pixelWidth) - b.pos.x) + sq(int(p / ca.pixelWidth) - b.pos.y)) <= b.maxDist && ans) {
        winner.add(new PVector(p % ca.pixelWidth, int(p / ca.pixelWidth)));
        b.lastSeen = millis();
        //copy.pixels[p] = lerpColor(ca.pixels[p], #FF9E0A, 0.2);
        eyes.pixels[p] = color(b.eyeCopy.pixels[constrain((int((p % ca.width) - b.pos.x) + (b.eyeCopy.width / 2)) + (int(int(p / ca.width) - b.pos.y) + (b.eyeCopy.height / 2)) * b.eyeCopy.width, 0, b.eyeCopy.pixels.length - 1)]);
      }
    }

    PVector moyenne = new PVector(0, 0); 
    for (PVector p : winner) {
      moyenne.add(p);
    }

    if (winner.size() >= 25) {
      moyenne.x /= winner.size(); 
      moyenne.y /= winner.size(); 

      b.vit.lerp(new PVector(moyenne.x - b.pos.x, moyenne.y - b.pos.y), 0.75f);

      b.pos.set(moyenne);
      b.pos.add(b.vit);
      b.lastSeen = millis();

      float maxLerp = b.maxDist;
      int count = 1;
      for (int i = 0; i < b.distArms.length; i++) {
        int toLerp = 1;
        ang = float(i) * (TWO_PI / float(b.distArms.length));
        int x = int(b.pos.x) + int(toLerp * cos(ang)); 
        int y = int(b.pos.y) + int(toLerp * sin(ang));
        boolean goOn = true;
        while ((x <= cont.width - 1 && x >= 10) && (y <= cont.height - 1 && y >= 10) && goOn) {
          if (brightVal(ca.pixels[int(x) + int(y * ca.width)], b.colA[0]) < maxCont) {
            toLerp++;
          } else {
            goOn = false;
          }

          x = int(b.pos.x) + int(toLerp * cos(ang)); 
          y = int(b.pos.y) + int(toLerp * sin(ang));
        }

        b.averageArms.add(x - int(b.pos.x), y - int(b.pos.y));
        b.distArms[i] = int(lerp(b.distArms[i], toLerp, 0.9f));

        if (abs(b.distArms[i] - (maxLerp / count)) <= 20f) {
          maxLerp += b.distArms[i];
          count++;
        } else {
          b.distArms[i] = int(b.maxDist);
        }
      }

      maxLerp /= float(count);
      b.averageArms.div(b.distArms.length + 1);

      if (maxLerp != b.maxDist) {
        b.maxDist = lerp(b.maxDist, maxLerp, 0.9f);
        eye.loadPixels();
        b.eyeCopy = eye.copy();
        b.eyeCopy.loadPixels();
        b.eyeCopy.resize(int(b.maxDist * 2), int(b.maxDist * 2));
        b.eyeCopy.updatePixels();
      }
    }
  }
  //copy.updatePixels();
  eyes.updatePixels();
  //ca.pixels = copy.pixels;
  ca.updatePixels();

  modified = true;
  prop = float(cam.pixelWidth) / float(cam.pixelHeight);
  found = true;
}

color rep(PImage ba, int p) {
  return ba.pixels[((cam.pixelWidth - 1) - (p % cam.pixelWidth)) + (int(p / cam.pixelWidth) * cam.pixelWidth)];
}
