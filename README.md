@workspace Please refactor `src/pages/darwin/user-settings/tabs/formatting/net-delta-limit-page.ts` to strictly comply with our framework architecture rules defined in `#AGENTS.md`.

You violated the strict repository policy regarding Page Objects. Please apply these exact corrections directly to the physical file:

1. **Empty Constructor Policy:** The constructor must be completely empty (`constructor(public page: Page) {}`). Do NOT initialize locators inside it.
2. **initPage Lifecycle:** Create a public `initPage(): void` method and move the initialization of `#bondMultiLegSwitch` and `#bondMultiLegButterfly` strictly inside this method.
3. **Strict TypeScript Typings:** Since properties are initialized outside the constructor, add the definite assignment assertion operator (`!`) to their declarations (e.g., `public inputSwitchLimit!: Locator;`).

Please update the file directly in the editor and confirm once it strictly matches this pattern.
