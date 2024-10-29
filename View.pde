class View {
  void drawWelcomeScreen() {
    background(255);
    textSize(24);
    textAlign(CENTER);
    fill(0);
    text("Velkommen!", width / 2, height / 2 - 80);

    drawButton(width / 2, height / 2 + 20, "Vis Elever", 1);
    drawButton(width / 2, height / 2 + 100, "Søg", 1);
    drawButton(width / 2, height / 2 + 180, "Ny Elev", 1);
  }
  void drawNewStudent() {
    
    background(255);
    textAlign(LEFT);
    textSize(16);
    drawNewStudentInputs();
    drawButton(width / 2, height - 50, "Tilbage", 1);
    drawButton(width / 2, height - 100, "Tilføj", 1);
    text("Tilføj ny elev", width / 2, 30);
  
    textSize(14);
    text("Fornavn: ", width / 2 - 100, 70);
    text("Efternavn: ", width / 2 - 100, 100);
  
    // Visning af klasser
    text("Vælg klasse: ", width / 2 - 200, 130);
    for (int i = 0; i < classes.size(); i++) {
      if (i < 10) { // Vis flere klasser
        drawButton(width / 2 - 200, 150 + i * 30, classes.get(i), 0.7);
      }
      if  (i < classes.size() && i > 9) {
        drawButton(width / 2 - 300, 150 + i * 30 - 300, classes.get(i), 0.7);
      }
    }
    textSize(14);
    text("Vælg fag: ", width / 2 + 200, 130);
    for (int i = 0; i < subjects.size(); i++) {
      if (i < 10) { // Vis flere fag
        drawButton(width / 2 + 200, 150 + i * 30, subjects.get(i), 0.7);
      }
      if (i < subjects.size() && i > 9) {
        drawButton(width / 2 + 300, 150 + i * 30 - 300, subjects.get(i), 0.7);
      }
    }
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

    drawButton(width / 2, height - 50, "Tilbage", 1);
  }

  void drawSearchResults(ArrayList<String> searchResults, String searchInput) {
    background(255);
    textAlign(LEFT);
    textSize(16);

    for (int i = 0; i < searchResults.size(); i++) {
      text(searchResults.get(i), 50, 50 + i * 30);
    }

    drawButton(width / 2, height - 50, "Tilbage", 1);
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
  
  void drawNewStudentInputs() {
    fill(255);
    rect(width / 2 + 50, 70, 200, 30);
    fill(0);
    textAlign(LEFT);
    text(newFirstName, width / 2 - 40, 70 + 8);
    fill(255);
    rect(width / 2 + 50, 100, 200, 30);
    fill(0);
    textAlign(LEFT);
    text(newLastName, width / 2 - 40, 100 + 8);
  }

  void drawButton(float x, float y, String label, float sizeMultiplier) {
    rectMode(CENTER);
    fill(100, 200, 100);
    rect(x, y, 120 * sizeMultiplier, 40 * sizeMultiplier);
    fill(0);
    textAlign(CENTER);
    textSize(16 * sizeMultiplier);
    text(label, x, y + 7);
  }
}
