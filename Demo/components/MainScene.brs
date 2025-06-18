sub init()
    print "Mainscene : init"
    globalFields = {
        "appConfig": getAppConfigFromFile()
    }
    m.global.addFields(globalFields)
    setupControls()
end sub

sub setupControls()
    print "Mainscene : setupControls"
    createBusySpinner()
    m.lError = m.top.findNode("lError")
    m.gContentView = m.top.findNode("gContentView")
    m.namiConfigration = m.top.findNode("namiConfigration")
    m.namiConfigration.visible = true
    m.namiConfigration.setFocus(true)
    m.setNamiConfig = invalid
end sub

sub onNamiConfigration()
    namiConfig = m.top.namiConfig
    m.setNamiConfig = namiConfig
    m.namiConfigration.visible = false
    showLoader()
    InitializeNamiSDK(namiConfig)
end sub

sub createBusySpinner()
    m.loader = m.top.findNode("loader")
    m.loader.poster.uri = "pkg:/images/loader.png"
    m.loader.poster.width = 160
    m.loader.poster.height = 160
end sub

sub showHideContentView(isVisible)
    if isVisible
        m.contentViewControl = m.gContentView.createChild("ContentView")
        m.contentViewControl.id = "contentViewControl"
        m.contentViewControl.translation = [0, 0]
    else
        m.gContentView.removeChild(m.contentViewControl)
        m.contentViewControl = invalid
    end if
end sub

sub showContentView(isReady as boolean, isRefresh = false as boolean)
    print "MainScene : showContentView : isReady : " isReady
    ' hideLoader()
    if isReady
        m.namiCampaignManager = m.namiManager.namiCampaignManager
        m.namiCustomerManager = m.namiManager.namiCustomerManager
        m.namiPaywallManager = m.namiManager.namiPaywallManager
        m.namiEntitlementManager = m.namiManager.namiEntitlementManager
        showHideContentView(true)
        m.contentViewControl.initialize = true
        m.contentViewControl.visible = false
    else
        m.lError.visible = true
    end if
end sub

sub showLoader()
    m.loader.visible = true
end sub

sub hideLoader()
    m.loader.visible = false
end sub

sub OnCampaignRecieved()
    if m.top.isCampaignRecieved
        hideLoader()
        m.top.isCampaignRecieved = false
        m.contentViewControl.visible = true
    end if
end sub

function getAppConfigFromFile() as Dynamic
    print "Globals : getAppConfigFromFile "
    config = ReadAsciiFile("pkg:/source/data/AppData.json")
    configJson = ParseJson(config)
    if configJson <> Invalid
        print "Globals : App config file loaded : " ' config
    else
        print "*** Error : Globals : Invalid configuration"
    end if

    return configJson
end function

sub onExitApp()
    hideLoader()
    m.top.outRequest = {"ExitApp": true}
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "Mainscene : onKeyEvent : key = " key " press = " press
        if (key = "up" or key = "down")
        else if (key = "back")
            if m.namiConfigration.visible = false
                m.namiConfigration.visible = true
                m.namiConfigration.setFocus(true)
                showHideContentView(false)
                result = true
            else if (m.namiManager <> invalid and m.namiManager.namiStatus = "READY")
                showLoader()
                m.namiManager.callFunc("doTasksBeforeAppExit", m.top, "onExitApp")
                result = true
            end if
        end if
    end if
    return result
end function
