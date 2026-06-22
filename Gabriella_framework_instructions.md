Hi Gabriella,

To get you familiar with the automation framework, please follow these steps to set up the project locally. Let me know if you run into any issues!

### Step 1: Prerequisites
Before cloning the code, please make sure you have the following installed from the Software Center:
- Node.js 16.19.1
- Visual Studio Code >= 1.76.2
- Git
- Darwin Bonds desktop application
- TradeWeb desktop application

### Step 2: Clone the Repository
1. Open your terminal (Git Bash or VS Code integrated terminal).
2. Run the following command to clone the repo:
   git clone https://github.com/santandergroup-uk/darwin-acceptance-tests-bonds-build-verification.git
3. Navigate into the newly created project folder:
   cd darwin-acceptance-tests-bonds-build-verification

### Step 3: Install Dependencies
While inside the project folder, run the following commands one by one:

1. Install Node packages:
   npm install

2. Install Playwright browsers:
   npx playwright install --with-deps chromium

3. Set up Git hooks (Husky):
   npx husky

*Note: If `npm install` or the Playwright download fails (e.g., timeout or certificate errors), it might be the company VPN/Proxy blocking the traffic. Let me know if that happens.*

### Step 4: Configure the Environment (.env)
The framework needs to know where your apps are installed and requires credentials.
1. In your terminal, run this command to copy the template and create your local config file:
   cp src/env/.env-template src/env/.env
2. I will send you my complete `.env` file via private chat. You can just copy its contents and paste them directly into your new `src/env/.env` file so you don't have to configure the paths (`DARWIN_PATH`, `TW_PATH`) and credentials manually.

### Step 5: Install VS Code Extensions (Recommended)
For a better experience reading and running the code, go to the Extensions tab in VS Code and install these three:
- Playwright Test for VSCode
- ESLint
- Prettier