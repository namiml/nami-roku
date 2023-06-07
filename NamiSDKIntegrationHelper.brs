' Creates the component library node and loads the namiSDK from the URI mentioned in the appData.json as namiSDKPath
sub InitializeNamiSDK()
    m.namiSDK = m.top.createChild("ComponentLibrary")
    m.namiSDK.id = "namiSDK"
    m.namiSDK.observeField("loadStatus", "onSDKLoadStatusChanged")
    m.namiSDK.uri = m.global.namiSDKPath
end sub

' Creates the SDK wrapper once the component library node successfully loads the namiSDK
sub onSDKLoadStatusChanged(event as dynamic)
    loadStatus = event.getData()
    if loadStatus = "ready"
        m.namiSDK.unobserveField("loadStatus")
        setupWrapperSDK()
        initialize()
    end if
end sub

sub setupWrapperSDK()
    ' Production and staging appPlatformId are set from the appData.json
    appPlatformId = m.global.appPlatformIdProduction
    if m.global.environment = "staging"
        appPlatformId = m.global.appPlatformIdStaging
    end if

    ' Create NamiConfiguration object and configure it with required data
    m.namiConfig = m.namiSDK.CreateChild("namiSDK:NamiConfiguration")
    m.namiConfig.callFunc("configuration", appPlatformId)
    m.namiConfig.logLevel = "debug"

    if m.global.environment = "staging"
        m.namiConfig.namiCommands = ["useStagingAPI"]
    end if  

    m.nami =  m.namiSDK.CreateChild("namiSDK:Nami")
    configureStatus = m.nami.callFunc("configure", m.namiConfig)

    ' This is for demo purpose only.
    m.nami.observeField("SDKStatusLabelText", "OnSDKStatusChanged")

    ' Recommended: Create the single objects for all the required interfaces before calling the interface methods
    m.namiCampaignManager = m.namiSDK.createChild("namiSDK:NamiCampaignManager")
    m.namiCustomerManager = m.namiSDK.createChild("namiSDK:NamiCustomerManager")
    m.namiPaywallManager = m.namiSDK.createChild("namiSDK:NamiPaywallManager")
    m.namiEntitlementManager = m.namiSDK.createChild("namiSDK:NamiEntitlementManager")

    ' As of now, we are not storing the api response in cache, so we will wait for the inital
    ' campaigns and paywall data to be received and then display them on screen.
    m.nami.observeField("isInitialDataLoaded", "OnSDKReadyWithData")
end sub

' This is for demo purpose only.
sub OnSDKStatusChanged(event as dynamic)
    statusText = event.getData()
    print "statusText: " statusText
end sub

sub OnSDKReadyWithData(event as dynamic)
    isReady = event.getData()
    ' print "SDK is ready with data - "
    if isReady
        showContentView()
    end if
end sub
