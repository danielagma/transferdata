import { BasePage } from './base-page'
import { expectToBeEqual, softExpect } from '@helpers/assertions'
import { DarwinPageUrls, getDarwinPageByUrlPart } from '@helpers/darwin/darwin-pages'
import { Locator, Page, expect } from '@playwright/test'
import { WebSocket } from 'playwright'
import { DarwinGridComponent } from 'src/components/darwin-grid-component'
import { waitForApiResponse } from 'src/utils/api-actions'
import { parseWebSocketMessage, waitForWebSocketMessage } from 'src/utils/websocket'

export enum RfqStatus {
    traded = 'Traded',
    quoteOtw = 'QUOTE OTW',
    quoteSubject = 'QUOTE SUBJECT',
    dealerRejected = 'Dealer Rejected',
    customerRejected = 'Customer Rejected',
    lastLook = 'Last look',
    active = 'Active',
    quoteRequested = 'Quote requested',
}

export class DarwinRfqPage extends BasePage {
    gridComponent: DarwinGridComponent
    rfqLeg1PriceInput!: Locator
    buttonQuote!: Locator
    buttonAcceptLastLook!: Locator
    textRfqStatus!: Locator
    rfqLeg2PriceInput!: Locator
    rfqQuantityBuy!: Locator
    rfqQuantitySell!: Locator
    accordionPricingSection!: Locator
    outrightRfqSreadInput!: Locator
    rfqSpreadInput!: Locator
    rfqLeg1YieldInput!: Locator
    rfqLeg2YieldInput!: Locator
    rfqChargeInput!: Locator
    rfqOutrightPriceInput!: Locator
    buttonCopyRfqId!: Locator
    buttonNcListAcceptAll!: Locator
    buttonNcListSendAll!: Locator
    rfqLeg3PriceInput: Locator
    rfqLeg3YieldInput: Locator
    buttonRejectRfq: Locator
    buttonIgnoreRfq: Locator
    buttonNcListRejectAll: Locator
    stackElement: Locator
    buttonStopAutoQuote: Locator
    rfqLeg1SpreadInput: Locator
    textMidMarketSpread: Locator
    buttonTacListAcceptAll: Locator
    buttonTacListCopyDmo: Locator
    buttonTacListSendAll: Locator
    buttonTacListFill: Locator
    rfqProductName: Locator
    inputOTWTime: Locator
    buttonAcceptLastLookInStackElement: Locator
    textMidPriceValue: Locator
    textRfqSettlementDate: Locator
    textAutoReject: Locator
    textTradeDoneMessage: Locator
    labelAxe: Locator
    labelVenue: Locator
    labelRepoRate: Locator
    labelRepoRateValue: Locator
    textTacListLastQuote: Locator
    textDeltaValue: Locator
    textMultilegNetDeltaValue: Locator
    textPositionValue: Locator
    netDeltaValueContainer: Locator
    netDeltaValueSpan: Locator
    buttonPricingSectionAccordion: Locator
    textAlgoAxeSizeValue: Locator
    textForwardDropValue: Locator
    textPositionValueMultilegLeg1: Locator
    textPositionValueMultilegLeg2: Locator
    textPositionValueMultilegLeg3: Locator
    tooltipTacList: Locator
    spreadButtonsContainer: Locator
    listRfqSpreadButtonsContainer: Locator
    listRfqBatchSpreadButtonsContainer: Locator
    buttonAutoSend: Locator
    textAutoSend: Locator
    textAutoSendStopping: Locator
    textAutoSendingSent: Locator
    textAutoSendingQueued: Locator
    buttonFastSpreadFirst: Locator
    buttonListItemFastSpreadFirst: Locator
    buttonIncreaseCharge: Locator
    buttonDecreaseCharge: Locator
    buttonIncreaseMultilegSpread: Locator
    buttonDecreaseMultilegSpread: Locator
    buttonIncreaseOutrightSpread: Locator
    buttonDecreaseOutrightSpread: Locator
    rfqListGridPriceInput: Locator
    buttonTacListRejectAll: Locator
    widgetFuturePrice: Locator
    widgetHedgeValue: Locator
    widgetMarketData: Locator
    widgetMarketDepth: Locator
    widgetPositionData: Locator

    constructor(public page: Page) {
        super(page)
    }

    getWidgetDataRows(widget: Locator): Locator {
        return widget.getByRole('row').filter({ has: this.page.getByRole('gridcell') })
    }

