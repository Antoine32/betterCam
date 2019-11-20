void keyReleased() {
  if (key == 'm') {
    mod = !mod;
  }

  if (key == 'f') {
    if (found) {
      Obj = new ArrayList<blob>();
    } else {
      found = true;
    }
  }

  if (key == 't') {
    things = !things;
  }

  if (key == 's') {
    showPic = !showPic;
  }

  if (key == 'd') {
    doItNow = !doItNow;
  }

  if (key == 'c') {
    for (blob b : Obj) {
      b.colorMatch();
    }
  }

  if (key == '1') {
    choice = 1;
  }

  if (key == '2') {
    choice = 2;
  }

  if (key == '3') {
    choice = 3;
  }

  if (key == '4') {
    choice = 4;
  }

  if (key == '5') {
    choice = 5;
  }

  if (key == '6') {
    choice = 6;
  }

  if (key == '7') {
    choice = 7;
  }

  if (key == '8') {
    choice = 8;
  }

  if (key == '9') {
    choice = 9;
  }

  if (key == '0') {
    choice = 10;
  }
}
