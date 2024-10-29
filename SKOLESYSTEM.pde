import java.util.*;
import processing.data.*;

JSONObject data;
JSONArray elever;
JSONObject fagStatus;
JSONArray allClasses;
JSONArray allSubjects;
ArrayList<String> classes = new ArrayList<String>();
ArrayList<String> subjects = new ArrayList<String>();
String newFirstName = "";
String newLastName = "";
String selectedClass = "";
ArrayList<String> selectedSubjects = new ArrayList<String>();
boolean isAdding = false;
String searchInput = "";
String newSubject = "";
String newClass = "";
ArrayList<String> searchResults = new ArrayList<String>();
Controller controller;
View view;

int focusedInputField = 0; 

// Define an enum for the status states
enum FagState {
  AKTIV, AFSLUTTET;
  
  // Method to toggle between the two states
  FagState toggle() {
    return this == AKTIV ? AFSLUTTET : AKTIV;
  }
}

void setup() {
  size(800, 500);
  
  // Load the entire JSON object first
  data = loadJSONObject("elever.json");

  // Extract the arrays/objects within it
  elever = data.getJSONArray("elever");
  fagStatus = data.getJSONObject("fagStatus");
  allClasses = data.getJSONArray("klasser");
  allSubjects = data.getJSONArray("fag");
  
  for (int i = 0; i < elever.size(); i++) {
    JSONObject student = elever.getJSONObject(i);
    if (!classes.contains(student.getString("klasse"))) {
      classes.add(student.getString("klasse"));
    }
  }
  
  controller = new Controller();
  view = new View();
  view.drawWelcomeScreen();
  for (Object key : fagStatus.keys()) { // Skift til Object type
    subjects.add((String) key); // Cast til String
  }
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
  } else if (controller.isShowingNewStudent()) {
    view.drawNewStudent();
  } else if (controller.isShowingNewSubject()) {
    view.drawNewSubject();
  } else if (controller.isShowingNewClass()) {
    view.drawNewClass();
  }
}

void mousePressed() {
  controller.handleMousePress(mouseX, mouseY);
}

void keyPressed() {
  controller.handleKeyPress(keyCode, key);
}
