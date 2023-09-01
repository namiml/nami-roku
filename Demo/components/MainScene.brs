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
    m.contentViewControl = m.top.findNode("contentViewControl")
    InitializeNamiSDK()
end sub

sub createBusySpinner()
    m.loader = m.top.findNode("loader")
    m.loader.poster.uri = "pkg:/images/loader.png"
    m.loader.poster.width = 160
    m.loader.poster.height = 160
    m.loader.visible = true
end sub

sub showContentView(isReady as boolean)
    print "MainScene : showContentView : isReady : " isReady
    hideLoader()
    if isReady
        m.namiCampaignManager = m.namiManager.namiCampaignManager
        m.namiCustomerManager = m.namiManager.namiCustomerManager
        m.namiPaywallManager = m.namiManager.namiPaywallManager
        m.namiEntitlementManager = m.namiManager.namiEntitlementManager

        m.contentViewControl.initialize = true
        m.contentViewControl.visible = true
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
            if (m.namiManager.namiStatus = "READY")
                showLoader()
                m.namiManager.callFunc("doTasksBeforeAppExit", m.top, "onExitApp")
                result = true
            end if
        end if
    end if
    return result
end function
