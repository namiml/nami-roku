 sub init()
    setupLocals()
    initializeNamiSDKValues()
end sub

sub setupLocals()
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiCustomerManager = m.namiSDK.findNode("NamiCustomerManagerObj")
    m.namiCampaignManager = m.namiSDK.findNode("NamiCampaignManagerObj")
    m.namiPaywallManager = m.namiSDK.findNode("NamiPaywallManagerObj")
end sub

sub initializeNamiSDKValues()
    m.top.isLoggedIn = m.namiCustomerManager.callFunc("isLoggedIn")
    m.top.loggedInId = m.namiCustomerManager.callFunc("loggedInId")
    m.top.deviceId = m.namiCustomerManager.callFunc("deviceId")
    m.top.showLinkedPaywall = false
    m.top.activeEntitlements = []
    m.top.journeyState = m.namiCustomerManager.callFunc("journeyState")
    m.top.campaigns = m.namiCampaignManager.callFunc("allCampaigns")

    m.namiPaywallManager.callFunc("registerBuySkuHandler", m.top)
end sub

function registerBuySkuHandlerCallback(sku as dynamic)
    m.namiPaywallManager.callFunc("dismiss", m.top, "OnPaywallDismissed")

    ' TODO : RSS : Add purchase flow
    print "NamiDataSource : registerBuySkuHandlerCallback : sku : " sku
    m.top.sku = sku
    showPurchaseDialog(sku)
end function

sub showPurchaseDialog(skuDetail)
    m.purchaseDialog = createObject("roSgNode", "StandardMessageDialog")
    m.purchaseDialog.title = "Success"
    m.purchaseDialog.message = [ "You have successfully purchased " + skuDetail.name]
    m.purchaseDialog.buttons = [ "Ok"]

    ' observe the dialog's buttonSelected field to handle button selections
    m.purchaseDialog.observeFieldScoped("buttonSelected", "onButtonSelected")

    m.scene.dialog = m.purchaseDialog
end sub

sub closeDialog()
    if (m.scene.dialog <> invalid) then
        m.scene.dialog.close = true
        m.scene.dialog = invalid
    end if
end sub

sub onButtonSelected()
    if m.purchaseDialog.buttonSelected = 0
        successfulPurchase()
    end if
end sub

sub successfulPurchase()
    isSuccessfulPurchase = true
    if isSuccessfulPurchase
        purchaseSuccess = m.namiSDK.CreateChild("namiSDK:NamiPurchaseSuccess")
        purchaseSuccess.product = m.top.sku
        purchaseSuccess.transactionId = "<TRANSACTION_ID>"
        purchaseSuccess.originalTransactionId = "<ORIGINAL_TRANSACTION_ID>"
        purchaseSuccess.originalPurchaseDate = "<ORIGINAL_PURCHASE_DATE>"
        purchaseSuccess.purchaseDate = "<PURCHASE_DATE>"
        purchaseSuccess.expiresDate = "<EXPIRES_DATE>"
        purchaseSuccess.price = "<PRICE>"
        purchaseSuccess.currencyCode = "<CURRENCY_CODE>"
        purchaseSuccess.locale = "<LOCALE>"
        m.namiPaywallManager.callFunc("buySkuComplete", purchaseSuccess)
    end if
    closeDialog()
end sub

sub onPaywallDismissed()
    m.top.paywallScreenDismissed = true
end sub
