#/bin/bash

# Ask for user account name
echo "What is the user name to disable?"
read name
usermod -L $name
echo "User $name disabled."
