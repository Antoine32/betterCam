void mouseReleased() {
  int Wid = (int(width) - int((height * prop))) / 2;
  if (found && mouseX >= Wid && mouseX <= width - Wid) {
    float maX = constrain(int(mouseX - Wid), 0, int(height * prop) - 1);
    int mX = int(constrain(maX * (float(cam.pixelWidth) / (float(height) * prop)), 0, cam.pixelWidth - 1));
    int mY = int(constrain(mouseY * (float(cam.pixelHeight) / float(height)), 0, cam.pixelHeight - 1));

    cam.loadPixels();
    Obj.add(new blob(new PVector(mX, mY)));
    println("new blob created");
  }
}

void mouseWheel(MouseEvent event) {
  if (things) {
    maxRGB = constrain(maxRGB - event.getCount(), 0, 255);
  } else {
    maxCont = constrain(maxCont - event.getCount(), 0, 255);
  }
}
