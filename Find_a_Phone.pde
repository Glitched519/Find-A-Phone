import g4p_controls.*;
String osChosen = "iOS";
String headphoneJack = "no";
String displayDesign = "bezel";
String screenPanel = "LCD";
int screenSize = 1;
int cameras = 1;
String performance = "powerful";
int batterySize = 1;
String expandableMemory = "no";
String fluidDisplay = "no";
int screenResolution = 1;
int minimumStorage = 256;
String waterResistance = "no";
PrintWriter formInput;
boolean sameLines = false;
String[] specs, form, phoneNames;
String amazonURL, eBayURL, walmartURL;
PImage img;

Phone phone = new Phone(osChosen, headphoneJack, displayDesign, screenPanel, 
  screenSize, cameras, performance, batterySize, expandableMemory, fluidDisplay, 
  screenResolution, minimumStorage, waterResistance);

void setup() {
  background(0);
  size(520, 560);
  loadCSVs();
  createGUI();
  resetChoices();
  resetPrefs();
  checkDuplicateSpecs();
}

void draw() {  
  loadCSVs();
  formInput = createWriter("CSV/preferences.csv");
  for (int i = 0; i < specs.length; i++) {
    try {
      sameLines = form[0].equals(specs[i]);
    }
    catch(ArrayIndexOutOfBoundsException e) {
      formInput.println("1");
    }
    if (sameLines) {
      resultLabel.setText(phoneNames[i]);
      img = loadImage("images/" + phoneNames[i] + ".jpg");
      image(img, 350, 10);
      eBayURL = "https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2380057.m570.l1313.TR12.TRC2.A0.H0.X"
        + phoneNames[i].replace(" ", "+") + ".TRS0&_nkw=" + phoneNames[i].replace(" ", "+") + "&_sacat=0";
      amazonURL = "https://www.amazon.com/s?k=" + phoneNames[i].replace(" ", "+") + "&ref=nb_sb_noss_2";
      walmartURL = "https://www.walmart.com/search/?query=" + phoneNames[i].replace(" ", "%20");
      amazonButton.setEnabled(true);
      eBayButton.setEnabled(true);
      walmartButton.setEnabled(true);
    }
  }
  formInput.println(osChosen + "," + headphoneJack +"," + displayDesign + "," + 
    screenPanel + "," + screenSize + "," + cameras + "," + performance + "," +
    batterySize + "," + expandableMemory + "," + fluidDisplay + "," + screenResolution + "," +
    minimumStorage + "," + waterResistance);
  formInput.close();
}

  
void loadCSVs() {
  specs = loadStrings("CSV/PhoneSpecs.csv");
  form = loadStrings("CSV/preferences.csv"); //use test.txt if not working.;
  phoneNames = loadStrings("CSV/names.csv");
}

void resetPrefs() {
  osChosen = "iOS";
  headphoneJack = "no";
  displayDesign = "bezel";
  screenPanel = "LCD";
  screenSize = 1;
  cameras = 1;
  performance = "powerful";
  batterySize = 1;
  expandableMemory = "no";
  fluidDisplay = "no";
  screenResolution = 1;
  minimumStorage = 256;
  waterResistance = "no";
}

void checkDuplicateSpecs() {
  for (int i = 1; i < specs.length; i++) {
    for (int j = 1; j < specs.length-1; j++) {
      if (specs[i].equals(specs[j])) {
        if (phoneNames[j].equals(phoneNames[i]) || phoneNames[i].equals(phoneNames[j])) {
          //println("same", j);
        } else {
          println(phoneNames[i], "specs match with", phoneNames[j], "specs.");
        }
      }
    }
  }
}

void resetChoices() {
  img = loadImage("images/unknown.jpg");
  image(img, 350, 10);
  iOS.setSelected(true);
  wantJack.setSelected(false);
  bezelChoice.setSelected(true);
  LCDChoice.setSelected(true);
  size1.setSelected(true);
  cameraSlider.setValue(1);
  powerful.setSelected(true);
  huge.setSelected(true);
  wantExpandableMemory.setSelected(false);
  wantFluid.setSelected(false);
  QHD.setSelected(true);
  GB256.setSelected(true);
  tickForWaterResistance.setSelected(false);
  amazonButton.setEnabled(false);
  eBayButton.setEnabled(false);
  walmartButton.setEnabled(false);
}
