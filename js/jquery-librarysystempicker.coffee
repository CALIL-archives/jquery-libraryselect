(($) ->
  $.fn.librarysystempicker = (func)->
    $element = this
    move = false
    $(document).on('change keyup', this, ->
        func()
    )
    return this
)(jQuery)