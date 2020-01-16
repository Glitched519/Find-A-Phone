import g4p_controls.*;
import controlP5.*;

//The 13 specs
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

//Meta components
PrintWriter formInput;
boolean sameLines = false;
String[] specs, form, phoneNames;
String amazonURL, eBayURL, walmartURL;
PImage img;
String search;
String[] specComponents;
Button walmartButton, eBayButton, amazonButton, resetButton;

//Better menu than G4P's dropdown menu
ControlP5 cp5;
PFont listFont, buttonFont;
DropdownList phoneList;

//Create instance of phone
Phone phone = new Phone(osChosen, headphoneJack, displayDesign, screenPanel, 
  screenSize, cameras, performance, batterySize, expandableMemory, fluidDisplay, 
  screenResolution, minimumStorage, waterResistance);
CustomGUI gui = new CustomGUI();

//Prepares window on start
void setup() {
  background(0);
  size(730, 550);
  loadCSVs(); 
  cp5 = new ControlP5(this);
  createGUI();
  checkDuplicateSpecs(); 
  listFont = createFont("Noto Sans Condensed Bold", 14);
  buttonFont = createFont("Noto Sans Bold", 18);
  img = loadImage("images/unknown.jpg");
  image(img, 560, 10);
  gui.initPhoneList();
  gui.initButtons();
}

//Runs constantly
void draw() {
  if (resetButton.isMousePressed()) {
    gui.reset();
  }
  //Phone list/menu is always open
  if (!phoneList.isOpen()) {
    phoneList.open();
  }

  loadCSVs();
  search = phoneLabel.getText();

  //Writes all choices chosen into this file
  formInput = createWriter("CSV/preferences.csv");

  /*If the input file for some reason is empty, then write anything into it as long as 
   it is only one line long.*/
  for (int i = 0; i < specs.length; i++) {
    try {
      sameLines = form[0].equals(specs[i]);
    }
    catch(ArrayIndexOutOfBoundsException e) {
      formInput.println("1");
    }

    //If the label of the phone list doesn't match with to bottom label, then match both labels
    if (!search.equals(phoneList.getLabel())) { 
      phoneLabel.setText(phoneList.getLabel());
    }

    /*If the choices match any specs in the specs database or search string matches 
     with any phone name.*/
    else if (sameLines || search.equals(phoneNames[i])) {

      //Loads image, three links, and phone search string based on phone name
      phoneList.setLabel(phoneNames[i]);
      phoneLabel.setText(phoneNames[i]);
      img = loadImage("images/" + phoneNames[i] + ".jpg");
      image(img, 560, 10);
      eBayURL = "https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2380057.m570.l1313.TR12.TRC2.A0.H0.X"
        + phoneNames[i].replace(" ", "+") + ".TRS0&_nkw=" + phoneNames[i].replace(" ", "+") + "&_sacat=0";
      amazonURL = "https://www.amazon.com/s?k=" + phoneNames[i].replace(" ", "+") + "&ref=nb_sb_noss_2";
      walmartURL = "https://www.walmart.com/search/?query=" + phoneNames[i].replace(" ", "%20");
      amazonButton.setLock(false);
      eBayButton.setLock(false);
      walmartButton.setLock(false);
      gui.shoppingButtonClicked(amazonButton, amazonURL);
      gui.shoppingButtonClicked(eBayButton, eBayURL);
      gui.shoppingButtonClicked(walmartButton, walmartURL);    

      //Sets the spec values to each of the array components loaded
      specComponents = splitTokens(specs[i], ",");
      osChosen = specComponents[0];
      headphoneJack = specComponents[1];
      displayDesign = specComponents[2];
      screenPanel = specComponents[3];
      String scrs = str(screenSize);
      scrs = specComponents[4];
      String cams = str(cameras);
      cams = specComponents[5];
      performance = specComponents[6];
      String batt = str(batterySize);
      batt = specComponents[7];
      expandableMemory = specComponents[8];
      fluidDisplay = specComponents[9];  
      String scrr = str(screenResolution);
      scrr = specComponents[10];
      String mins = str(minimumStorage);
      mins = specComponents[11];
      waterResistance = specComponents[12];
      phone.matchChoicesWithSpecs();
    }

    //This is what the spec strings look like in form input and phone specs databases:
    formInput.println(osChosen + "," + headphoneJack +"," + displayDesign + "," + 
      screenPanel + "," + screenSize + "," + cameras + "," + performance + "," +
      batterySize + "," + expandableMemory + "," + fluidDisplay + "," + screenResolution + "," +
      minimumStorage + "," + waterResistance);
    formInput.close();
  }
}

//loads the "strings" from the database files
void loadCSVs() {
  specs = loadStrings("CSV/PhoneSpecs.csv");
  form = loadStrings("CSV/preferences.csv");
  phoneNames = loadStrings("CSV/names.csv");
}

/*If any specs are duplicate in PhoneSpecs.csv, it will say which phones have duplicate
 specs in the console. This is necessary because this application is designed to show
 one phone as an output from the application window.*/
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