    async initPage(partOfUrl: DarwinPageUrls | string): Promise<void> {
        this.page = await getDarwinPageByUrlPart(partOfUrl)
        await super.initBasePage(this.page)
        this.gridComponent = new DarwinGridComponent(this.page)
        this.rfqProductName = this.page.getByTestId('rfqProductName')
        this.rfqOutrightPriceInput = this.page.getByTestId('rfqSpinbox_Price_1_Input')
        this.rfqListGridPriceInput = this.page.locator(`[col-id='priceSpinbox'] input`)
        this.rfqLeg1PriceInput = this.page.getByTestId('rfqSpinbox_Price_1_Input')
        this.rfqLeg2PriceInput = this.page.getByTestId('rfqSpinbox_Price_2_Input')
        this.rfqLeg3PriceInput = this.page.getByTestId('rfqSpinbox_Price_3_Input')
        this.rfqLeg1YieldInput = this.page.getByTestId('rfqSpinbox_Yield_1_Input')
        this.rfqLeg2YieldInput = this.page.getByTestId('rfqSpinbox_Yield_2_Input')
        this.rfqLeg3YieldInput = this.page.getByTestId('rfqSpinbox_Yield_3_Input')
        this.rfqLeg1SpreadInput = this.page.getByTestId('rfqSpinbox_MidMarketSpread_1_Input')
        this.rfqChargeInput = this.page.getByTestId('rfqSpinbox_Charge_Input')
        this.outrightRfqSreadInput = this.page.getByTestId('rfqSpinbox_MidMarketSpread_1_Input')
        this.rfqSpreadInput = this.page.getByTestId('rfqSpinbox_Spread_Input')
        this.rfqQuantityBuy = this.page.locator('.quantity.buy')
        this.rfqQuantitySell = this.page.locator('.quantity.sell')
        this.buttonQuote = this.page.getByTestId('rfqQuoteBtn')
        this.buttonAutoSend = this.page.getByTestId('rfqAutoQuoteBtn')
        this.textAutoSend = this.page.getByTestId('autoSending')
        this.textAutoSendStopping = this.page.getByTestId('autoSendingStopping')
        this.textAutoSendingSent = this.page.getByTestId('autoSendingSent')
        this.textAutoSendingQueued = this.page.getByTestId('autoSendingQueued')
        this.accordionPricingSection = this.page.getByText(' Show Pricing Section ')
        this.buttonAcceptLastLook = this.page.getByTestId('rfqAcceptBtn')
        this.textRfqStatus = this.page.getByTestId('rfqStatus')
        this.buttonCopyRfqId = this.page.getByTestId('rfqCopyRfqIdToClipboardButton')
        this.buttonNcListSendAll = this.page.getByTestId('sendAll')
        this.buttonNcListAcceptAll = this.page.getByTestId('acceptAll')
        this.buttonRejectRfq = this.page.getByTestId('rfqRejectBtn')
        this.buttonNcListRejectAll = this.page.getByTestId('rejectAll')
        this.buttonTacListRejectAll = this.page.getByTestId('rfqContingentListRejectBtn')
        this.buttonIgnoreRfq = this.page.getByTestId('rfqIgnoreBtn')
        this.buttonStopAutoQuote = this.page.getByTestId('rfqStopAutoQuoteBtn')
        this.stackElement = this.page.locator(`app-rfq-navigation-tile div[id*='rfqNavigationTile']`)
        this.textMidMarketSpread = this.page.getByTestId('rfqMidMarketSpreadValue')
        this.buttonTacListAcceptAll = this.page.getByTestId('rfqContingentListAcceptBtn')
        this.buttonTacListCopyDmo = this.page.getByTestId('rfqContingentListCopyDmoPricesBtn')
        this.buttonTacListSendAll = this.page.getByTestId('rfqContingentListQuoteBtn')
        this.buttonTacListFill = this.page.getByTestId('rfqContingentListFillBtn')
        this.inputOTWTime = this.page.getByTestId('rfqOnTheWireInput')
        this.buttonAcceptLastLookInStackElement = this.page.locator(
            `//button[starts-with(@id, 'rfqNavigationTileBtn_')]`,
        )
        this.textMidPriceValue = this.page.getByTestId('rfqMidPriceValue')
        this.textRfqSettlementDate = this.page.getByTestId('rfqSettlementDateValue')
        this.textAutoReject = this.page.getByText(
            'Auto-Rejection: RFQ settlement date out of range allowed by Counterparty Settlement Date Rules',
            { exact: false },
        )
        this.textTradeDoneMessage = this.page.getByTestId('tradeDoneMessage')
        this.labelAxe = this.page.getByTestId('rfqProductTradeAxeIndicator')
        this.labelVenue = this.page.getByTestId('rfqVenue')
        this.labelRepoRate = this.page.getByTestId('rfqRepoRateLabel')
        this.labelRepoRateValue = this.page.getByTestId('rfqRepoRateValue')
        this.textTacListLastQuote = this.page.locator(`[col-id='lastQuote']`)
        this.textDeltaValue = this.page.getByTestId('rfqDeltaValue')
        this.textMultilegNetDeltaValue = this.page.getByTestId('rfqNetDeltaValue')
        this.textPositionValue = this.page.getByTestId('rfqPositionValue')
        this.textAlgoAxeSizeValue = this.page.getByTestId('rfqProductAlgoAxeValue')
        this.textForwardDropValue = this.page.getByTestId('rfqFwdMidDropValue')
        this.textPositionValueMultilegLeg1 = this.page.getByTestId('rfqPositionValue_0')
        this.textPositionValueMultilegLeg2 = this.page.getByTestId('rfqPositionValue_1')
        this.textPositionValueMultilegLeg3 = this.page.getByTestId('rfqPositionValue_2')
        this.tooltipTacList = this.page.locator(`[aria-label='Tooltip']`)
        this.buttonFastSpreadFirst = this.page.getByTestId('rfqAutoQuoteWithSpreadBtn_1')
        this.buttonListItemFastSpreadFirst = this.page.getByTestId('rfqAutoQuoteWithSpreadCellRendererBtn_1').first()
        this.buttonIncreaseCharge = this.page.getByTestId('rfqSpinbox_Charge_IncrementBtn')
        this.buttonDecreaseCharge = this.page.getByTestId('rfqSpinbox_Charge_DecrementBtn')
        this.buttonDecreaseMultilegSpread = this.page.getByTestId('rfqSpinbox_Spread_DecrementBtn')
        this.buttonIncreaseMultilegSpread = this.page.getByTestId('rfqSpinbox_Spread_IncrementBtn')
        this.buttonIncreaseOutrightSpread = this.page.getByTestId('rfqSpinbox_MidMarketSpread_1_IncrementBtn')
        this.buttonDecreaseOutrightSpread = this.page.getByTestId('rfqSpinbox_MidMarketSpread_1_DecrementBtn')
        this.spreadButtonsContainer = this.page.locator('.spread-buttons')
        this.listRfqSpreadButtonsContainer = this.page.locator(`[col-id='autoQuoteWithSpreadButtons']`)
        this.listRfqBatchSpreadButtonsContainer = this.page.locator('.auto-quote-with-spread-buttons').nth(1)
        this.widgetFuturePrice = this.page.locator('gridster-item', {
            has: this.page.getByText('Future Price', { exact: true }),
        })
        this.widgetHedgeValue = this.page.locator('gridster-item', {
            has: this.page.getByText('Hedge Value', { exact: true }),
        })
        this.widgetMarketData = this.page.locator('gridster-item', {
            has: this.page.getByText('Market Data', { exact: true }),
        })
        this.widgetMarketDepth = this.page.locator('gridster-item', {
            has: this.page.locator('.market-depth-order-book-grid'),
        })
        this.widgetPositionData = this.page.locator('gridster-item', {
            has: this.page.getByText('Position Data', { exact: true }),
        })
        this.netDeltaValueContainer = this.page.locator('#rfqNetDeltaValue')
        this.netDeltaValueSpan = this.page.locator('#rfqNetDeltaValue span')
        this.buttonPricingSectionAccordion = this.page.getByRole('button', { name: /pricing section/i })
    }

