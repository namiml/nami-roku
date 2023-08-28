sub init()
    m.scene = m.top.getScene()
    m.lTitle = m.top.findNode("lTitle")

    m.top.observeField("visible", "onVisibleChange")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.lTitle.setFocus(true)
    else
    end if
end sub

sub onIntializeChanged(event as dynamic)
    initialize = event.getData()
    print "EntitlementView : onIntializeChanged : initialize : " initialize
    if initialize
        m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
        m.namiCustomerManager = m.scene.namiManager.namiCustomerManager
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "EntitlementView OnKeyEvent: press " press " key : " key
    end if

    return result
end function
