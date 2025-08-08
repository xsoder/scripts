#!/bin/bash

# Define project structure
PROJECT_NAME="javastarter"
SRC_DIR="$PROJECT_NAME/src/main/java/com/example"
TEST_DIR="$PROJECT_NAME/src/test/java/com/example"
BIN_DIR="$PROJECT_NAME/bin"
DOCS_DIR="$PROJECT_NAME/docs"

# Create necessary directories
mkdir -p "$SRC_DIR" "$TEST_DIR" "$BIN_DIR" "$DOCS_DIR"

# Create a sample Java main file
cat <<EOL > "$SRC_DIR/Main.java"
package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Java Starter Project!");
    }
}
EOL

# Create a sample Java helper class
cat <<EOL > "$SRC_DIR/utils/Helper.java"
package com.example.utils;

public class Helper {
    public static String getMessage() {
        return "This is a helper method!";
    }
}
EOL

# Create a sample Java test file
cat <<EOL > "$TEST_DIR/MainTest.java"
package com.example;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class MainTest {
    @Test
    public void testExample() {
        assertEquals(1, 1);
    }
}
EOL

# Create an installation script
cat <<EOL > "$PROJECT_NAME/install.sh"
#!/bin/bash

# Create bin directory if not exists
mkdir -p bin

# Compile Java files
javac -d bin src/main/java/com/example/*.java src/main/java/com/example/utils/*.java

echo "Project compiled successfully!"

# Run the Java program
echo "Running the program..."
java -cp bin com.example.Main
EOL
chmod +x "$PROJECT_NAME/install.sh"

# Create a Makefile
cat <<EOL > "$PROJECT_NAME/Makefile"
CC = javac
JAVA = java
SRC = src/main/java
BIN = bin

all:
\tmkdir -p \$(BIN)
\t\$(CC) -d \$(BIN) \$(SRC)/com/example/*.java \$(SRC)/com/example/utils/*.java

run:
\t\$(JAVA) -cp \$(BIN) com.example.Main

docs:
\tjavadoc -d docs -sourcepath src/main/java -subpackages com.example

clean:
\trm -rf \$(BIN)/* docs/*
EOL

# Create a README file
cat <<EOL > "$PROJECT_NAME/README.md"
# **Java Starter Project**

This is a simple Java starter project. You can clone this repository and start working on Java code immediately.

---

## **Installation**

### **1. Clone the repository**
\`\`\`bash
git clone https://github.com/csode/javastarter.git
\`\`\`

### **2. Navigate into the project directory**
\`\`\`bash
cd javastarter
\`\`\`

### **3. Build and set up the project**
Run the installation script:
\`\`\`bash
./install.sh
\`\`\`

This script will compile your Java files and set up the necessary directory structure.

---

## **Project Structure**

The project follows a structured template for easy organization:
\`\`\`
javastarter/
│── src/
│   ├── main/java/com/example/Main.java
│   ├── main/java/com/example/utils/Helper.java
│   ├── test/java/com/example/MainTest.java
│── bin/                  # Compiled Java bytecode
│── docs/                 # Javadoc documentation
│── install.sh            # Installation script
│── Makefile              # Optional: Automate build & run commands
│── README.md             # Project documentation
\`\`\`

### **Directories Explained**
- \`src/main/java/\` → Main source code
- \`src/test/java/\` → Unit tests
- \`bin/\` → Compiled class files
- \`docs/\` → Generated Javadoc documentation
- \`install.sh\` → Script to compile and run the project
- \`Makefile\` → Automate build/test/docs generation

---

## **Usage**

### **Run the Java program**
\`\`\`bash
java -cp bin com.example.Main
\`\`\`

### **Run Tests (if applicable)**
\`\`\`bash
java -cp bin org.junit.runner.JUnitCore com.example.MainTest
\`\`\`

### **Generate Javadoc**
\`\`\`bash
javadoc -d docs -sourcepath src/main/java -subpackages com.example
\`\`\`
To view the documentation locally, open:
\`\`\`bash
xdg-open docs/index.html  # Linux
open docs/index.html      # macOS
start docs/index.html     # Windows
\`\`\`

---

## **Contributing**
If you’d like to contribute, feel free to fork the repository and submit a pull request.
EOL

echo "Java starter project '$PROJECT_NAME' created successfully!"

