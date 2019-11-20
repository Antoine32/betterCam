public class blob {
  PVector pos;
  PVector vit = new PVector(0, 0);
  color colA[];
  color colB[];
  int lastSeen;
  float size;
  boolean first;
  float maxDist = 0;
  PImage eyeCopy;

  int distArms[] = new int[16];
  PVector averageArms = new PVector(0, 0);

  blob(PVector pos) {
    this.pos = pos.copy();
    colorMatch();

    for (int i = 0; i < distArms.length; i++) {
      distArms[i] = 0;
      ang = float(i) * (TWO_PI / float(distArms.length));
      int x = int(pos.x) + int(distArms[i] * cos(ang)); 
      int y = int(pos.y) + int(distArms[i] * sin(ang));
      boolean goOn = true;
      while ((x <= cont.width - 1 && x >= 0) && (y <= cont.height - 1 && y >= 0) && goOn) {
        if (brightVal(cont.pixels[int(x) + int(y * cont.width)], colB[0]) < maxRGB && brightVal(cam.pixels[int(x) + int(y * cam.width)], colA[0]) < maxRGB) {
          distArms[i]++;
        } else {
          goOn = false;
        }

        x = int(pos.x) + int(distArms[i] * cos(ang)); 
        y = int(pos.y) + int(distArms[i] * sin(ang));
      }

      averageArms.add(x - int(pos.x), y - int(pos.y));

      if (distArms[i] > maxDist) {
        maxDist = distArms[i];
      }
    }

    averageArms.div(distArms.length);

    eye.loadPixels();
    eyeCopy = eye.copy();
    eyeCopy.loadPixels();
    eyeCopy.resize(int(maxDist * 2), int( maxDist * 2));
    eyeCopy.updatePixels();

    lastSeen = millis();
    size = 1;
    first = true;
  }

  void colorMatch() {
    colA = new color[9];
    colA[0] = cam.pixels[int(pos.x) + (int(pos.y) * cam.pixelWidth)];
    if (pos.x > 0) {
      colA[1] = cam.pixels[(int(pos.x) - 1) + (int(pos.y) * cam.pixelWidth)];
      if (pos.y > 0) {
        colA[2] = cam.pixels[(int(pos.x) - 1) + ((int(pos.y) - 1) * cam.pixelWidth)];
      }
      if (pos.y < cam.pixelHeight - 1) {
        colA[3] = cam.pixels[(int(pos.x) - 1) + ((int(pos.y) + 1) * cam.pixelWidth)];
      }
    }
    if (pos.x < cam.pixelWidth - 1) {
      colA[4] = cam.pixels[(int(pos.x) + 1) + (int(pos.y) * cam.pixelWidth)];
      if (pos.y > 0) {
        colA[5] = cam.pixels[(int(pos.x) + 1) + ((int(pos.y) - 1) * cam.pixelWidth)];
      }
      if (pos.y < cam.pixelHeight - 1) {
        colA[6] = cam.pixels[(int(pos.x) + 1) + ((int(pos.y) + 1) * cam.pixelWidth)];
      }
    }
    if (pos.y > 0) {
      colA[7] = cam.pixels[int(pos.x) + ((int(pos.y) - 1) * cam.pixelWidth)];
    }
    if (pos.y < cam.pixelHeight - 1) {
      colA[8] = cam.pixels[int(pos.x) + ((int(pos.y) + 1) * cam.pixelWidth)];
    }

    colB = new color[9];
    colB[0] = cont.pixels[int(pos.x) + (int(pos.y) * cam.pixelWidth)];
    if (pos.x > 0) {
      colB[1] = cont.pixels[(int(pos.x) - 1) + (int(pos.y) * cam.pixelWidth)];
      if (pos.y > 0) {
        colB[2] = cont.pixels[(int(pos.x) - 1) + ((int(pos.y) - 1) * cam.pixelWidth)];
      }
      if (pos.y < cam.pixelHeight - 1) {
        colB[3] = cont.pixels[(int(pos.x) - 1) + ((int(pos.y) + 1) * cam.pixelWidth)];
      }
    }
    if (pos.x < cam.pixelWidth - 1) {
      colB[4] = cont.pixels[(int(pos.x) + 1) + (int(pos.y) * cam.pixelWidth)];
      if (pos.y > 0) {
        colB[5] = cont.pixels[(int(pos.x) + 1) + ((int(pos.y) - 1) * cam.pixelWidth)];
      }
      if (pos.y < cam.pixelHeight - 1) {
        colB[6] = cont.pixels[(int(pos.x) + 1) + ((int(pos.y) + 1) * cam.pixelWidth)];
      }
    }
    if (pos.y > 0) {
      colB[7] = cont.pixels[int(pos.x) + ((int(pos.y) - 1) * cam.pixelWidth)];
    }
    if (pos.y < cam.pixelHeight - 1) {
      colB[8] = cont.pixels[int(pos.x) + ((int(pos.y) + 1) * cam.pixelWidth)];
    }
  }
}

float brightVal(color ca, color cb) {
  return (abs((ca >> 16 & 0xFF) - (cb >> 16 & 0xFF)) + abs((ca >> 8 & 0xFF) - (cb >> 8 & 0xFF)) + abs((ca & 0xFF) - (cb & 0xFF)));
}
