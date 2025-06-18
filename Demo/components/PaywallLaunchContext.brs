

sub init()
  print "init PaywallLaunchContext"
  SetLocals()
  SetControls()
  SetupFonts()
  SetupColors()
  SetObservers()
end sub

Sub SetLocals()
    m.scene = m.top.GetScene()
End Sub

Sub SetControls()
    m.pLaunchButton = m.top.findNode("pLaunchButton")
    m.buttonText = m.top.findNode("buttonText")
    m.toggleGrp = m.top.findNode("toggleGrp")
    m.toggleSwitchProduct = m.top.findNode("toggleSwitchProduct")
    m.lgProductGroups = m.top.findNode("lgProductGroups")
    m.toggleSwitches = [m.toggleSwitchProduct]
    m.currentToggleFocusIndex = 0
    m.currentRadioFocusIndex = -1
    m.radioButtons = []
    m.defaultProductGroup = []
    m.launchContextSet = CreateObject("roSGNode", "NamiSDK:PaywallLaunchContext")
    m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
    m.namiCampaignManager = m.scene.namiManager.namiCampaignManager
End Sub

Sub SetupFonts()
    ' m.itemLabel.font = m.fonts.latoReg30
End Sub

Sub SetupColors()
    ' m.itemLabel.color = m.theme.white
End Sub

Sub SetObservers()
    m.top.observeField("focusedChild", "OnFocusedChild")
    m.pLaunchButton.observeField("focusedChild", "OnLaunchButtonFocusedChildChange")
    m.toggleSwitchProduct.observeField("toggleSwitchOn","onProductGroupSwitch")
End Sub

sub OnFocusedChild()
    if m.top.hasFocus()
        m.toggleSwitches[m.currentToggleFocusIndex].setFocus(true)
    end if
end sub

sub OnLaunchButtonFocusedChildChange()
    if m.pLaunchButton.hasFocus()
        m.pLaunchButton.blendColor = "#1374de"
    else
        m.pLaunchButton.blendColor = "#404040"
    end if
end sub

sub onGetPaywallLabel(event as dynamic)
    paywallLabel = event.getData()
    if paywallLabel <> ""
        setDefaultProducts(paywallLabel)
        m.buttonText.text = "Launch " + paywallLabel + " with context"
        m.pLaunchButton.width = m.buttonText.boundingRect().width + 40
        m.buttonText.width = m.pLaunchButton.width
        toggleGrpReact = m.toggleGrp.boundingRect()
        m.pLaunchButton.translation = [(1920 - m.pLaunchButton.width)/2, toggleGrpReact.y + toggleGrpReact.height + 70]
    end if
end sub

sub onProductGroupSwitch(event as dynamic)
    isEnable = event.getData()
    if isEnable
        if m.lgProductGroups.getChildCount() = 0
            defaultRadioOn = false
            for each prod in m.defaultProductGroup
              radioButton = m.lgProductGroups.createChild("RadioButton")
              radioButton.radioLabel = prod
              radioButton.id = prod
              radioButton.value = [prod]
              if not defaultRadioOn
                defaultRadioOn = true
                radioButton.radioOnOff = true
              else
                radioButton.radioOnOff = false
              end if
              radioButton.observeField("radioOnOff", "onRadioOnOff")
              m.radioButtons.push(radioButton)
            end for

            m.launchContextSet.productGroups = m.defaultProductGroup

            radioButton = m.lgProductGroups.createChild("RadioButton")
            radioButton.radioLabel = "bad_group_1"
            radioButton.id = "bad_group_1"
            radioButton.value = ["nfl_premium","nfl"]
            radioButton.observeField("radioOnOff", "onRadioOnOff")
            m.radioButtons.push(radioButton)

            radioButton = m.lgProductGroups.createChild("RadioButton")
            radioButton.radioLabel = "bad_group_2"
            radioButton.id = "bad_group_2"
            radioButton.value = ["nfl1","nfl2"]
            radioButton.observeField("radioOnOff", "onRadioOnOff")
            m.radioButtons.push(radioButton)
        end if
    else
        m.launchContextSet.productGroups = []
        if m.lgProductGroups.getChildCount() > 0
            m.currentRadioFocusIndex = -1
            m.radioButtons = []
            m.lgProductGroups.removeChildrenIndex(m.lgProductGroups.getChildCount(), 0)
        end if
    end if
    toggleGrpReact = m.toggleGrp.boundingRect()
    screenRemaningSpace = 1080 - (toggleGrpReact.y + toggleGrpReact.height + 70 + m.pLaunchButton.boundingRect().height)
    m.pLaunchButton.translation = [(1920 - m.pLaunchButton.width)/2, toggleGrpReact.y + toggleGrpReact.height + 70]
    if screenRemaningSpace <= 0
        m.pLaunchButton.translation = [(1920 - m.pLaunchButton.width)/2, 1050 - m.pLaunchButton.boundingRect().height]
    end if
