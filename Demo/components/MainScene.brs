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

sub showContentView()
    m.contentViewControl.visible = true
end sub

sub onSDKValidationStatus(event as Dynamic)
    payload = event.getData()
    if payload <> invalid
        if payload <> invalid and payload.status = "none"
            print "Mainscene : onSDKValidationStatus none : " payload.message
        else if payload <> invalid and payload.status = "validating"
            print "Mainscene : onSDKValidationStatus validating : " payload.message
        else if payload <> invalid and payload.status = "validated"
            print "Mainscene : onSDKValidationStatus Success " payload.message
        else if payload <> invalid and payload.status = "fail"
            print "Mainscene : onSDKValidationStatus Error : " payload.message
        end if
    end if
end sub

sub initialize()
    m.top.setFocus(true)
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

function onPaywallDismissed()
    print "MainScene : onPaywallDismissed"
    m.top.paywallScreenDismissed = true
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "Mainscene : onKeyEvent : key = " key " press = " press
        if (key = "up" or key = "down")
        else if (key = "back") then
            if (m.top.paywallScreenDismissed = false)
                m.namiPaywallManager.callFunc("dismiss", m.top, "OnPaywallDismissed")
                result = true
            end if
        end if
    end if
    return result
end function
