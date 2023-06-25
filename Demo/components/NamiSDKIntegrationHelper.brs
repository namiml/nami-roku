' Creates the component library node and loads the namiSDK from the URI mentioned in the appData.json as namiSDKPath
sub InitializeNamiSDK()
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
        m.namiSDK.unobserveField("loadStatus")
        setupWrapperSDK()
        initialize()
    else if loadStatus = "failed"
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
    m.namiConfig.logLevel = "debug"

    if m.global.appConfig.environment = "staging"
        m.namiConfig.namiCommands = ["useStagingAPI"]
    end if

    ' Uncomment if you have initial config files in your appData.json
    ' initialConfigFileText = ReadAsciiFile(m.global.appConfig.namiInitialConfigFilePath)
    ' if initialConfigFileText <> invalid and initialConfigFileText <> ""
    '     m.namiConfig.initialConfig = initialConfigFileText
    ' end if

    m.nami = m.namiSDK.CreateChild("namiSDK:Nami")
    m.namiSDK.addFields({"nami": m.nami})

    ' As of now, we are not storing the api response in cache, so we will wait for the inital
    ' campaigns and paywall data to be received and then display them on screen.
    m.nami.observeField("isInitialDataLoaded", "OnSDKReadyWithData")

    ' This is for demo purpose only.
    m.nami.observeField("SDKStatusLabelText", "OnSDKStatusChanged")

    configureStatus = m.nami.callFunc("configure", m.namiConfig)
    print "NamiSDKIntegrationHelper : setupWrapperSDK : Nami configuration status : " configureStatus

    ' Recommended: Create the single objects for all the required interfaces before calling the interface methods
    m.namiCampaignManager = m.namiSDK.nami.callFunc("getCampaignManager")
    m.namiCustomerManager = m.namiSDK.nami.callFunc("getCustomerManager")
    m.namiPaywallManager = m.namiSDK.nami.callFunc("getPaywallManager")
    m.namiEntitlementManager = m.namiSDK.nami.callFunc("getEntitlementManager")
end sub

' This is for demo purpose only.
sub OnSDKStatusChanged(event as dynamic)
    statusText = event.getData()
    print "NamiSDKIntegrationHelper : OnSDKStatusChanged : status : " statusText
end sub

sub OnSDKReadyWithData(event as dynamic)
    isReady = event.getData()
    ' print "NamiSDKIntegrationHelper : SDK is ready with data"
    if isReady
        showContentView()
    end if
end sub
