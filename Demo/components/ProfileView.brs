sub init()
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiCustomerManager = m.namiSDK.findNode("NamiCustomerManagerObj")
    m.isFirstTime = false
    m.isActionInProcess = false

    m.lDeviceId = m.top.findNode("lDeviceId")
    m.lUserInfo = m.top.findNode("lUserInfo")
    m.lJourneyState = m.top.findNode("lJourneyState")
    m.lInstruction = m.top.findNode("lInstruction")

    m.top.observeField("visible", "onVisibleChange")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.lInstruction.setFocus(true)
        updateProfileView()
    else
    end if
end sub

sub updateProfileView()
    m.isActionInProcess = false
    m.lDeviceId.text = "Device ID: " + m.top.namiDataSource.deviceId

    if m.top.namiDataSource.isLoggedIn = true
        m.lInstruction.text = "Press * to logout"
        m.lUserInfo.text = "Registered User: External ID: " + m.top.namiDataSource.loggedInId
    else
        m.lInstruction.text = "Press * to login"
        m.lUserInfo.text = "Anonymous User"
    end if

    m.scene.callFunc("hideLoader")
end sub

sub OnUserAction()
    m.scene.callFunc("showLoader")

    m.top.namiDataSource.unobserveField("isUpdated")
    m.top.namiDataSource.observeField("isUpdated", "OnDataSourceUpdated")

    m.isActionInProcess = true
    if m.top.namiDataSource.isLoggedIn = true
        OnUserActionLogout()
    else
        OnUserActionLogin()
    end if
end sub

sub OnUserActionLogout()
    m.namiCustomerManager.callFunc("logout")
end sub

sub OnUserActionLogin()
    deviceInfo = CreateObject("roDeviceInfo")
    id = deviceInfo.GetRandomUUID()
    m.namiCustomerManager.callFunc("login", id)
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "CampaignView : onInitializeChanged : initialize : " initialize
    if initialize
        updateProfileView()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "ProfileView OnKeyEvent: press " press " key : " key
        if key = "options" and m.isActionInProcess = false
            OnUserAction()
            result = true
        end if
    end if

    return result
end function
