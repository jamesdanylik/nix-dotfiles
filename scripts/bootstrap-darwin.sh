#!/bin/zsh

# Useful Links
# https://xyno.space/post/nix-darwin-introduction

echo "Checking Command Line Tools for Xcode"
# Only run if the tools are not installed yet
# To check that try to print the SDK path
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
# This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
  echo "Command Line Tools for Xcode successfully installed."
else
  echo "Command Line Tools for Xcode is already installed."
fi

echo "Checking Nix"
if ! type "nix" > /dev/null; then
  echo "Nix not found.  Installing from nixos.org…"
  sh <(curl -L https://nixos.org/nix/install) </dev/null
  # Enable flakes support
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
  echo "Nix successfully installed.  Close this shell and launch a new one before proceeding."
else
  echo "Nix is already installed."
fi
