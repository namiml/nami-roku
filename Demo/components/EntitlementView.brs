sub init()
    print "init EntitlementView"
    m.scene = m.top.getScene()
    m.lTitle = m.top.findNode("lTitle")
    m.activeEntitlementList = invalid

    m.llActiveEntitlements = m.top.findNode("llActiveEntitlements")
    m.llPurchasedSkus = m.top.findNode("llPurchasedSkus")

    m.lNoItems = m.top.findNode("lNoItems")

    m.llActiveEntitlements.observeField("itemSelected", "OnItemSelected")
    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild","OnFocusedChildChange")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()

    print "EntitlementView : onVisibleChange : isVisible : " isVisible

    if isVisible
        latestActiveEntitlements = m.namiEntitlementManager.callFunc("active")
        m.top.namiDataSource.activeEntitlements = latestActiveEntitlements
        m.activeEntitlementList = latestActiveEntitlements
        m.namiEntitlementManager.callFunc("registerActiveEntitlementsHandler", m.top, "activeEntitlementsHandlerCallback")
        m.llActiveEntitlements.setFocus(true)

        m.llPurchasedSkus.content = invalid
        m.llPurchasedSkus.visible = false
    end if
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "EntitlementView : onIntializeChanged : initialize : " initialize
    if initialize
        m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
        m.namiEntitlementManager = m.scene.namiManager.namiEntitlementManager
        latestActiveEntitlements = m.namiEntitlementManager.callFunc("active")
        m.top.namiDataSource.activeEntitlements = latestActiveEntitlements
        m.activeEntitlementList = m.top.namiDataSource.activeEntitlements
        OnActiveEntitlementListReceived()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "EntitlementView OnKeyEvent: press " press " key : " key
        if (key = "options")
            refreshData()
            result = true
        end if
    end if

    return result
end function

sub OnActiveEntitlementListReceived()
    print "EntitlementsView : OnActiveEntitlementListReceived invoked"

    if m.activeEntitlementList = invalid or m.activeEntitlementList.count() = 0
        m.llActiveEntitlements.content = invalid
        m.llActiveEntitlements.visible = false
        m.lNoItems.visible = true
        m.scene.callFunc("hideLoader")
        return
    end if

    m.lNoItems.visible = false

    m.llActiveEntitlements.content = parseActiveEntitlementList(m.activeEntitlementList)
    m.llActiveEntitlements.visible = true

    m.scene.callFunc("hideLoader")
end sub

function parseActiveEntitlementList(activeEntitlementList as dynamic)
    parentNode = createObject("RoSGNode", "ContentNode")
    for each ent in activeEntitlementList
        node = parentNode.createChild("ContentNode")
        node.title = ent.referenceId
    end for
    return parentNode
end function

function parsePurchasedSkuList(purchasedSkus as dynamic)
    parentNode = createObject("RoSGNode", "ContentNode")
    for each sku in purchasedSkus
        node = parentNode.createChild("ContentNode")
        node.title = sku.skuRefId
    end for
    return parentNode
end function

sub onItemSelected(event as dynamic)
    selectedIndex = event.getData()

    active = m.activeEntitlementList[selectedIndex]

    print "EntitlementsView : onItemSelected : Active Entitlement reference id : " active.referenceId

    relatedSkus = active.callFunc("getRelatedSkus")

    print "Related skus : " relatedSkus

    purchasedSkus = active.callFunc("getPurchasedSkus")
    print "Purchased skus : " purchasedSkus

    if purchasedSkus = invalid or purchasedSkus.count() = 0
        m.llPurchasedSkus.content = invalid
        m.llPurchasedSkus.visible = false
        return
    end if

    m.llPurchasedSkus.content = parsePurchasedSkuList(purchasedSkus)
    m.llPurchasedSkus.visible = true

end sub

sub refreshData()
    m.llActiveEntitlements.visible = false
    m.Scene.callFunc("showLoader")
    m.namiEntitlementManager.callFunc("refresh")
end sub

sub activeEntitlementsHandlerCallback(activeEntitlementList as dynamic)
    if activeEntitlementList <> invalid
        m.top.namiDataSource.activeEntitlements = activeEntitlementList
        m.activeEntitlementList = activeEntitlementList
        OnActiveEntitlementListReceived()
    end if
end sub
