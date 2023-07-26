' Creates the component library node and loads the namiSDK from the URI mentioned in the appData.json as namiSDKPath
sub InitializeNamiSDK()
    print "NamiSDKIntegrationHelper : InitializeNamiSDK : Loading SDK, Path : " m.global.appConfig.namiSDKPath
    m.namiSDK = m.top.createChild("ComponentLibrary")
    m.namiSDK.id = "namiSDK"
    m.top.appendChild(m.bitmovinPlayerSDK)
    m.namiSDK.observeField("loadStatus", "onSDKLoadStatusChanged")
    m.namiSDK.uri = m.global.appConfig.namiSDKPath
end sub

' Creates the SDK wrapper once the component library node successfully loads the namiSDK
sub onSDKLoadStatusChanged(event as dynamic)
    loadStatus = event.getData()
    if loadStatus = "ready"
        print "NamiSDKIntegrationHelper : onSDKLoadStatusChanged : SDK loaded successfully."
        m.namiSDK.unobserveField("loadStatus")
        configureNamiManager()
    else if loadStatus = "failed"
        print "*** ERROR *** NamiSDKIntegrationHelper : InitializeNamiSDK : Failed to load SDK."
        ' Add Error Hanlding if required
    end if
end sub

sub configureNamiManager()
    createNamiManager()
    namiConfig = getNamiConfig()

    ' Get SDK ready state before displaying campaign
    m.namiManager.observeField("namiStatus", "OnNamiStatusReceived")

    m.namiManager.callFunc("configure", namiConfig)
end sub

sub createNamiManager()
    m.namiManager = CreateObject("roSGNode", "namiSDK:Nami")
    m.top.namiManager = m.namiManager
end sub

sub getNamiConfig() as object
    ' TODO: REMOVE THIS
    if (m.global.appConfig.isUseDummyProducts)
        dummyProducts = ReadAsciiFile(m.global.appConfig.namiDummyProductsFilePath)
        if (dummyProducts <> invalid and dummyProducts <> "")
            m.namiManager.dummyProducts = dummyProducts
        end if
    end if

    appPlatformId = m.global.appConfig.appPlatformIdProduction
    if m.global.appConfig.environment = "staging"
        appPlatformId = m.global.appConfig.appPlatformIdStaging
    end if

    namiCommands = []
    if m.global.appConfig.environment = "staging"
        namiCommands = ["useStagingAPI"]
    end if

    initialConfig = ReadAsciiFile(m.global.appConfig.namiInitialConfigFilePath)
    namiConfig = {
                appPlatformId   : appPlatformId
                fonts           : m.global.appConfig.fonts
                environment     : m.global.appConfig.environment
                logLevel        : ["info", "warn", "error", "debug"] '
                namiCommands    : namiCommands
                initialConfig   : initialConfig
            }
    return namiConfig
end sub

sub OnNamiStatusReceived(event as dynamic)
    namiStatus = event.getData()
    print "NamiSDKIntegrationHelper : OnNamiStatusReceived : SDK Status with data : " namiStatus
    m.namiManager.unobserveField("namiStatus")
    if (namiStatus = "READY")
        showContentView(true)
    else if (namiStatus = "ERROR")
        showContentView(false)
    end if
end sub
