import { FormattingNumberAndDeltasPage } from './tabs/formatting/numbers-and-deltas-page'
import { RowStylesPage } from './tabs/formatting/row-styles-page'
import { FormattingWarningsPage } from './tabs/formatting/warning-page'
import { NetDeltaLimitPage } from './tabs/rfq-layouts/net-delta-limit-page'
import { AutoSpreadButtonsPage as PopUpAutoSpreadButtonsPage } from './tabs/pop-ups/auto-spread-buttons-page'
import { DefaultOtwPage as PopUpDefaultOtwPage } from './tabs/pop-ups/default-otw-time-page'
import { MutePopUpsPage as PopUpMutePopUpsPage } from './tabs/pop-ups/mute-pop-ups-page'
import { ProductNamePage as PopUpProductNamePage } from './tabs/pop-ups/product-name-page'
import { PopUpRecalculationPage } from './tabs/pop-ups/recalculation-page'
import { BasePage } from '@darwin-pages/base-page'
import { DarwinPageUrls, getDarwinPageByUrlPart } from '@helpers/darwin/darwin-pages'
import { Locator, Page } from '@playwright/test'
import { waitForApiResponse } from 'src/utils/api-actions'

export class DarwinSettingsPage extends BasePage {
    //pop-ups pages
    popUpProductNamePage: PopUpProductNamePage
    popUpAutoSpreadButtonsPage: PopUpAutoSpreadButtonsPage
    popUpDefaultOtwSettingsPage: PopUpDefaultOtwPage
    popUpMutePopUpsPage: PopUpMutePopUpsPage
    popUpRecalculationPage: PopUpRecalculationPage

    //formatting pages
    formattingNumberAndDeltasPage: FormattingNumberAndDeltasPage
    formattingWarningsPage: FormattingWarningsPage
    rowStylesPage: RowStylesPage

    //rfq layouts pages
    netDeltaLimitPage: NetDeltaLimitPage

    buttonPopUpProductName: Locator
    buttonResetSettings: Locator
    buttonPopUpAutoSpreadButtons: Locator
    buttonPopUpDefaultOTWTime: Locator
    buttonPopUpAutoCloseDelay: Locator
    buttonPopUpsSection: Locator
    buttonFormattingSection: Locator
    buttonFormattingNumberAndDeltas: Locator
    buttonFormattingWarnings: Locator
    buttonRowStyles: Locator
    buttonMutePopUpsSection: Locator
    buttonRecalculationSection: Locator
    buttonRfqLayoutsSection: Locator

    constructor(public page: Page) {
        super(page)
    }

    async initPage(title: DarwinPageUrls): Promise<void> {
        this.page = await getDarwinPageByUrlPart(title)
        await super.initBasePage(this.page)
        this.buttonPopUpsSection = this.page.getByTestId('autoSpreadButtonsChildLink').first()
        this.buttonFormattingSection = this.page.getByTestId('formattingChildLink').first()
        this.buttonMutePopUpsSection = this.page.getByTestId('mutePopupsChildLink')
        this.buttonRecalculationSection = this.page.getByTestId(`recalculationChildLink`)
        this.buttonPopUpProductName = this.page.getByTestId('productNamingChildLink')
        this.buttonPopUpAutoSpreadButtons = this.page.getByText('AutoSpread Buttons', { exact: true })
        this.buttonPopUpDefaultOTWTime = this.page.getByTestId('onTheWireTimesChildLink')
        this.buttonPopUpAutoCloseDelay = this.page.getByTestId('autoCloseDelaysChildLink')
        this.buttonFormattingNumberAndDeltas = this.page.getByTestId('formattingChildLink').nth(1)
        this.buttonFormattingWarnings = this.page.getByTestId('contributionWarningsChildLink')
        this.buttonRowStyles = this.page.getByTestId('rowStylesChildLink')
        await this.page.waitForTimeout(1000)
    }

    //common actions across pages

    async saveChanges(): Promise<void> {
        if (await this.buttonSave.isEnabled()) {
            await this.buttonSave.click()
            await Promise.all([
                waitForApiResponse(this.page, 'https://eu-bonds-qa-core.darwin.aws.scib.pre.corp/api/user/settings'),
                this.clickConfirm(),
            ])
        }
    }

    async resetSettings(): Promise<void> {
        await this.clickCancel()
        await this.clickConfirm()
    }

    //open tab

    private async openFormattingSection(): Promise<void> {
        await this.buttonFormattingSection.click()
    }

    private async openPopUpSection(): Promise<void> {
        await this.buttonPopUpsSection.click()
    }

    //open specific section

    async openProductNamePopUpSettings(): Promise<void> {
        await this.openPopUpSection()
        await this.buttonPopUpProductName.click()
        this.popUpProductNamePage = new PopUpProductNamePage(this.page)
    }

    async openMutePopUpsSettings(): Promise<void> {
        await this.openPopUpSection()
        await this.buttonMutePopUpsSection.click()
        this.popUpMutePopUpsPage = new PopUpMutePopUpsPage(this.page)
    }

    async openRecalculationSettings(): Promise<void> {
        await this.openPopUpSection()
        await this.buttonRecalculationSection.click()
        this.popUpRecalculationPage = new PopUpRecalculationPage(this.page)
    }

    async openAutoSpreadButtonsSettings(): Promise<void> {
        await this.openPopUpSection()
        await this.buttonPopUpAutoSpreadButtons.click()
        this.popUpAutoSpreadButtonsPage = new PopUpAutoSpreadButtonsPage(this.page)
    }

    async openDefaultOTWSettings(): Promise<void> {
        await this.openPopUpSection()
        await this.buttonPopUpDefaultOTWTime.click()
        this.popUpDefaultOtwSettingsPage = new PopUpDefaultOtwPage(this.page)
    }

    async openFormattingNumberAndDeltasSettings(): Promise<void> {
        await this.openFormattingSection()
        await this.buttonFormattingNumberAndDeltas.click()
        this.formattingNumberAndDeltasPage = new FormattingNumberAndDeltasPage(this.page)
    }

    async openFormattingWarningsSettings(): Promise<void> {
        await this.openFormattingSection()
        await this.buttonFormattingWarnings.click()
        this.formattingWarningsPage = new FormattingWarningsPage(this.page)
    }

    async openRowStylesSettings(): Promise<void> {
        await this.openFormattingSection()
        await this.buttonRowStyles.click()
        this.rowStylesPage = new RowStylesPage(this.page)
    }

    async openNetDeltaLimitSettings(): Promise<void> {
        this.buttonRfqLayoutsSection = this.page.getByTestId('rfqLayoutsChildLink').first()
        await this.buttonRfqLayoutsSection.click()
        this.netDeltaLimitPage = new NetDeltaLimitPage(this.page)
        this.netDeltaLimitPage.initPage()
    }
}
