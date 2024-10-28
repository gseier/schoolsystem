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




// View class to handle drawing on the screen


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
