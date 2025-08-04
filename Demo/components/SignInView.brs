sub init()
    print "init SignInView"
    m.scene = m.top.getScene()
    m.isFirstTime = false
    m.isActionInProcess = false

    m.userActionLogin = m.top.findNode("userActionLogin")
    m.buttonTextLogin = m.top.findNode("buttonTextLogin")
    m.userActionIgnore = m.top.findNode("userActionIgnore")
    m.buttonTextIgnore = m.top.findNode("buttonTextIgnore")
    m.buttonGrp = m.top.findNode("buttonGrp")

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.userActionLogin.observeField("focusedChild", "OnUserActionLoginFocusedChildChange")
    m.userActionIgnore.observeField("focusedChild", "OnUserActionFocusedChildChange")
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "SignInView : onIntializeChanged : initialize : " initialize
    if initialize
        m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
        m.namiCustomerManager = m.scene.namiManager.namiCustomerManager
    end if
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.userActionLogin.setFocus(true)
        buttonGrpRect = m.buttonGrp.boundingRect()
        m.buttonGrp.translation = [(1920 - buttonGrpRect.width) / 2, (1080 - buttonGrpRect.height) / 2]
    end if
end sub

sub OnFocusedChildChange()
    if m.top.hasFocus()
        m.userActionLogin.setFocus(true)
    end if
end sub

sub OnUserActionLoginFocusedChildChange()
    if m.userActionLogin.hasFocus()
        m.userActionLogin.blendColor = "#1374de"
    else
        m.userActionLogin.blendColor = "#404040"
    end if
end sub

sub OnUserActionFocusedChildChange()
    if m.userActionIgnore.hasFocus()
        m.userActionIgnore.blendColor = "#1374de"
    else
        m.userActionIgnore.blendColor = "#404040"
    end if
end sub

sub OnUserActionLogin()
    deviceInfo = CreateObject("roDeviceInfo")
    id = deviceInfo.GetRandomUUID()
    m.namiCustomerManager.callFunc("login", id)
end sub

sub onButtonSelected()
    if m.userActionLogin.hasFocus()
        OnUserActionLogin()
    else if m.userActionIgnore.hasFocus()
        m.top.namiDataSource.showSignIn = false
        m.namiPaywallManager.callFunc("setPaywallFocus")
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if (press)
        if key = "back"
            result = true
        else if key = "down"
            if m.userActionLogin.hasFocus()
                m.userActionIgnore.setFocus(true)
                result = true
            end if
        else if key = "up"
            if m.userActionIgnore.hasFocus()
                m.userActionLogin.setFocus(true)
                result = true
            end if
        else if key = "OK"
            if (m.userActionLogin.hasFocus() or m.userActionIgnore.hasFocus())
                onButtonSelected()
                result = true
            end if
        end if
    end if

    return result
end function