    //General actions

    async getValueFromWebSocketRfqPriceUpdateMessage(ws: WebSocket, value: 'midPrice' | 'spread'): Promise<string> {
        const message = await waitForWebSocketMessage(ws, 'OnRfqPricesEvent')
        const parsedMessage = await parseWebSocketMessage(message[0].payload.toString())
        return value === 'midPrice'
            ? parsedMessage.arguments[0][0].darwinPrice.price.midPrice
            : parsedMessage.arguments[0][0].darwinPrice.price.spread
    }

    async waitForRfqStackToBeEmpty(): Promise<void> {
        await expectToBeEqual(() => this.countStackElements(), 0)
    }

    async changeSpreadBySpinner(
        rfqType: 'outright' | 'multileg',
        direction: 'increase' | 'decrease',
        clickCount: number,
    ): Promise<void> {
        const button =
            rfqType === 'outright'
                ? direction === 'increase'
                    ? this.buttonIncreaseOutrightSpread
                    : this.buttonDecreaseOutrightSpread
                : direction === 'increase'
                  ? this.buttonIncreaseMultilegSpread
                  : this.buttonDecreaseMultilegSpread
        for (let i = 0; i < clickCount; i++) {
            await Promise.all([button.click(), waitForApiResponse(this.page, 'derivable-price-change')])
        }
    }

    async changeChargeBySpinner(direction: 'increase' | 'decrease', clickCount: number): Promise<void> {
        const button = direction === 'increase' ? this.buttonIncreaseCharge : this.buttonDecreaseCharge
        for (let i = 0; i < clickCount; i++) {
            await Promise.all([button.click(), waitForApiResponse(this.page, 'derivable-price-change')])
        }
    }

    async clickOnAutoButton(): Promise<void> {
        await this.buttonAutoSend.click()
    }

    formatForwardDropValue(fwdDrop: string): string {
        const floatValue = parseFloat(fwdDrop)
        return floatValue.toFixed(3)
    }

    formatPositionValue(value: string): string {
        const floatValue = parseFloat(value)
        const integerValue = Math.round(floatValue * 1_000_000)
        return integerValue.toLocaleString('en-US')
    }

    private generateDeltaRegExp(rfqDeltaValue: string): RegExp {
        const number = parseInt(rfqDeltaValue, 10) // Extract the integer part
        return new RegExp(`^(${number - 1}|${number}|${number + 1})(\\.\\d+)?$`)
    }

