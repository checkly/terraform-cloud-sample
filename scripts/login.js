const { chromium } = require("playwright");

const browser = await chromium.launch();
const context = await browser.newContext();
const page = await context.newPage();

await page.goto("https://danube-webshop.herokuapp.com/");

await page.click("#login");
await page.type("#n-email", process.env.USER_EMAIL);
await page.type("#n-password2", process.env.USER_PASSWORD);
await page.click("#goto-signin-btn");

await page.waitForSelector("#login-message", { visible: true });

await browser.close();