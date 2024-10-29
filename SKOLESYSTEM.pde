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

interface StudentObserver {
    void onStudentAdded(JSONObject student);
    void onStudentListChanged();
    void onFagStatusChanged(String fag, FagState newState);
}

enum FagState {
  AKTIV, AFSLUTTET;
  
  FagState toggle() {
    return this == AKTIV ? AFSLUTTET : AKTIV;
  }
}

void setup() {
  size(800, 500);
  
  data = loadJSONObject("elever.json");

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
  for (Object key : fagStatus.keys()) {
    subjects.add((String) key);
  }
}

void toggleFagStatus(String fag) {
  int currentStateIndex = fagStatus.getInt(fag);
  FagState currentState = FagState.values()[currentStateIndex];
  
  FagState newState = currentState.toggle();
  fagStatus.put(fag, newState.ordinal());
  println("Skiftet " + fag + " til " + newState);
}


void searchStudents(String query) {
  for (int i = 0; i < elever.size(); i++) {
    JSONObject elev = elever.getJSONObject(i);
      String navn = elev.getString("fornavn") + " " + elev.getString("efternavn");
      StringBuilder fagInfo = new StringBuilder();
      JSONArray fagArray = elev.getJSONArray("fag");
      for (int j = 0; j < fagArray.size(); j++) {
        String fag = fagArray.getString(j);
        
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

void searchStudentsBySubject(String subject) {
  searchResults.clear();

  for (int i = 0; i < elever.size(); i++) {
    JSONObject elev = elever.getJSONObject(i);
    String navn = elev.getString("fornavn") + " " + elev.getString("efternavn");
    String klasse = elev.getString("klasse");

    StringBuilder fagInfo = new StringBuilder();
    JSONArray fagArray = elev.getJSONArray("fag");
    boolean hasSubject = false;

    for (int j = 0; j < fagArray.size(); j++) {
      String fag = fagArray.getString(j);

      if (fag.equalsIgnoreCase(subject)) {
        hasSubject = true;
      }

      int stateIndex = fagStatus.getInt(fag);
      FagState state = FagState.values()[stateIndex];

      fagInfo.append(fag).append(" (").append(state).append("), ");
    }

    if (fagInfo.length() > 2) {
      fagInfo.setLength(fagInfo.length() - 2);
    }

    if (hasSubject) {
      searchResults.add(navn + " - " + klasse + " - " + fagInfo);
    }
  }
}

void searchStudentsByClass(String klasseQuery) {
  searchResults.clear();

  for (int i = 0; i < elever.size(); i++) {
    JSONObject elev = elever.getJSONObject(i);
    String navn = elev.getString("fornavn") + " " + elev.getString("efternavn");
    String klasse = elev.getString("klasse");

    if (klasse.equalsIgnoreCase(klasseQuery)) {

      StringBuilder fagInfo = new StringBuilder();
      JSONArray fagArray = elev.getJSONArray("fag");

      for (int j = 0; j < fagArray.size(); j++) {
        String fag = fagArray.getString(j);

        int stateIndex = fagStatus.getInt(fag);
        FagState state = FagState.values()[stateIndex];

        fagInfo.append(fag).append(" (").append(state).append("), ");
      }

      if (fagInfo.length() > 2) {
        fagInfo.setLength(fagInfo.length() - 2);
      }

      searchResults.add(navn + " - " + klasse + " - " + fagInfo);
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
  } else if (controller.isShowingUpdateSubject()) {
    view.drawUpdateSubject();
  } 
}

void mousePressed() {
  controller.handleMousePress(mouseX, mouseY);
}

void keyPressed() {
  controller.handleKeyPress(keyCode, key);
}
