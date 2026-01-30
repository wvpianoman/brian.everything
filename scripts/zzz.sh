#!/bin/bash

mkdir -p ~/bin

cat > ~/bin/test << 'EOF'
#!/bin/bash
echo "Hello from Australia brother"
EOF

chmod +x ~/bin/test

if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/bin:$PATH"
fi

echo -e "\e[1;32m✓ Test script created in ~/bin\e[0m"
echo -e "\e[1;36m✓ Run 'test' from terminal or restart terminal\e[0m"
