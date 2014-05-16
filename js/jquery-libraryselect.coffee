(($) ->

touchsupport = window.ontouchstart? #タッチイベントの切り替え判定
if touchsupport
    bind_start = 'touchstart'
    bind_move  = 'touchmove'
    bind_end   = 'touchend'
else
    bind_start = 'mousedown'
    bind_move  = 'mousemove'
    bind_end   = 'mouseup'

$.fn.libraryselect = (options)->
    $element = this
    default_options = {
        'font-size': '12px'
        'keyword'  : false
        'selector' : $element.selector
        'label'    : false
        'onselect' : (system_id)->
            $($element.selector).val(system_id)
    }
    options = $.extend(default_options, options)
    log = (obj) ->
        try
            console.log obj
    add_css = (css_code)->
        #CSSノード追加
        newStyle = document.createElement('style')
        newStyle.type = "text/css"
        document.getElementsByTagName('head')[0].appendChild(newStyle)
        newStyle.innerHTML = css_code
    #        css = document.styleSheets[0]
    #        if document.styleSheets[0].cssRules
    #            idx = document.styleSheets[0].cssRules.length
    #        else
    #            idx = 0
        #追加
    #        css.insertRule(css_code, 0) #末尾に追加
      # APIを叩く
      get_api = (param, func)->
        if param.type? and param.type=='search'
          url = "//api.calil.jp/mobile/search"
        $.ajax
          url: url
          type: "GET"
          data: param
          dataType: "jsonp"
          timeout: 5000
          error: ()->
            log('読み込みに失敗しました。')
          success: (data) =>
            if param.type? and param.type=='group'
              @add_groups(param.id, data)
            func(data)

    add_css("""
#library_select_div {
    display: none;
    height: 252px;
    overflow:auto;
    position: absolute;
    z-index: 100000;
    border: 1px solid #CCC;
    background-color: white;
    padding: 0;
    margin: 0;
}
#library_select_div div {
    font-size: 12px;
    padding: 10px;
}
#library_select_div div:hover {
    background-color: #CCC;
}
    """)
    $(document).on('focus', $element.selector, ->
        log 'focus'
        $textbox = $($element.selector)
        $(document.body).after("""<div id="library_select_div" selector="#{options.selector}"></div>""")
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
    $(document).on('focus keyup', $element.selector, (event)->
        keyword = $($element.selector).val()
        log keyword
        log event.keyCode
        if keyword==''
            return $('#library_select_div').hide().empty()
        else
            $('#library_select_div').show()
        params =
            'type'    : 'search'
            'keyword' : keyword
            'limit'   : 10
        get_api(params, (data)=>
            log data
            $('#library_select_div').empty()
            style = ''
            if options['font-size']
                style='font-size:'+options['font-size']
            $(data).each((i, lib)->
                $('#library_select_div').append("""<div id="#{lib.id}" name="#{lib.name}" style="#{style}">#{lib.name} (#{lib.id})</div>""")
            )
        )
    )
    $(document).on(bind_start, '#library_select_div div', ->
        # 一つのページに複数設置されたケースに対応
        if $('#library_select_div').attr('selector')==options.selector
            options.onselect($(this).attr('id'))
            if options.label
                $(options.label).text($(this).attr('name'))
    )
    if options.keyword
        params =
          'type'    : 'search'
          'keyword' : options.keyword
        get_api(params, (data)=>
            if data.length>0
                if options.label
                    $(options.label).text(data[0].name)
        )
    return this
)(jQuery)