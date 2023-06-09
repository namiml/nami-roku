sub init()
    setupLocals()
    initializeNamiSDKValues()
end sub

sub setupLocals()
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.namiSDK
    m.namiManager = m.namiSDK.nami
    m.namiCustomerManager = m.namiManager.callFunc("getCustomerManager")
    m.namiCampaignManager = m.namiManager.callFunc("getCampaignManager")
    m.namiPaywallManager = m.namiManager.callFunc("getPaywallManager")
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
    m.namiCustomerManager.callFunc("registerAccountStateHandler", m.top)
    m.namiCustomerManager.callFunc("setCustomerDataPlatformId", "aaaa")
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

        purchaseSuccess.purchaseId = "<PURCHASE_ID>"
        purchaseSuccess.qty = "<QTY>"
        purchaseSuccess.amount = "<AMOUNT>"
        purchaseSuccess.originalPurchaseDate = "<ORIGINAL_PURCHASE_DATE>"
        purchaseSuccess.purchaseDate = "<PURCHASE_DATE>"
        purchaseSuccess.price = "<PRICE>"
        purchaseSuccess.currencyCode = "<CURRENCY_CODE>"
        purchaseSuccess.locale = "<LOCALE>"
        ' m.namiPaywallManager.callFunc("buySkuComplete", purchaseSuccess)
    end if
    closeDialog()
end sub

sub onPaywallDismissed()
    print "NamiDataSource : onPaywallDismissed"
    m.top.paywallScreenDismissed = true
end sub

function onAccountStateChanged(state, isSuccess, error)
    m.top.isLoggedIn = m.namiCustomerManager.callFunc("isLoggedIn")
    m.top.loggedInId = m.namiCustomerManager.callFunc("loggedInId")
    m.top.deviceId = m.namiCustomerManager.callFunc("deviceId")
    m.top.isUpdated = true

    if isSuccess
        if state = 0
            print "success logging in"
        else if state = 1
            print "success logging out"
        else if state = 2
            print "advertising id set"
        else if state = 3
            print "advertising id cleared"
        else if state = 4
            print "vendor id set"
        else if state = 5
            print "vendor id cleared"
        else if state = 6
            print "cdp id set"
        else if state = 7
            print "cdp id cleared"
        end if
    else
        if state = 0
            print "error logging in: " + error.message
        else if state = 1
            print "error logging out: " + error.message
        else if state = 2
            print "error setting advertising id: " + error.message
        else if state = 3
            print "error clearing advertising id: " + error.message
        else if state = 4
            print "error setting vendor id: " + error.message
        else if state = 5
            print "errot clearing vendor id: " + error.message
        else if state = 6
            print "error in setting cdp id: " + error.message
        else if state = 7
            print "error in clearing dp id: " + error.message
        end if
    end if
end function

function paywallActionHandler(paywallAction as dynamic)
    print "NamiDataSource : In paywallActionHandler ---> "
    print paywallAction
    print "NamiDataSource : <--- "
end function
