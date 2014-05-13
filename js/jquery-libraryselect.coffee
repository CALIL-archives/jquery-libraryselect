(($) ->
  $.fn.librarysystempicker = (func)->
    $element = this
    move = false
    log = (obj) ->
        try
            console.log obj
    addCSS = (code)->
        #CSSノード追加
        newStyle = document.createElement('style')
        newStyle.type = "text/css"
        document.getElementsByTagName('head').item(0).appendChild(newStyle)
        css = document.styleSheets.item(0)
        if document.styleSheets[0].cssRules
            idx = document.styleSheets[0].cssRules.length
        else
            idx = 0
        #追加
        css.insertRule(code, 0) #末尾に追加
      # APIを叩く
      get_api = (param, func)->
        if param.type? and param.type=='search'
          url = "//api.calil.jp/mobile/search"
        else if param.type? and param.type=='group'
          url = "//api.calil.jp/mobile/group"
          # キャッシュがあれば使う
          if @get_groups(param.id)
            return func(@get_groups(param.id))
        else
          url = "//api.calil.jp/mobile/recommend"
        $.ajax
          url: url
          type: "GET"
          data: param
          dataType: "jsonp"
          timeout: 5000
          error: ()->
            alert('読み込みに失敗しました。')
          success: (data) =>
            if param.type? and param.type=='group'
              @add_groups(param.id, data)
            func(data)

    addCSS("""
#library_select_div {
    //display: none;
    height: 252px;
    overflow:auto;
    position: absolute;
    z-index: 100000;
    border: 1px solid #CCC;
    background-color: white;
    padding: 0;
    margin: 0;
}
""")
    addCSS("""
#library_select_div div {
    padding: 10px;
}
""")
    addCSS("""
#library_select_div div:hover {
    background-color: #CCC;
}
""")
    $(document).on('focus', $element.selector, ->
        log 'focus'
        $textbox = $($element.selector)
        log $element.length
        $(document.body).after('<div id="library_select_div"></div>')
        offset = $textbox.offset()
        $('#library_select_div').css(
            'width' : parseFloat($textbox.css('width').split('px')[0])
            'top'   : offset['top']+parseFloat($textbox.css('height').split('px')[0])
            'left'  : offset['left']
        )
        setTimeout(->
            $textbox.select()
        , 100)
    )
    $(document).on('blur', $element.selector, ->
        log 'blur'
        $('#library_select_div').remove()
    )
    $(document).on('change keyup', $element.selector, ->
        keyword = $($element.selector).val()
        log keyword
        if keyword==''
          return
        params =
          'type'    : 'search'
          'keyword' : keyword
        log params
        get_api(params, (data)=>
            log data
            $('#library_select_div').empty()
            $(data).each((i, lib)->
                $('#library_select_div').append("""<div id="#{lib.id}">#{lib.name}</div>""")
            )
        )
    )
    $(document).on('mousedown', '#library_select_div div', ->
        func($(this).attr('id'))
    )
    return this
)(jQuery)