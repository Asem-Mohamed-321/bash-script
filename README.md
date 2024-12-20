# Bash Shell Script Database Management System (DBMS)

A command-line interface (CLI)-based application that allows users to manage data stored on a hard disk. This project provides a simplified yet functional DBMS implemented in Bash scripting.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contact](#contact)

---

## Overview

The Bash Shell Script DBMS is designed to:
- Allow users to store and retrieve data on their hard disk.
- Simulate database functionality through directories and files.
- Provide a user-friendly CLI menu for interaction.

Additionally, the project includes a graphical user interface (GUI) using **Zenity**, making it more accessible and visually appealing.

This project demonstrates how Bash scripting can be used to manage data, offering CRUD (Create, Read, Update, Delete) operations in a database-like environment.

---

## Features

### Main Menu:
1. **Create Database**: Create a new database as a directory.
2. **List Databases**: List all available databases.
3. **Connect To Database**: Select a database to manage tables.
4. **Drop Database**: Delete an existing database directory.

### Database Menu (after connecting to a database):
1. **Create Table**: Create a new table with column definitions and primary key.
2. **List Tables**: Display all tables in the connected database.
3. **Drop Table**: Remove an existing table.
4. **Insert Into Table**: Add rows to a table, ensuring data integrity (e.g., datatype validation, primary key constraints).
5. **Select From Table**: Retrieve and display rows in a formatted manner.
6. **Delete From Table**: Remove specific rows from a table.
7. **Update Table**: Modify existing rows, with checks on column datatypes and primary key constraints.

### Additional GUI Features:
- Use **Zenity** to present menus and options as graphical dialogs.
- GUI-based interactions for all database and table operations.
- Visual feedback for success or error messages, making the DBMS easier to use for non-technical users.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/bash-dbms.git](https://github.com/Asem-Mohamed-321/bash-script.git
   ```
2. Navigate into the project directory:
   ```bash
   cd bash-project
   ```
3. Grant execution permissions to the script:
   ```bash
   chmod +x project.sh gui.sh
   ```
4. Install **Zenity** (if not already installed):
   ```bash
   sudo apt-get install zenity  # For Debian/Ubuntu
   sudo yum install zenity     # For Red Hat/CentOS
   ```
5. Run the script:
   ```bash
   . project.sh
   . gui.sh
   ```

---

## Usage

1. Launch the script by running CLI ->`.project.sh`, GUI ->` `.gui.sh`.
2. Use the Main Menu to create or connect to a database.
3. After connecting to a database, use the Database Menu to perform operations on tables.
4. Follow on-screen prompts or graphical dialogs to provide inputs, such as column definitions, primary keys, and row data.

---

## Project Structure

- **Database Directories**: Each database is represented as a directory.
- **Tables**: Tables are stored as files within their respective database directories.
- **Script File**: The main Bash script (`project.sh`) contains all logic for managing databases and tables.
- **Zenity Integration**: GUI dialogs are handled by Zenity commands within the script.

---


## Contact

For any questions or suggestions, feel free to reach out:

- Author: Moamen magdy
- Email: moamenalghareeb10@gmail.com
- GitHub: [Moamen-alghareeb](https://github.com/Moamen-alghareeb)
- GitHub: [Asem-Mohamed-321](https://github.com/Asem-Mohamed-321)
- 

