' Creates the component library node and loads the namiSDK from the URI mentioned in the appData.json as namiSDKPath
sub InitializeNamiSDK()
    print "NamiSDKIntegrationHelper : InitializeNamiSDK : Loading SDK, Path : " m.global.appConfig.namiSDKPath
    m.namiSDK = m.top.createChild("ComponentLibrary")
    m.namiSDK.id = "namiSDK"
    m.namiSDK.observeField("loadStatus", "onSDKLoadStatusChanged")
    m.namiSDK.uri = m.global.appConfig.namiSDKPath
    m.top.addFields({"namiSDK": m.namiSDK})
end sub

' Creates the SDK wrapper once the component library node successfully loads the namiSDK
sub onSDKLoadStatusChanged(event as dynamic)
    loadStatus = event.getData()
    if loadStatus = "ready"
        print "NamiSDKIntegrationHelper : onSDKLoadStatusChanged : SDK loaded successfully."
        m.namiSDK.unobserveField("loadStatus")
        setupWrapperSDK()
        initialize()
    else if loadStatus = "failed"
        print "*** ERROR *** NamiSDKIntegrationHelper : InitializeNamiSDK : Failed to load SDK."
        ' Add Error Hanlding if required
    end if
end sub

sub setupWrapperSDK()
    ' Production and staging appPlatformId are set from the appData.json
    appPlatformId = m.global.appConfig.appPlatformIdProduction
    if m.global.appConfig.environment = "staging"
        appPlatformId = m.global.appConfig.appPlatformIdStaging
    end if

    ' Create NamiConfiguration object and configure it with required data
    m.namiConfig = m.namiSDK.CreateChild("namiSDK:NamiConfiguration")
    m.namiConfig.callFunc("configuration", appPlatformId, m.global.appConfig.fonts)
    m.namiConfig.logLevel = ["info", "warn", "error"] ' "debug"

    ' Only for Nami internal
    ' if m.global.appConfig.environment = "staging"
    '     m.namiConfig.namiCommands = ["useStagingAPI"]
    ' end if

    ' Uncomment if you have initial config files in your appData.json
    ' initialConfigFileText = ReadAsciiFile(m.global.appConfig.namiInitialConfigFilePath)
    ' if initialConfigFileText <> invalid and initialConfigFileText <> ""
    '     m.namiConfig.initialConfig = initialConfigFileText
    ' end if

    m.namiManager = m.namiSDK.CreateChild("namiSDK:Nami")
    m.namiSDK.addFields({"nami": m.namiManager})

    ' Get SDK ready state before displaying campaign
    m.namiManager.observeField("isInitialDataLoaded", "OnSDKReadyWithData")

    configureStatus = m.namiManager.callFunc("configure", m.namiConfig)
    print "NamiSDKIntegrationHelper : setupWrapperSDK : Nami configuration status : " configureStatus

    ' Get required objects as following
    m.namiCampaignManager = m.namiManager.callFunc("getCampaignManager")
    m.namiCustomerManager = m.namiManager.callFunc("getCustomerManager")
    m.namiPaywallManager = m.namiManager.callFunc("getPaywallManager")
    m.namiEntitlementManager = m.namiManager.callFunc("getEntitlementManager")
end sub

sub OnSDKReadyWithData(event as dynamic)
    isReady = event.getData()
    print "NamiSDKIntegrationHelper : SDK Status with data : " isReady
    if isReady
        showContentView()
    else
        ' TODO: Add required handling here
    end if
end sub
