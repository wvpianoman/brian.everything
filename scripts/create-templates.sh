#!/bin/bash
# Tolga Erok
# 10-6-2024
# create common doc's in Template folder in home


# Define the template directory
TEMPLATE_DIR="$HOME/Templates"

# Create the template directory if it doesn't exist
mkdir -p "$TEMPLATE_DIR"

# Create blank text document
touch "$TEMPLATE_DIR/Text_File.txt"

# Create blank Word document
touch "$TEMPLATE_DIR/Docx_File.docx"

# Create blank Excel spreadsheet
touch "$TEMPLATE_DIR/Spreadsheet.xlsx"

# Create blank configuration file
touch "$TEMPLATE_DIR/Config.conf"

# Create blank markdown file
touch "$TEMPLATE_DIR/MD_Document.md"

# Create blank shell script
touch "$TEMPLATE_DIR/Script.sh"

# Create blank Python script
touch "$TEMPLATE_DIR/Python_Script.py"

# Create blank JSON file
touch "$TEMPLATE_DIR/Json_Document.json"

# Create blank YAML file
touch "$TEMPLATE_DIR/Yaml_Document.yaml"

# Create blank HTML file
touch "$TEMPLATE_DIR/HTML_Document.html"

# Create blank CSS file
touch "$TEMPLATE_DIR/CSS_Document.css"

# Create blank JavaScript file
touch "$TEMPLATE_DIR/JS_Document.js"

# Print a message indicating completion
echo "Template documents created in $TEMPLATE_DIR"
