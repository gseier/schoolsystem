JSONObject data;
JSONArray elever;
JSONObject fagStatus;
String searchInput = "";
ArrayList<String> searchResults = new ArrayList<String>();
Controller controller;
View view;

// Define an enum for the status states
enum FagState {
  AKTIV, AFSLUTTET;
  
  // Method to toggle between the two states
  FagState toggle() {
    return this == AKTIV ? AFSLUTTET : AKTIV;
  }
}

void setup() {
  size(800, 400);
  
  // Load the entire JSON object first
  data = loadJSONObject("elever.json");

  // Extract the arrays/objects within it
  elever = data.getJSONArray("elever");
  fagStatus = data.getJSONObject("fagStatus");
  
  controller = new Controller();
  view = new View();
  view.drawWelcomeScreen();
}

// Function to toggle status for a specific subject using the enum state system
void toggleFagStatus(String fag) {
  int currentStateIndex = fagStatus.getInt(fag);
  FagState currentState = FagState.values()[currentStateIndex];
  
  // Toggle to the other state
  FagState newState = currentState.toggle();
  fagStatus.put(fag, newState.ordinal());
}


class Controller {
  boolean showList = false;
  boolean showSearch = false;

  void handleMousePress(float mouseX, float mouseY) {
    if (!showList && !showSearch) {
      if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 20)) {
        showList = true;
      } else if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 100)) {
        showSearch = true;
        searchResults.clear();
      }
    } else {
      if (isButtonPressed(mouseX, mouseY, width / 2, height - 50)) {
        resetViews();
      }
    }

    if (showSearch && isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 50)) {
      searchResults.clear();
      searchStudents(searchInput);
    }
  }

  void handleKeyPress(int keyCode, char key) {
    if (keyCode == BACKSPACE) {
      if (searchInput.length() > 0) {
        searchInput = searchInput.substring(0, searchInput.length() - 1);
      }
    } else if (keyCode != ENTER) {
      searchInput += key;
    }
  }

  boolean isButtonPressed(float mouseX, float mouseY, float x, float y) {
    return mouseX > x - 60 && mouseX < x + 60 && mouseY > y - 20 && mouseY < y + 20;
  }

  void resetViews() {
    showList = false;
    showSearch = false;
    view.drawWelcomeScreen();
  }

  boolean isShowingList() {
    return showList;
  }

  boolean isShowingSearch() {
    return showSearch;
  }
  
  void handleToggleFag(String fag) {
    toggleFagStatus(fag);
    view.drawStudentList(elever);
  }
}

// View class to handle drawing on the screen
class View {
  void drawWelcomeScreen() {
    background(255);
    textSize(24);
    textAlign(CENTER);
    fill(0);
    text("Velkommen!", width / 2, height / 2 - 80);

    drawButton(width / 2, height / 2 + 20, "Vis Elever");
    drawButton(width / 2, height / 2 + 100, "Søg");
  }

  void drawStudentList(JSONArray elever) {
    background(255);
    textAlign(LEFT);
    textSize(16);

    for (int i = 0; i < elever.size(); i++) {
      JSONObject elev = elever.getJSONObject(i);
      String navn = elev.getString("fornavn") + " " + elev.getString("efternavn");
      String klasse = elev.getString("klasse");

      StringBuilder fagInfo = new StringBuilder();
      JSONArray fagArray = elev.getJSONArray("fag");
      for (int j = 0; j < fagArray.size(); j++) {
        String fag = fagArray.getString(j);
        
        // Get the current state using the enum
        int stateIndex = fagStatus.getInt(fag);
        FagState state = FagState.values()[stateIndex];
        
        fagInfo.append(fag).append(" (").append(state).append("), ");
      }

      if (fagInfo.length() > 2) {
        fagInfo.setLength(fagInfo.length() - 2);
      }

      text(navn + " - " + klasse + " - " + fagInfo, 50, 50 + i * 30);
    }

    drawButton(width / 2, height - 50, "Tilbage");
  }

  void drawSearchResults(ArrayList<String> searchResults, String searchInput) {
    background(255);
    textAlign(LEFT);
    textSize(16);

    for (int i = 0; i < searchResults.size(); i++) {
      text(searchResults.get(i), 50, 50 + i * 30);
    }

    drawButton(width / 2, height - 50, "Tilbage");
    drawSearchInput(searchInput);
  }

  void drawSearchInput(String searchInput) {
    fill(255);
    rect(width / 2, height / 2, 200, 30);
    fill(0);
    textAlign(LEFT);
    text(searchInput, width / 2 - 90, height / 2 + 8);

    fill(100, 200, 200);
    rect(width / 2, height / 2 + 50, 120, 40);
    fill(0);
    textAlign(CENTER);
    text("Søg", width / 2, height / 2 + 57);
  }

  void drawButton(float x, float y, String label) {
    rectMode(CENTER);
    fill(100, 200, 100);
    rect(x, y, 120, 40);
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text(label, x, y + 7);
  }
}

void searchStudents(String query) {
  for (int i = 0; i < elever.size(); i++) {
    JSONObject elev = elever.getJSONObject(i);
      String navn = elev.getString("fornavn") + " " + elev.getString("efternavn");
      StringBuilder fagInfo = new StringBuilder();
      JSONArray fagArray = elev.getJSONArray("fag");
      for (int j = 0; j < fagArray.size(); j++) {
        String fag = fagArray.getString(j);
        
        // Get the current state using the enum
        int stateIndex = fagStatus.getInt(fag);
        FagState state = FagState.values()[stateIndex];
        
        fagInfo.append(fag).append(" (").append(state).append("), ");
      }

      if (fagInfo.length() > 2) {
        fagInfo.setLength(fagInfo.length() - 2);
      }
    if (navn.toLowerCase().contains(query.toLowerCase())) {
      searchResults.add(navn + " - " + elev.getString("klasse") + " - " + fagInfo);
    }
  }
}

void draw() {
  if (controller.isShowingList()) {
    view.drawStudentList(elever);
  } else if (controller.isShowingSearch()) {
    view.drawSearchResults(searchResults, searchInput);
  }
}

void mousePressed() {
  controller.handleMousePress(mouseX, mouseY);
}

void keyPressed() {
  controller.handleKeyPress(keyCode, key);
}
