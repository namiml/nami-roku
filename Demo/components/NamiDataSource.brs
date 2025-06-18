sub init()
    print "init NamiDataSource"
    setupLocals()
    initializeNamiSDKValues()
end sub

sub setupLocals()
    m.scene = m.top.getScene()
    m.namiManager = m.scene.namiManager
    m.namiCustomerManager = m.namiManager.namiCustomerManager
    m.namiCampaignManager = m.namiManager.namiCampaignManager
    m.namiFlowManager = m.namiManager.namiFlowManager
    m.namiPaywallManager = m.namiManager.namiPaywallManager
    m.namiPurchaseManager = m.namiManager.namiPurchaseManager
    m.namiEntitlementManager = m.namiManager.namiEntitlementManager
    m.billing = createObject("RoSGNode", "RokuBillingTask")
end sub

sub initializeNamiSDKValues()
    ' m.namiCustomerManager.setCustomerAttribute("firstName", "Vidhi")
    ' m.namiCustomerManager.setCustomerAttribute("email", "vidhi@hexabrain.com")


    m.top.isLoggedIn = m.namiCustomerManager.callFunc("isLoggedIn")
    m.top.loggedInId = m.namiCustomerManager.callFunc("loggedInId")
    m.top.deviceId = m.namiCustomerManager.callFunc("deviceId")
    m.top.journeyState = m.namiCustomerManager.callFunc("journeyState")
    m.top.campaigns = m.namiCampaignManager.callFunc("allCampaigns")
    m.top.activeEntitlements = m.namiEntitlementManager.callFunc("active")

    print "NamiDataSource : initializeNamiSDKValues"
    m.namiPaywallManager.callFunc("registerBuySkuHandler", m.top)
    m.namiPaywallManager.callFunc("registerSignInHandler", m.top)
    m.namiPaywallManager.callFunc("registerRestoreRequestHandler", m.top)
    m.namiPaywallManager.callFunc("registerDeeplinkActionHandler", m.top)
    m.namiCustomerManager.callFunc("registerAccountStateHandler", m.top)
    m.namiCustomerManager.callFunc("setCustomerDataPlatformId", "aaaa")
    m.namiPurchaseManager.callFunc("registerPurchasesChangedHandler", m.top, "OnPurchaseResultChanged")
    m.namiFlowManager.callFunc("registerStepHandoff", m.top)
    m.namiFlowManager.callFunc("registerEventHandler", m.top)
end sub

function registerRestoreHandlerCallback()
    ' Restore purchase process
    m.namiPaywallManager.callFunc("dismiss")
    print "NamiDataSource : registerRestoreHandlerCallback: restore pressed"
end function

function registerSignInHandlerCallback()
    ' Sign in process
    m.namiPaywallManager.callFunc("dismiss")
    print "NamiDataSource : registerSignInHandlerCallback: sign in pressed"
end function

function registerStepHandoffCallback(handoffTag, handoffData)
    ' Step handoff process
    print "NamiDataSource : registerStepHandoffCallback : handoffTag : " handoffTag " handoffData : " handoffData

    if handoffTag = "push" then
        ' Roku does not support push notifications like iOS.
        m.namiFlowManager.callFunc("resume")

    else if handoffTag = "location" then
        ' Roku does not support location authorization like iOS.
        m.namiFlowManager.callFunc("resume")

    else if handoffTag = "deeplink" then
        m.namiFlowManager.callFunc("resume")

    else if handoffTag = "complete" then
        setCustomerAttributes(handoffData)
        ' m.namiCustomerManager.callFunc("setCustomerAttribute", "onboardingComplete", "true")
        m.namiFlowManager.callFunc("resume")
    else
        print "Unhandled Nami Flow handoff " + handoffTag
    end if

end function

function registerEventHandlerCallback(event)
    for each key in event
        value = event[key]
        stringValue = ""
        if type(value) = "roBoolean" then
            stringValue = value.ToStr()
        else if type(value) = "roInt" or type(value) = "roFloat" then
            stringValue = value.ToStr()
        else if type(value) = "roString" then
            stringValue = value
        else if Type(value) = "roAssociativeArray" then
            stringValue = associativeArrayToString(value)
        else
            print "Unsupported value for key '" + key + "': " + type(value)
        end if

        print "registerEventHandlerCallback:: " + key + " " + stringValue
    end for
end function

function associativeArrayToString(obj as object) as string
    str = "{"
    for each key in obj
        str = str + key.ToStr() + ": " + obj[key].ToStr() + ", "
    end for

    if str.len() > 1
        ' Remove trailing comma and space
        str = Left(str, str.len() - 2)
    end if

    str = str + "}"
    return str
end function

