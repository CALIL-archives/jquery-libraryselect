(($) ->
  $.fn.librarysystempicker = (func)->
    $element = this
    move = false
    $(document).on('change keydown', this, ->
        func()
    )
    return this
)(jQuery)