end sub

sub onRadioOnOff(event as dynamic)
    radioButtonOnNode = event.getRoSGNode()
    if radioButtonOnNode.radioOnOff
        m.launchContextSet.productGroups = radioButtonOnNode.value
    end if
    for i = 0 to m.radioButtons.count()-1
      if radioButtonOnNode.id <> m.radioButtons[i].id
          m.radioButtons[i].radioOnOff = false
      end if
    end for
end sub

sub setDefaultProducts(label)
  campaign = m.namiCampaignManager.callFunc("contextForCampaignRuleTypeLabel", label)
  if campaign <> invalid and campaign.paywall <> invalid
      raisePaywall = m.namiPaywallManager.callFunc("getPaywall", campaign.paywall)
      if raisePaywall <> invalid and raisePaywall.skuMenus <> invalid
          for each skuMenu in raisePaywall.skuMenus
              if skuMenu.ref <> invalid
                  m.defaultProductGroup.push(skuMenu.ref)
              end if
          end for
      end if
  end if
end sub

function OnkeyEvent(key as String, press as boolean) as boolean
    result = true
    if press
        print "PaywallLaunchContext : onKeyEvent : key = " key " press = " press
        if key = "down"
            if m.currentToggleFocusIndex < m.toggleSwitches.count()-1
                m.currentToggleFocusIndex++
                m.currentRadioFocusIndex = -1
                m.toggleSwitches[m.currentToggleFocusIndex].setFocus(true)
            else if m.radioButtons.count() > 0 and m.currentRadioFocusIndex < m.radioButtons.count()-1
                m.currentRadioFocusIndex++
                m.currentToggleFocusIndex = m.toggleSwitches.count()
                m.radioButtons[m.currentRadioFocusIndex].setFocus(true)
            else
                if (m.currentToggleFocusIndex = m.toggleSwitches.count()-1 and m.radioButtons.count() = 0)
                    m.currentToggleFocusIndex = m.toggleSwitches.count()
                    m.pLaunchButton.setFocus(true)
                else if m.radioButtons.count()-1 = m.currentRadioFocusIndex
                    m.currentRadioFocusIndex = m.radioButtons.count() - 1
                    m.currentToggleFocusIndex = m.toggleSwitches.count()
                    m.pLaunchButton.setFocus(true)
                end if
            end if
        else if key = "up"
            if m.pLaunchButton.hasFocus()
                if m.radioButtons.count() = 0
                    m.currentToggleFocusIndex--
                    m.toggleSwitches[m.currentToggleFocusIndex].setFocus(true)
                else
                    m.radioButtons[m.currentRadioFocusIndex].setFocus(true)
                end if
            else if m.radioButtons.count() > 0 and m.currentRadioFocusIndex > 0
                m.currentRadioFocusIndex--
                m.radioButtons[m.currentRadioFocusIndex].setFocus(true)
            else if m.currentToggleFocusIndex > 0
                m.currentToggleFocusIndex--
                m.currentRadioFocusIndex = -1
                m.toggleSwitches[m.currentToggleFocusIndex].setFocus(true)
            end if
        else if key = "back"
            result = false
        else if key = "OK"
            if m.pLaunchButton.hasFocus()
                m.top.launchContextSet = m.launchContextSet
            end if
        end if
    end if
    return result
end function
