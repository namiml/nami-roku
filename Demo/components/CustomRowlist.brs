sub Init()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if(press)
        print "CustomRowlist : onKeyEvent : key = " + key + " press = " + press.toStr()
        if key = "left"
            index = m.top.itemFocused
            if (m.top.content <> invalid)
                itemNode = m.top.content.getChild(index)
                if (itemNode <> invalid)
                    if (itemNode.colIndex = 1)
                        result = true
                    else if (itemNode.colIndex = 2)
                        m.top.itemFocused = index - 1
                        m.top.jumpToItem = index - 1
                        result = true
                    end if
                end if
            end if
        end if
    end if
    return result
end function
