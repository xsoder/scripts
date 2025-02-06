const puppeteer = require('puppeteer');

async function scrapeLeetCode() {
    const browser = await puppeteer.launch({ headless: true }); // Runs in background (no UI)
    const page = await browser.newPage();

    // Log in to LeetCode
    await page.goto('https://leetcode.com/accounts/login/');
    await page.type('#id_login', 'your_email');  // Replace with your email
    await page.type('#id_password', 'your_password');  // Replace with your password
    await page.click('.btn-submit');
    await page.waitForNavigation();

    // Visit the problem page
    await page.goto('https://leetcode.com/problems/your-problem-title/');  // Replace with a problem URL

    // Paste your solution in the editor
    await page.type('.CodeMirror textarea', 'your_solution_code_here');  // Replace with your code

    // Submit the solution
    await page.click('.submit__button');
    await page.waitForSelector('.status-message');

    // Get and log the submission result
    const result = await page.$eval('.status-message', (el) => el.innerText);
    console.log('Submission Result:', result);

    // Close the browser
    await browser.close();
}

// Start scraping
scrapeLeetCode();

