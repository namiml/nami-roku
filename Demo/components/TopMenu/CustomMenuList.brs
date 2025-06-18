sub init()
    setControls()
    initialize()
    setObservers()
end sub

sub setControls()
    m.test = m.top.findnode("test")
    m.lastFocusMenu = invalid
    m.lastSeletedMenu = invalid
end sub

sub initialize()
    m.top.itemComponentName="MenuItem"
    m.top.numRows=1
    m.top.variableWidthItems=[true]
    m.top.rowFocusAnimationStyle="floatingFocus"
    m.top.vertFocusAnimationStyle="fixedFocus"
    m.top.drawFocusFeedback=false
    m.itemSpacing = 10
    m.iconWidth = 36
    m.top.rowItemSize = [[55, 40]]
    m.top.rowItemSpacing = [m.itemSpacing,0]
    m.totalMenuWidth = 0
    m.lastSelectedItem = 0
end sub

sub setObservers()
    m.top.observeField("visible", "OnVisibleChange")
    m.top.observeField("focusedChild","OnFocusedChild")
    m.top.observeField("rowitemFocused", "onItemFocusedChanged")
    m.top.observeField("rowItemSelected", "onItemSelectedChanged")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    print "CustomMenuList : OnVisibleChange : isVisible : " isVisible
end sub

sub onFocusedChild()
  if m.top.hasFocus() and m.top.isInFocusChain() then
      if m.lastFocusMenu <> invalid
          m.lastFocusMenu.isFocus = false
      end if
      ' m.top.rowitemFocused = m.lastAnimatedItem
  end if
end sub

function onMenuItemChange(event as object)
    items = event.getdata()
    if items.count() > 0
        setContent(items)
    else
        if m.top.content <> invalid
            m.top.content.setfields({"content":invalid})
        end if
        m.top.visible = false
    end if
End Function

function setContent(items)
    if  m.top.content = invalid or m.top.content.getChildCount() = 0 then
      m.lastAnimatedItem = [0,0]
    end if
    m.top.content = invalid
    m.menuPositions = CreateObject("roArray",0,true)
    m.menuSize = CreateObject("roArray",0,true)
    content = createObject("roSGNode", "ContentNode")
    row  = createObject("roSGNode", "ContentNode")
    counter = 0
    m.prevWidth = 0
    setLowestMenuitemSize(items)
    for each item in items
        child = createObject("roSGNode", "ContentNode")
        if item.Title <> invalid and item.Title <> ""
            child.title = item.Title
        end if
        child.AddFields(item)
        child.Addfields({ "FHDItemWidth": 0.0, "type": "rowlist", "isSelected": false, "isFocus": false })
        addMenuItemPostion(child, child.title, counter)
        if ((m.top.SetFirstItemSelected = true and counter = 0) or (m.top.selectedMenu <> invalid and LCase(m.top.selectedMenu) = LCase(item.Title)))
            child.isSelected = true
            if m.top.SetFirstItemSelected and counter = 0
                m.lastAnimatedItem = [0, 0]
            else
                m.lastAnimatedItem = [0, counter]
            end if
            m.lastSeletedMenu = child
            m.lastFocusMenu = child
        end if
        row.appendchild(child)
        counter++
    end for
    content.appendchild(row)

    m.top.itemSize = [m.totalMenuWidth, 75]
    m.top.content = content
    m.top.rowitemFocused = m.lastAnimatedItem
    m.top.jumpToRowItem = m.lastAnimatedItem
    m.top.customRowItemSelected = m.lastAnimatedItem

    if m.lastSeletedMenu <> invalid
        m.lastSeletedMenu.isFocus = false
        m.lastSeletedMenu.isSelected = true
    else
        firstChild = content.getChild(m.lastAnimatedItem[0]).getChild(m.lastAnimatedItem[1])
        if firstChild <> invalid
            m.lastSeletedMenu = firstChild
            firstChild.isFocus = false
            firstChild.isSelected = true
        end if
    end if
end function

sub setLowestMenuitemSize(items as object)
    setHeight = true
    m.totalMenuWidth = 0
    for each item in items
        m.test.text = ""
        if item.Title <> invalid
            m.test.text = item.Title
        end if
        textWidth = 0
        if m.test.text <> ""
            textBoundingRect = m.test.boundingRect()
            textWidth = textBoundingRect.width + m.iconWidth + 30
        else
            textWidth = m.iconWidth + 30 + 20
        end if
        m.totalMenuWidth += textWidth
        m.totalMenuWidth += m.itemSpacing
        if setHeight then
            m.top.MenuFocusedYPos = 144 - 90
            setHeight = false
        end if
    end for
    m.totalMenuWidth = m.totalMenuWidth - m.itemSpacing
    m.top.totalWidth = m.totalMenuWidth
end sub

function addMenuItemPostion(child as object, title as string, counter as integer)
  textWidth = 0
  if title <> ""
      m.test.text = title
      textWidth = m.test.boundingRect().width + m.iconWidth + 30
  else
      textWidth = m.iconWidth + 30 + 20
  end if
  child.Update({FHDItemWidth: textWidth}, true)
  if counter = 0
      xPos = (textWidth - m.top.MenuFocusedWidth) / 2
      focuseIndicatorPos = xPos
      m.prevWidth = textWidth + m.itemSpacing
  else
      xPos = (textWidth - m.top.MenuFocusedWidth) / 2
      focuseIndicatorPos = m.prevWidth + xPos
      m.prevWidth = m.prevWidth + textWidth + m.itemSpacing
  end if
  m.menuPositions.push(focuseIndicatorPos)
  m.menuSize.push(textWidth)
end function

function onItemFocusedChanged(event as dynamic)
    index = event.GetData()
    if m.lastFocusMenu <> invalid
        m.lastFocusMenu.isFocus = false
    end if
    menuItem = m.top.content.getChild(index[0]).getChild(index[1])
    m.top.lastMenuFocus = menuItem
    menuItem.isFocus = true
    m.lastAnimatedItem = index
    m.top.rowitemFocused = index
    m.lastFocusMenu = menuItem
end function

function onItemSelectedChanged(event as dynamic)
    index = event.GetData()
    if m.lastSeletedMenu <> invalid
        m.lastSeletedMenu.isFocus = false
        m.lastSeletedMenu.isSelected = false
    end if
    menuItem = m.top.content.getChild(index[0]).getChild(index[1])
    if menuItem <> invalid
        menuItem.isFocus = false
        menuItem.isSelected = true
    end if
    m.top.customRowItemSelected = index
    m.lastSeletedMenu = menuItem
    m.lastAnimatedItem = index
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    print "CustomMenuList onKeyEvent "m.top.id " "key " "press
    if press then
        if key = "up"
            handled = true
        else if key = "down"
            if m.lastFocusMenu <> invalid
                m.lastFocusMenu.isFocus = false
            end if
        end if
    end if
    return handled
end function
