#!/bin/bash

# Check if Puppeteer script exists
if [ ! -f "scrap.js" ]; then
  echo "Puppeteer script not found! Please ensure leetcode-scraper.js exists."
  exit 1
fi

# Check if Node.js script exists
if [ ! -f "leetcode.js" ]; then
  echo "LeetCode CLI script not found! Please ensure leetcode-cli.js exists."
  exit 1
fi

# Run the Puppeteer script in the background
nohup node scrap.js &

# Run the LeetCode CLI script
node leetcode.js

# Get the PID of the background process (for Puppeteer)
PID=$!

echo "LeetCode Scraper started in the background with PID: $PID"
echo "You can now continue with your work while the scraper runs."

# Optionally, you can check the logs
echo "To view the log of the scraper, check the nohup.out file."

