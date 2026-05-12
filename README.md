@workspace Please refactor `src/pages/darwin/user-settings/user-settings-page.ts` to strictly follow our centralized initialization lifecycle pattern. Apply these exact surgical updates directly to the file:

1. **Strict TypeScript Typings**: Add the definite assignment assertion operator (`!`) to the newly added class properties:
   ```typescript
   netDeltaLimitPage!: NetDeltaLimitPage
   buttonRfqLayoutsSection!: Locator
Centralize Locator Lifecycle: Inside the async initPage(title: DarwinPageUrls) method, insert the initialization of this.buttonRfqLayoutsSection right before await this.page.waitForTimeout(1000) so all main section buttons are initialized together:

TypeScript
this.buttonRfqLayoutsSection = this.page.getByTestId('rfqLayoutsChildLink').first()
Clean Action Method: Simplify openNetDeltaLimitSettings() to remove the inline locator declaration, keeping it concise like the other tab methods:

TypeScript
async openNetDeltaLimitSettings(): Promise<void> {
    await this.buttonRfqLayoutsSection.click()
    this.netDeltaLimitPage = new NetDeltaLimitPage(this.page)
    this.netDeltaLimitPage.initPage()
}
Please update the physical file directly in the editor so I can review the clean Git diff.