    async checkIfAutoSpreadButtonsProperlyDisplayed(numberOfButtons: number, list?: boolean): Promise<boolean> {
        await softExpect(this.stackElement).toHaveCount(1)
        let isCheckPassed: boolean = true
        for (let index = 0; index < numberOfButtons; index++) {
            const buttonLocator: Locator = list
                ? this.page.getByTestId(`rfqNonContingentListAutoQuoteWithSpreadBtn_${index}`)
                : this.page.getByTestId(`rfqAutoQuoteWithSpreadBtn_${index}`)
            if (
                (await buttonLocator.isVisible()) === false ||
                (await buttonLocator.textContent()).includes(index.toString()) === false
            ) {
                isCheckPassed = false
                break
            }
        }
        return isCheckPassed
    }

    async getOutrightDelta(): Promise<RegExp> {
        const deltaValue = await this.textDeltaValue.textContent()
        return this.generateDeltaRegExp(deltaValue)
    }

    async getMultilegDelta(leg: 1 | 2 | 3): Promise<RegExp> {
        const index = leg - 1 // Calculate the index based on the leg value
        const deltaValue = await this.textDeltaValue.nth(index).textContent()
        return this.generateDeltaRegExp(deltaValue)
    }

    async getMultilegNetDelta(): Promise<RegExp> {
        const deltaValue = await this.textMultilegNetDeltaValue.textContent()
        return this.generateDeltaRegExp(deltaValue)
    }

