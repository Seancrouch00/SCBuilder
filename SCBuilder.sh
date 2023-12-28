#!/bin/bash

# Function to exit in case of an error
exit_on_error() {
    echo "Error: $1"
    exit 1
}

# Function to guess build method
guess_build_method() {
    if [ -f "CMakeLists.txt" ]; then
        echo "1"  # CMake build
    elif [ -f "Makefile" ]; then
        echo "2"  # Makefile build
    elif [ -f "configure" ]; then
        echo "3"  # Configure script
    else
        echo "4"  # Other/Unknown
    fi
}

# Configuration
read -p "Enter the GitHub repository URL: " REPO
read -p "Enter the branch to clone (default: master): " BRANCH
BRANCH=${BRANCH:-master}

# Default build directory
BUILD_DIR="/path/to/build/directory"

# Clone the repository
git clone -b "$BRANCH" "$REPO" "$BUILD_DIR/xmrig" || exit_on_error "Failed to clone repository"

# Change to the build directory
cd "$BUILD_DIR/xmrig" || exit_on_error "Failed to change directory"

# Guess build method
GUESSED_METHOD=$(guess_build_method)
echo "Guessed build method: $GUESSED_METHOD"

# Ask user to confirm or select build method
echo "Select the build method:"
echo "1) CMake build"
echo "2) Makefile build"
echo "3) Configure script"
echo "4) Other"
read -p "Enter your choice (1-4), or press Enter to accept the guessed method [$GUESSED_METHOD]: " BUILD_OPTION
BUILD_OPTION=${BUILD_OPTION:-$GUESSED_METHOD}

# Proceed with the selected build method
case $BUILD_OPTION in
    1)
        # CMake build
        mkdir -p build && cd build
        cmake .. || exit_on_error "cmake failed"
        make || exit_on_error "make failed"
        ;;
    2)
        # Makefile build
        make || exit_on_error "Make failed"
        ;;
    3)
        # Configure script
        ./configure || exit_on_error "Configure failed"
        make || exit_on_error "Make failed"
        ;;
    4)
        # Other/Unknown
        echo "Please follow the project's build instructions."
        ;;
    *)
        echo "Invalid option selected. Exiting."
        exit 1
        ;;
esac

echo "Build completed successfully."
