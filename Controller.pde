class Controller {
  boolean showList = false;
  boolean showSearch = false;
  boolean showNewStudent = false;

  void handleMousePress(float mouseX, float mouseY) {
    // MAIN PAGE
    if (!showList && !showSearch && !showNewStudent) {
      if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 20)) {
        showList = true;
      } else if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 100)) {
        showSearch = true;
        searchResults.clear();
      } else if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 180)) {
        showNewStudent = true;
      }
    // UNIVERSAL BACK BUTTON
    } else {
      if (isButtonPressed(mouseX, mouseY, width / 2, height - 50)) {
        newFirstName = "";
        newLastName = "";
        selectedClass = "";
        selectedSubjects.clear();
        resetViews();
      }
    }
    // SEARCH PAGE
    if (showSearch && isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 50)) {
      searchResults.clear();
      searchStudents(searchInput);
    }
    // ADD STUDENT PAGE
    if (showNewStudent) {
      if (mouseX > width / 2 - 60 && mouseX < width / 2 + 120 - 60 && mouseY > height - 100 - 20 && mouseY < height - 100 - 20 + 40) {
        if (!newFirstName.isEmpty() && !newLastName.isEmpty() && !selectedClass.isEmpty()) {
          println("Test");
          addStudent(newFirstName, newLastName, selectedClass);
          isAdding = true;
          newFirstName = "";
          newLastName = "";
          selectedClass = "";
          selectedSubjects.clear();
          saveJSONObject(data, "elever.json"); // Gem ændringerne til JSON
        }
      }
      for (int i = 0; i < classes.size(); i++) {
        String className = allClasses.getString(i);
        if (i < 10 && i < classes.size()) {
          if (mouseX > width / 2 - 200 - 42 && mouseX < width / 2 - 200 + 84 - 42 && mouseY > 150 - 14 + i * 30 && mouseY < 178 - 14 + i * 30) {
            selectedClass = className;
            println("Valgt klasse: " + className);
          }
        } else if ( i > 9 && i < classes.size()) {
          if (mouseX > width / 2 - 200 - 42 - 100 && mouseX < width / 2 - 200 + 84 - 42 - 100 && mouseY > 150 - 14 + (i-10) * 30 && mouseY < 178 - 14 + (i-10) * 30) {
            selectedClass = className;
            println("Valgt klasse: " + className);
          }
        }
      }
      for (int i = 0; i < subjects.size(); i++) {
        if (i < 10 && i < subjects.size()) {
          if (mouseX > width / 2 + 200 - 42 && mouseX < width / 2 + 200 + 84 - 42 && mouseY > 150 - 14 + i * 30 && mouseY < 178 - 14 + i * 30) {
            if (!selectedSubjects.contains(subjects.get(i))) {
              selectedSubjects.add(subjects.get(i));
              println("Valgt fag: " + subjects.get(i));
            } else {
              selectedSubjects.remove(subjects.get(i));
              println("Fag fjernet: " + subjects.get(i));
            }
          }
        } else if (i > 9 && i < subjects.size()) {
          if (mouseX > width / 2 + 200 - 42 + 100 && mouseX < width / 2 + 200 + 84 - 42 + 100 && mouseY > 150 - 14 + (i-10) * 30 && mouseY < 178 - 14 + (i-10) * 30) {
            if (!selectedSubjects.contains(subjects.get(i))) {
              selectedSubjects.add(subjects.get(i));
              println("Valgt fag: " + subjects.get(i));
            } else {
              selectedSubjects.remove(subjects.get(i));
              println("Fag fjernet: " + subjects.get(i));
            }
          }
        }
      }
      if (mouseX > width / 2 + 50 - 100 && mouseX < width / 2 + 50 + 200 - 100 && mouseY > 70 - 15 && mouseY < 100 - 15) {
        println("1");
        focusedInputField = 1; // Fornavn
      } else if (mouseX > width / 2 + 50 - 100 && mouseX < width / 2 + 50 + 200 - 100 && mouseY > 100 - 15 && mouseY < 130 - 15) {
        focusedInputField = 2; // Efternavn
        println("2");
      } else {
        focusedInputField = 0; // Ingen felt fokuseret
        println("3");
      }
      
    }
  }

  void handleKeyPress(int keyCode, char key) {
    if (keyCode == BACKSPACE) {
      if (searchInput.length() > 0 && showSearch) {
        searchInput = searchInput.substring(0, searchInput.length() - 1);
      } else if (showNewStudent) {
        if (focusedInputField == 1 && !newFirstName.isEmpty()) {
          newFirstName = newFirstName.substring(0, newFirstName.length() - 1);
        } else if (focusedInputField == 2 && !newLastName.isEmpty()) {
          newLastName = newLastName.substring(0, newLastName.length() - 1);
        }
      }
    } else if (keyCode != ENTER && keyCode != SHIFT) {
      if (showSearch) {
        searchInput += key;
      } else if (showNewStudent) {
        if (focusedInputField == 1) {
          newFirstName += key;
        } else if (focusedInputField == 2) {
          newLastName += key;
        }
      }
    }
  }

  boolean isButtonPressed(float mouseX, float mouseY, float x, float y) {
    return mouseX > x - 60 && mouseX < x + 60 && mouseY > y - 20 && mouseY < y + 20;
  }

  void resetViews() {
    showList = false;
    showSearch = false;
    showNewStudent = false;
    view.drawWelcomeScreen();
  }

  boolean isShowingList() {
    return showList;
  }

  boolean isShowingSearch() {
    return showSearch;
  }
  
  boolean isShowingNewStudent() {
    return showNewStudent;
  }
  
  void handleToggleFag(String fag) {
    toggleFagStatus(fag);
    view.drawStudentList(elever);
  }
  void addStudent(String firstName, String lastName, String klass) {
    JSONObject newStudent = new JSONObject();
    newStudent.setString("fornavn", firstName);
    newStudent.setString("efternavn", lastName);
    newStudent.setString("klasse", klass);
    newStudent.setJSONArray("fag", new JSONArray());

  // Tilføj valgte fag til hold
    JSONArray subjectsArray = new JSONArray();
    for (String subject : selectedSubjects) {
      subjectsArray.append(subject);
    }
    newStudent.setJSONArray("fag", subjectsArray);
  
    data.getJSONArray("elever").append(newStudent); // Tilføj ny elev til JSON
  }
}
