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
}