    async getListItemDelta(bondDescription: string): Promise<RegExp> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        await bondRow.click()
        await softExpect(this.rfqProductName).toContainText(bondDescription)
        const deltaValue = await this.textDeltaValue.textContent()
        return this.generateDeltaRegExp(deltaValue)
    }

    async getStackElementDescription(rfqId: string): Promise<string> {
        return this.page.getByTestId(`rfqNavigationTile_${rfqId}`).first().textContent()
    }

    async countStackElements(): Promise<number> {
        await this.page.waitForTimeout(3000)
        return await this.stackElement.count()
    }

    calculateAlgoPercentageSpread(midMarketSpread: number, percentage: number): string {
        return (midMarketSpread * (percentage / 100)).toFixed(2)
    }

    calculateAlgoCentsPrice(midMarketPrice: number, cents: number, tradeDirection: 'buy' | 'sell'): string {
        return tradeDirection === 'buy'
            ? (midMarketPrice - cents / 100).toFixed(3)
            : (midMarketPrice + cents / 100).toFixed(3)
    }

    async getTimeToFirstPaint(): Promise<string> {
        let paintTimingJson: string = '[]'
        while (paintTimingJson === '[]') {
            paintTimingJson = await this.page.evaluate(() =>
                JSON.stringify(window.performance.getEntriesByType('paint')),
            )
        }
        return JSON.parse(paintTimingJson)[0].startTime
    }

    async clearPerformanceMetrics(): Promise<void> {
        await this.page.evaluate(() => window.performance.clearMarks('paint'))
        await this.page.evaluate(() => window.performance.clearMeasures('paint'))
        await this.page.evaluate(() => window.performance.clearResourceTimings())
    }

    async acceptLastLook(): Promise<void> {
        await this.waitForRfqStatus(RfqStatus.lastLook)
        await this.buttonAcceptLastLook.click()
        await this.waitForRfqStatus(RfqStatus.traded)
    }

    async acceptLastLookIfVisible(): Promise<void> {
        if (await this.buttonAcceptLastLook.isVisible()) {
            await this.buttonAcceptLastLook.click()
        }
    }

    async closeRfqWindow(): Promise<void> {
        await this.page
            .getByText(RfqStatus.quoteOtw, { exact: false })
            .or(this.page.getByText(RfqStatus.traded, { exact: false }))
            .first()
            .or(this.page.getByText(RfqStatus.dealerRejected, { exact: false }))
            .or(this.page.getByText(RfqStatus.quoteSubject, { exact: false }))
            .waitFor({ state: 'visible' })
        await this.buttonCloseWindow.click()
    }

    async closeHistoricalRfqWindow(): Promise<void> {
        await this.buttonCloseWindow.click()
    }

    async copyRfqId(): Promise<string> {
        await this.buttonCopyRfqId.click({ timeout: 20000 })
        return await this.page.evaluate('navigator.clipboard.readText()')
    }

    private async enterSpinnerValue(spinner: Locator, value: string): Promise<void> {
        await spinner.click()
        await spinner.clear()
        await this.page.keyboard.type(value, { delay: 250 })
        await this.page.keyboard.press('Enter')
    }

    private async setFirstLegPrice(price: string): Promise<void> {
        await this.enterSpinnerValue(this.rfqLeg1PriceInput, price)
    }

    private async setSecondLegPrice(price: string): Promise<void> {
        await this.enterSpinnerValue(this.rfqLeg2PriceInput, price)
    }

    private async setThirdLegPrice(price: string): Promise<void> {
        await this.enterSpinnerValue(this.rfqLeg3PriceInput, price)
    }

    //Outright

    async getOutrightRfqValues(): Promise<outrightRfqValues> {
        const price = await this.rfqOutrightPriceInput.inputValue()
        const yieldValue = await this.rfqLeg1YieldInput.inputValue()
        const spread = await this.outrightRfqSreadInput.inputValue()
        const midPrice = await this.textMidPriceValue.textContent()
        return { price: price, yield: yieldValue, spread: spread, midPriceValue: midPrice }
    }

    async setRfqOverightPrice(price: string): Promise<void> {
        await this.enterSpinnerValue(this.rfqOutrightPriceInput, price)
    }

    async sendOutrightRfqQuote(): Promise<void> {
        await expect(this.buttonQuote).toContainText(await this.rfqOutrightPriceInput.inputValue())
        await this.buttonQuote.click({ timeout: 15000 })
    }

    //Switch

    async calculateBreakEvenSwitchSpreadOnRfqReceived(): Promise<number> {
        const linkerYield = await this.rfqLeg1YieldInput.inputValue()
        const giltYield = await this.rfqLeg2YieldInput.inputValue()
        return (parseFloat(giltYield) - parseFloat(linkerYield)) * 100
    }

    async getSpreadValue(): Promise<string> {
        return (await this.rfqSpreadInput.inputValue()).replace(/,/g, '')
    }

    async compareSwitchValuesBeforeAndAfterOtw(iterations: number, equal?: boolean): Promise<void> {
        let isCheckPassed: boolean = false
        const valuesBefore = await this.getSwitchRfqLegsValues()
        for (let index = 0; index < iterations; index++) {
            await this.sendMultilegRfqQuote()
            await this.waitForRfqStatus(RfqStatus.quoteSubject)
            const valuesAfter = await this.getSwitchRfqLegsValues()
            if (equal) {
                softExpect(valuesBefore.leg1Price).toEqual(valuesAfter.leg1Price)
                softExpect(valuesBefore.leg2Price).toEqual(valuesAfter.leg2Price)
                softExpect(valuesBefore.leg1Yield).toEqual(valuesAfter.leg1Yield)
                softExpect(valuesBefore.leg2Yield).toEqual(valuesAfter.leg2Yield)
                softExpect(valuesBefore.spread).toEqual(valuesAfter.spread)
                softExpect(valuesBefore.charge).toEqual(valuesAfter.charge)
            } else {
                if (
                    valuesBefore.leg1Price !== valuesAfter.leg1Price ||
                    valuesBefore.leg2Price !== valuesAfter.leg2Price ||
                    valuesBefore.leg1Yield !== valuesAfter.leg1Yield ||
                    valuesBefore.leg2Yield !== valuesAfter.leg2Yield ||
                    valuesBefore.spread !== valuesAfter.spread
                ) {
                    isCheckPassed = true
                    break
                }
                softExpect(valuesBefore.charge).toEqual(valuesAfter.charge)
            }
        }
        if (!equal) {
            softExpect(isCheckPassed).toBe(true)
        }
    }

    async sendMultilegRfqQuote(): Promise<void> {
        await expect(this.buttonQuote).toContainText(await this.rfqSpreadInput.inputValue())
        await this.buttonQuote.click()
    }

    async expandPriceInputs(): Promise<void> {
        if (!(await this.rfqLeg2PriceInput.isVisible())) {
            await this.accordionPricingSection.click()
        }
    }

    async setSpreadValue(spread: string): Promise<void> {
        await this.enterSpinnerValue(this.rfqSpreadInput, spread)
    }

    generateIncreasedPrice(currentPrice: string, percentage: number): string {
        const price = parseFloat(currentPrice)
        if (isNaN(price)) throw new Error(`Invalid price: ${currentPrice}`)
        const increasedPrice = price * (1 + percentage / 100)
        return increasedPrice.toFixed(3)
    }

    async setSwitchLegPrice(legOrder: 1 | 2): Promise<void> {
        await this.expandPriceInputs()
        await this.page.waitForTimeout(1500)
        const inputValuesBefore = await this.getSwitchRfqLegsValues()
        switch (legOrder) {
            case 1: {
                const price = this.generateIncreasedPrice(inputValuesBefore.leg1Price, 2)
                await this.setFirstLegPrice(price)
                await this.page.waitForTimeout(1500)

                await Promise.all([
                    softExpect(this.rfqChargeInput).toHaveValue(inputValuesBefore.charge),
                    softExpect(this.rfqLeg1YieldInput).not.toHaveValue(inputValuesBefore.leg1Yield),
                    softExpect(this.rfqLeg2YieldInput).not.toHaveValue(inputValuesBefore.leg2Yield),
                    softExpect(this.rfqLeg2PriceInput).not.toHaveValue(inputValuesBefore.leg2Price),
                ])
                break
            }
            case 2: {
                const price = this.generateIncreasedPrice(inputValuesBefore.leg2Price, 2)
                await this.setSecondLegPrice(price)
                await this.page.waitForTimeout(1500)

                await Promise.all([
                    softExpect(this.rfqLeg2YieldInput).not.toHaveValue(inputValuesBefore.leg2Yield),
                    softExpect(this.rfqSpreadInput).not.toHaveValue(inputValuesBefore.spread),
                    softExpect(this.rfqChargeInput).not.toHaveValue(inputValuesBefore.charge),
                    softExpect(this.rfqLeg1PriceInput).toHaveValue(inputValuesBefore.leg1Price),
                    softExpect(this.rfqLeg1YieldInput).toHaveValue(inputValuesBefore.leg1Yield),
                ])
                break
            }
        }
    }

    async getSwitchRfqLegsValues(): Promise<switchRfqLegsValues> {
        const leg1Price = await this.rfqLeg1PriceInput.inputValue()
        const leg1Yield = await this.rfqLeg1YieldInput.inputValue()
        const leg2Price = await this.rfqLeg2PriceInput.inputValue()
        const leg2Yield = await this.rfqLeg2YieldInput.inputValue()
        const midPriceValue1 = await this.textMidPriceValue.first().textContent()
        const midPriceValue2 = await this.textMidPriceValue.nth(1).textContent()
        const spread = await this.rfqSpreadInput.inputValue()
        const charge = await this.rfqChargeInput.inputValue()
        return {
            leg1Price: leg1Price,
            leg1Yield: leg1Yield,
            leg2Price: leg2Price,
            leg2Yield: leg2Yield,
            midPriceValue1: midPriceValue1,
            midPriceValue2: midPriceValue2,
            spread: spread,
            charge: charge,
        }
    }

    async getSwitchHistoricalRfqLegsValues(): Promise<switchHistoricalRfqLegValues> {
        const leg1Price = await this.rfqLeg1PriceInput.inputValue()
        const leg1Yield = await this.rfqLeg1YieldInput.inputValue()
        const leg2Price = await this.rfqLeg2PriceInput.inputValue()
        const leg2Yield = await this.rfqLeg2YieldInput.inputValue()
        const midPriceValue1 = await this.textMidPriceValue.first().textContent()
        const midPriceValue2 = await this.textMidPriceValue.nth(1).textContent()
        return {
            leg1Price: leg1Price,
            leg1Yield: leg1Yield,
            leg2Price: leg2Price,
            leg2Yield: leg2Yield,
            midPriceValue1: midPriceValue1,
            midPriceValue2: midPriceValue2,
        }
    }

    //list

    getListRowByBondDescription(bondDescription: string, size?: string): Locator {
        return size
            ? this.page.locator(
                  `//div[@role='row'] //div[contains(.,'${size} ${bondDescription}')] //parent::div[@role='row']`,
              )
            : this.page.locator(`//div[@role='row'] //div[contains(.,'${bondDescription}')] //parent::div[@role='row']`)
    }

    async checkIfAutoSpreadButtonPerItemIsVisible(bondDescription: string, numbOfButtons: number): Promise<boolean> {
        await softExpect(this.stackElement).toHaveCount(1)
        let isCheckPassed: boolean = true
        const bondRow = this.getListRowByBondDescription(bondDescription)
        for (let index = 0; index < numbOfButtons; index++) {
            const buttonLocator: Locator = bondRow.getByTestId(`rfqAutoQuoteWithSpreadCellRendererBtn_${index + 1}`)

            if (
                (await buttonLocator.isVisible()) === false ||
                (await buttonLocator.textContent()).includes((index + 1).toString()) === false
            ) {
                isCheckPassed = false
                break
            }
        }
        return isCheckPassed
    }

    async selectListElement(bondDescription: string): Promise<void> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        await bondRow.click()
    }

    async getListItemDmoPrice(bondDescription: string, size?: string): Promise<string> {
        const bondRow = this.getListRowByBondDescription(bondDescription, size)
        return bondRow.locator(this.gridComponent.getColumnById('earlyDmoPrice')).textContent()
    }

    async getListItemRepoRate(bondDescription: string): Promise<string> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        return bondRow.locator(this.gridComponent.getColumnById('repoRate')).textContent()
    }

    async getListItemPosition(bondDescription: string): Promise<string> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        return bondRow.locator(this.gridComponent.getColumnById('position')).textContent()
    }

    async getListItemFwdDrop(bondDescription: string): Promise<string> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        return bondRow.locator(this.gridComponent.getColumnById('forwardMidDrop')).textContent()
    }

    getListItemPriceSpinnerCell(bondDescription: string): Locator {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        return bondRow.locator(this.rfqListGridPriceInput)
    }

    async checkIfEarlyDmoPricesAvailable(descriptions: string[]): Promise<boolean> {
        let isDmoAvailable: boolean = true
        for (const desc of descriptions) {
            const bondRow = this.getListRowByBondDescription(desc)
            if ((await bondRow.locator(this.gridComponent.getColumnById('earlyDmoPrice')).textContent()) === '') {
                isDmoAvailable = false
            }
        }
        return isDmoAvailable
    }

    async hoverOnListItemPriceSpinner(bondDescription: string): Promise<void> {
        const priceSpinner = this.getListItemPriceSpinnerCell(bondDescription)
        await priceSpinner.hover({ force: true })
    }

    async setNcListRfqPrice(bondDescription: string, price: string): Promise<void> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        await bondRow.click()
        // const priceSpinner = bondRow.locator(`[id*='rfqSpinbox_Price']`)
        // await priceSpinner.fill(price, { timeout: 30000 })
        await this.rfqOutrightPriceInput.fill(price)
        await this.page.waitForTimeout(2000)
    }

    async setTacListRfqPrice(bondDescription: string, price: string): Promise<void> {
        const bondRow = this.getListRowByBondDescription(bondDescription)
        await bondRow.click()
        // const priceSpinner = bondRow.locator(`[id*='rfqSpinbox_Price']`)
        // await priceSpinner.fill(price, { timeout: 30000 })
        await bondRow.locator(this.rfqListGridPriceInput).fill(price)
        await this.page.waitForTimeout(2000)
    }

    async sendAllListQuotes(): Promise<void> {
        await this.buttonNcListSendAll.click()
        await this.page.waitForTimeout(1000)
    }

    async acceptAllListQuotes(): Promise<void> {
        await this.waitForRfqStatus(RfqStatus.lastLook)
        await this.buttonNcListAcceptAll.click()
        await this.waitForRfqStatus(RfqStatus.traded)
    }

    async waitForRfqStatus(rfqStatus: RfqStatus): Promise<void> {
        await softExpect(this.textRfqStatus).toContainText(rfqStatus, { ignoreCase: true })
    }

    async getListRfqId(): Promise<string> {
        const copiedId = await this.copyRfqId()
        return copiedId.split('EUGV_')[1].split('_')[0]
    }

    async checkHistoricalTacListLastQuoteText(traderName: string): Promise<void> {
        const lastQuoteValues = await this.textTacListLastQuote.all()
        for (const value of lastQuoteValues) {
            await softExpect(value).toContainText(traderName)
        }
    }

    //bf

    async compareButterflyValuesBeforeAndAfterOtw(iterations: number, equal?: boolean): Promise<void> {
        let isCheckPassed: boolean = false
        for (let index = 0; index < iterations; index++) {
            const valuesBefore = await this.getButterflyRfqLegsValues()
            await this.sendMultilegRfqQuote()
            await this.waitForRfqStatus(RfqStatus.quoteSubject)
            const valuesAfter = await this.getButterflyRfqLegsValues()
            if (equal) {
                softExpect(valuesBefore.leg1Price).toEqual(valuesAfter.leg1Price)
                softExpect(valuesBefore.leg2Price).toEqual(valuesAfter.leg2Price)
                softExpect(valuesBefore.leg3Price).toEqual(valuesAfter.leg3Price)
                softExpect(valuesBefore.leg1Yield).toEqual(valuesAfter.leg1Yield)
                softExpect(valuesBefore.leg2Yield).toEqual(valuesAfter.leg2Yield)
                softExpect(valuesBefore.leg3Yield).toEqual(valuesAfter.leg3Yield)
                softExpect(valuesBefore.spread).toEqual(valuesAfter.spread)
                softExpect(valuesBefore.charge).toEqual(valuesAfter.charge)
            } else {
                if (
                    valuesBefore.leg1Price !== valuesAfter.leg1Price ||
                    valuesBefore.leg2Price !== valuesAfter.leg2Price ||
                    valuesBefore.leg3Price !== valuesAfter.leg3Price ||
                    valuesBefore.leg1Yield !== valuesAfter.leg1Yield ||
                    valuesBefore.leg2Yield !== valuesAfter.leg2Yield ||
                    valuesBefore.leg3Yield !== valuesAfter.leg3Yield ||
                    valuesBefore.spread !== valuesAfter.spread
                ) {
                    isCheckPassed = true
                    break
                }
                softExpect(valuesBefore.charge).toEqual(valuesAfter.charge)
            }
        }
        if (!equal) {
            softExpect(isCheckPassed).toBe(true)
        }
    }

    async setButterflyLegPrice(legOrder: 1 | 2 | 3): Promise<void> {
        await this.expandPriceInputs()
        await this.page.waitForTimeout(1500)
        const inputValuesBefore = await this.getButterflyRfqLegsValues()

        switch (legOrder) {
            case 1: {
                const price = this.generateIncreasedPrice(inputValuesBefore.leg1Price, 2)
                await this.setFirstLegPrice(price)
                await this.page.waitForTimeout(1500)

                await Promise.all([
                    softExpect(this.rfqChargeInput).toHaveValue(inputValuesBefore.charge),
                    softExpect(this.rfqLeg1YieldInput).not.toHaveValue(inputValuesBefore.leg1Yield),
                    softExpect(this.rfqLeg2PriceInput).not.toHaveValue(inputValuesBefore.leg2Price),
                    softExpect(this.rfqLeg2YieldInput).not.toHaveValue(inputValuesBefore.leg2Yield),
                ])
                break
            }
            case 2: {
                const price = this.generateIncreasedPrice(inputValuesBefore.leg2Price, 2)
                await this.setSecondLegPrice(price)
                await this.page.waitForTimeout(1500)

                await Promise.all([
                    softExpect(this.rfqLeg2YieldInput).not.toHaveValue(inputValuesBefore.leg2Yield),
                    softExpect(this.rfqSpreadInput).not.toHaveValue(inputValuesBefore.spread),
                    softExpect(this.rfqChargeInput).not.toHaveValue(inputValuesBefore.charge),
                    softExpect(this.rfqLeg1PriceInput).toHaveValue(inputValuesBefore.leg1Price),
                    softExpect(this.rfqLeg1YieldInput).toHaveValue(inputValuesBefore.leg1Yield),
                    softExpect(this.rfqLeg3PriceInput).toHaveValue(inputValuesBefore.leg3Price),
                    softExpect(this.rfqLeg3YieldInput).toHaveValue(inputValuesBefore.leg3Yield),
                ])
                break
            }
            case 3: {
                const price = this.generateIncreasedPrice(inputValuesBefore.leg3Price, 2)
                await this.setThirdLegPrice(price)
                await this.page.waitForTimeout(1500)

                await Promise.all([
                    softExpect(this.rfqChargeInput).toHaveValue(inputValuesBefore.charge),
                    softExpect(this.rfqLeg3YieldInput).not.toHaveValue(inputValuesBefore.leg3Yield),
                    softExpect(this.rfqLeg2PriceInput).not.toHaveValue(inputValuesBefore.leg2Price),
                    softExpect(this.rfqLeg3YieldInput).not.toHaveValue(inputValuesBefore.leg3Yield),
                ])
                break
            }
        }
    }

    async getButterflyRfqLegsValues(): Promise<butterflyRfqLegsValues> {
        const leg1Price = await this.rfqLeg1PriceInput.inputValue()
        const leg1Yield = await this.rfqLeg1YieldInput.inputValue()
        const leg2Price = await this.rfqLeg2PriceInput.inputValue()
        const leg2Yield = await this.rfqLeg2YieldInput.inputValue()
        const leg3Price = await this.rfqLeg3PriceInput.inputValue()
        const leg3Yield = await this.rfqLeg3YieldInput.inputValue()
        const midPriceValue1 = await this.textMidPriceValue.nth(0).textContent()
        const midPriceValue2 = await this.textMidPriceValue.nth(1).textContent()
        const midPriceValue3 = await this.textMidPriceValue.nth(2).textContent()
        const spread = await this.rfqSpreadInput.inputValue()
        const charge = await this.rfqChargeInput.inputValue()
        return {
            leg1Price: leg1Price,
            leg1Yield: leg1Yield,
            leg2Price: leg2Price,
            leg2Yield: leg2Yield,
            leg3Price: leg3Price,
            leg3Yield: leg3Yield,
            midPriceValue1: midPriceValue1,
            midPriceValue2: midPriceValue2,
            midPriceValue3: midPriceValue3,
            spread: spread,
            charge: charge,
        }
    }

    async getButterflyHistoricalRfqLegsValues(): Promise<butterflyHistoricalRfqLegValues> {
        const leg1Price = await this.rfqLeg1PriceInput.inputValue()
        const leg1Yield = await this.rfqLeg1YieldInput.inputValue()
        const leg2Price = await this.rfqLeg2PriceInput.inputValue()
        const leg2Yield = await this.rfqLeg2YieldInput.inputValue()
        const leg3Price = await this.rfqLeg3PriceInput.inputValue()
        const leg3Yield = await this.rfqLeg3YieldInput.inputValue()
        const midPriceValue1 = await this.textMidPriceValue.nth(0).textContent()
        const midPriceValue2 = await this.textMidPriceValue.nth(1).textContent()
        const midPriceValue3 = await this.textMidPriceValue.nth(2).textContent()
        return {
            leg1Price: leg1Price,
            leg1Yield: leg1Yield,
            leg2Price: leg2Price,
            leg2Yield: leg2Yield,
            leg3Price: leg3Price,
            leg3Yield: leg3Yield,
            midPriceValue1: midPriceValue1,
            midPriceValue2: midPriceValue2,
            midPriceValue3: midPriceValue3,
        }
    }

    // Net Delta & Accordion methods (DWB-2521 / DWB-4180)

    async verifyNetDeltaCalculation(expectedText: string): Promise<void> {
        await softExpect(this.netDeltaValueContainer).toHaveText(expectedText)
    }

    async verifyNetDeltaHighlight(): Promise<void> {
        await softExpect(this.netDeltaValueSpan).toHaveClass(/text-color-error/)
    }

    async verifyNetDeltaNoHighlight(): Promise<void> {
        await softExpect(this.netDeltaValueSpan).not.toHaveClass(/text-color-error/)
    }

    async verifyPricingSectionCollapsed(): Promise<void> {
        await softExpect(this.buttonPricingSectionAccordion).toHaveAttribute('aria-expanded', 'false')
    }

    async verifyPricingSectionExpanded(): Promise<void> {
        await softExpect(this.buttonPricingSectionAccordion).toHaveAttribute('aria-expanded', 'true')
    }

    async expandPricingSection(): Promise<void> {
        await this.buttonPricingSectionAccordion.click()
    }
}