function deeplinkActionHandlerCallback(url)
    ' deeplink url open process
    print "NamiDataSource : deeplinkActionHandlerCallback : deeplink url : " url
    m.namiPaywallManager.callFunc("dismiss")
end function

function registerBuySkuHandlerCallback(sku as dynamic)
    print "NamiDataSource : registerBuySkuHandlerCallback : sku : " sku
    m.top.sku = sku

    m.billing.observeField("purchaseResult", "OnPurchaseResultReceived")
    m.billing.purchase = sku.product
end function

sub OnPurchaseResultReceived(event as dynamic)
    purchaseResult = event.getData()
    if purchaseResult <> invalid and purchaseResult.issuccess
        m.namiPaywallManager.callFunc("dismiss")
        m.top.purchaseResult = purchaseResult
        showPurchaseDialog(m.top.sku)
    else
        print "NamiDataSource : OnPurchaseResultReceived : purchaseResult : " purchaseResult
    end if
end sub

sub showPurchaseDialog(skuDetail)
    m.purchaseDialog = createObject("roSgNode", "StandardMessageDialog")
    m.purchaseDialog.title = "Success"
    m.purchaseDialog.message = ["You have successfully purchased " + skuDetail.name]
    m.purchaseDialog.buttons = ["Ok"]

    ' observe the dialog's buttonSelected field to handle button selections
    m.purchaseDialog.observeFieldScoped("buttonSelected", "onButtonSelected")

    m.scene.dialog = m.purchaseDialog
end sub

sub closeDialog()
    if (m.scene.dialog <> invalid)
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
    if isSuccessfulPurchase and m.top.purchaseResult <> invalid
        cost = m.top.sku.product.cost
        purchaseResult = m.top.purchaseResult
        purchaseSuccess = m.namiManager.CreateChild("namiSDK:NamiPurchaseSuccess")
        purchaseSuccess.product = m.top.sku
        purchaseSuccess.rokuProductId = m.top.sku.product.id
        purchaseSuccess.productId = m.top.sku.skuId
        purchaseSuccess.purchaseId = purchaseResult.purchaseId
        purchaseSuccess.qty = purchaseResult.qty
        purchaseSuccess.amount = cost.Mid(1, cost.Len())
        purchaseSuccess.originalPurchaseDate = "/Date(1694416919877+0000)/" 'Get from transaction
        purchaseSuccess.originalTransactionID = purchaseResult.purchaseId
        purchaseSuccess.purchaseDate = "/Date(1694416919877+0000)/" 'Get from transaction
        purchaseSuccess.price = cost.Mid(1, cost.Len())
        purchaseSuccess.currencyCode = "usd" 'Get from transaction
        purchaseSuccess.locale = "<LOCALE>"
        purchaseSuccess.expiresDate = "/Date(1695021719877+0000)/" 'Get from transaction
        m.namiPaywallManager.callFunc("buySkuComplete", purchaseSuccess)
    end if
    closeDialog()
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
            print "ERROR: logging in: "; error.message
        else if state = 1
            print "ERROR: logging out: "; error.message
        else if state = 2
            print "ERROR: setting advertising id: "; error.message
        else if state = 3
            print "ERROR: clearing advertising id: "; error.message
        else if state = 4
            print "ERROR: setting vendor id: "; error.message
        else if state = 5
            print "ERROR: clearing vendor id: "; error.message
        else if state = 6
            print "ERROR: in setting cdp id: "; error
        else if state = 7
            print "ERROR: in clearing dp id: "; error.message
        end if
    end if
end function

function paywallActionHandler(paywallAction as dynamic)
    print "NamiDataSource : In paywallActionHandler ---> "
    print paywallAction
    print "NamiDataSource : <--- "
end function

function OnPurchaseResultChanged(purchase)
    print "NamiDataSource : In OnPurchaseResultChanged : " purchase
    print "NamiDataSource : transaction details in purchase : " purchase.transaction
end function

function setCustomerAttributes(handoffData as dynamic)
    print "NamiDataSource : setCustomerAttributes : handoffData : " handoffData
    if handoffData <> invalid
        for each key in handoffData.keys()
            value = handoffData[key]
            stringValue = ""
            if Type(value) = "roInt" or Type(value) = "Integer"
                stringValue = value.ToStr()
            else if Type(value) = "roString" or Type(value) = "String"
                stringValue = value
            else if Type(value) = "roBoolean" or Type(value) = "Boolean"
                if value
                    stringValue = "true"
                else
                    stringValue = "false"
                end if
            else
                print "Unsupported value for key '" + key + "': " + Type(value)
            end if
            m.namiCustomerManager.callFunc("setCustomerAttribute", key, stringValue)
        end for
    end if
end function