class Controller {
  boolean showList = false;
  boolean showSearch = false;
  boolean showNewStudent = false;
  boolean showNewSubject = false;
  boolean showNewClass = false;
  boolean showUpdateSubject = false;
  void handleMousePress(float mouseX, float mouseY) {
    // MAIN PAGE
    if (!showList && !showSearch && !showNewStudent && !showNewSubject && !showNewClass && !showUpdateSubject) {
      if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 20)) {
        showList = true;
      } else if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 100)) {
        showSearch = true;
        searchResults.clear();
      } else if (isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 180)) {
        showNewStudent = true;
      } else if (isButtonPressed(mouseX, mouseY, width / 2 - 200, height / 2 + 180)) {
        showNewSubject = true;
        println ("Test");
      } else if (isButtonPressed(mouseX, mouseY, width / 2 + 200, height / 2 + 180)) {
        showNewClass = true;
        println ("Test");
      } else if (isButtonPressed(mouseX, mouseY, width / 2 - 200, height / 2 + 100)) {
        showUpdateSubject = true;
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
      for (int i = 0; i < allClasses.size(); i++) {
        String className = allClasses.getString(i);
        if (i < 10 && i < allClasses.size()) {
          if (mouseX > width / 2 - 200 - 42 && mouseX < width / 2 - 200 + 84 - 42 && mouseY > 150 - 14 + i * 30 && mouseY < 178 - 14 + i * 30) {
            selectedClass = className;
            println("Valgt klasse: " + className);
          }
        } else if ( i > 9 && i < allClasses.size()) {
          if (mouseX > width / 2 - 200 - 42 - 100 && mouseX < width / 2 - 200 + 84 - 42 - 100 && mouseY > 150 - 14 + (i-10) * 30 && mouseY < 178 - 14 + (i-10) * 30) {
            selectedClass = className;
            println("Valgt klasse: " + className);
          }
        }
      }
      for (int i = 0; i < allSubjects.size(); i++) {
        String subjectName = allSubjects.getString(i);
        if (i < 10 && i < allSubjects.size()) {
          if (mouseX > width / 2 + 200 - 42 && mouseX < width / 2 + 200 + 84 - 42 && mouseY > 150 - 14 + i * 30 && mouseY < 178 - 14 + i * 30) {
            if (!selectedSubjects.contains(subjectName)) {
              selectedSubjects.add(subjectName);
              println("Valgt fag: " + subjectName);
            } else {
              selectedSubjects.remove(subjectName);
              println("Fag fjernet: " + subjectName);
            }
          }
        } else if (i > 9 && i < allSubjects.size()) {
          if (mouseX > width / 2 + 200 - 42 + 100 && mouseX < width / 2 + 200 + 84 - 42 + 100 && mouseY > 150 - 14 + (i-10) * 30 && mouseY < 178 - 14 + (i-10) * 30) {
            if (!selectedSubjects.contains(subjectName)) {
              selectedSubjects.add(subjectName);
              println("Valgt fag: " + subjectName);
            } else {
              selectedSubjects.remove(subjectName);
              println("Fag fjernet: " + subjectName);
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
    if (showNewSubject && isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 50)) {
      addSubject(newSubject);
    }
    if (showNewClass && isButtonPressed(mouseX, mouseY, width / 2, height / 2 + 50)) {
      addClass(newClass);
    }
    if (showUpdateSubject) {
      for (int i = 0; i < allSubjects.size(); i++) {
        String subjectName = allSubjects.getString(i);
        if (i < 10 && i < allSubjects.size()) {
          if (mouseX > width / 2 + 200 - 42 && mouseX < width / 2 + 200 + 84 - 42 && mouseY > 150 - 14 + i * 30 && mouseY < 178 - 14 + i * 30) {
            toggleFagStatus(subjectName);
            println("Fag opdateret");
              
          }
        } else if (i > 9 && i < allSubjects.size()) {
          if (mouseX > width / 2 + 200 - 42 + 100 && mouseX < width / 2 + 200 + 84 - 42 + 100 && mouseY > 150 - 14 + (i-10) * 30 && mouseY < 178 - 14 + (i-10) * 30) {
            toggleFagStatus(subjectName);
            println("Fag opdateret");
          }
        }
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
      } else if (newSubject.length() > 0 && showNewSubject) {
        newSubject = newSubject.substring(0, newSubject.length() - 1);
      } else if (newClass.length() > 0 && showNewClass) {
        newClass = newClass.substring(0, newClass.length() - 1);
      }
    } else if (keyCode != ENTER && keyCode != SHIFT) {
      if (showSearch) {
        searchInput += key;
      } else if (showNewSubject) {
        newSubject += key;
      } else if (showNewClass) {
        newClass += key;
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
    showNewSubject = false;
    showNewClass = false;
    showUpdateSubject = false;
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
  
  boolean isShowingNewSubject() {
    return showNewSubject;
  }
  
  boolean isShowingNewClass() {
    return showNewClass;
  }
  
  boolean isShowingUpdateSubject() {
    return showUpdateSubject;
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
  void addSubject(String name) {
    boolean subjectExists = false;
    for (int i = 0; i < fagStatus.size(); i++) {
      if (allSubjects.getString(i).equals(name)) {
        subjectExists = true;
        break;
      }
    }
    if (!subjectExists) {
      data.getJSONArray("fag").append(name);
      fagStatus.setInt(name, 0);
      println("NYT FAG TILFØJET");
    }
    saveJSONObject(data, "elever.json");
  }
  void addClass(String name) {
    boolean classExists = false;
    for (int i = 0; i < allClasses.size(); i++) {
      if (allClasses.getString(i).equals(name)) {
        classExists = true;
        break;
      }
    }
    if (!classExists) {
      data.getJSONArray("klasser").append(name);
      println("NY KLASSE TILFØJET");
    }
    saveJSONObject(data, "elever.json");
  }
  
}
