sub init()
end sub

sub initialize()
    m.scene = m.top.getScene()
end sub

sub OnPurchaseChanged()
    m.top.functionName = "PurchaseProduct"
    m.top.control = "RUN"
end sub

sub PurchaseProduct()
    if m.channelStore = invalid
        m.port = CreateObject("roMessagePort")
        m.channelStore = CreateObject("roChannelStore")
        m.channelStore.SetMessagePort(m.port)
    end if

    m.channelStore.GetCatalog()
    msg = invalid
    while type(msg) <> "roChannelStoreEvent"
        msg = Wait(0, m.port)
    end while
    m.channelStore.ClearOrder()
    orderItems = [{
        code : m.top.purchase.code
        qty  : 1
    }]
    m.channelStore.SetOrder(orderItems)

    m.channelStore.DoOrder()
    msg = invalid
    while type(msg) <> "roChannelStoreEvent"
        msg = Wait(0, m.port)
    end while

    result = {
        isSuccess : msg.isRequestSucceeded()
        failureCode: msg.GetStatus()
        failureMessage: msg.GetStatusMessage()
    }

    if msg.isRequestSucceeded()
        response = msg.GetResponse()
        if response <> invalid AND response[0] <> invalid
            result.Append(response[0])
        end if
    else if msg.isRequestFailed()
        result.failureCode = msg.GetStatus()
        result.failureMessage = msg.GetStatusMessage()
    end if

    m.top.purchaseResult = result
end sub
