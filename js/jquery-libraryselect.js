// Generated by CoffeeScript 1.3.1

(function($) {
  return $.fn.librarysystempicker = function(func) {
    var $element, addCSS, get_api, log, move;
    $element = this;
    move = false;
    log = function(obj) {
      try {
        return console.log(obj);
      } catch (_error) {}
    };
    addCSS = function(code) {
      var css, idx, newStyle;
      newStyle = document.createElement('style');
      newStyle.type = "text/css";
      document.getElementsByTagName('head').item(0).appendChild(newStyle);
      css = document.styleSheets.item(0);
      if (document.styleSheets[0].cssRules) {
        idx = document.styleSheets[0].cssRules.length;
      } else {
        idx = 0;
      }
      return css.insertRule(code, 0);
    };
    get_api = function(param, func) {
      var url,
        _this = this;
      if ((param.type != null) && param.type === 'search') {
        url = "//api.calil.jp/mobile/search";
      } else if ((param.type != null) && param.type === 'group') {
        url = "//api.calil.jp/mobile/group";
        if (this.get_groups(param.id)) {
          return func(this.get_groups(param.id));
        }
      } else {
        url = "//api.calil.jp/mobile/recommend";
      }
      return $.ajax({
        url: url,
        type: "GET",
        data: param,
        dataType: "jsonp",
        timeout: 5000,
        error: function() {
          return alert('読み込みに失敗しました。');
        },
        success: function(data) {
          if ((param.type != null) && param.type === 'group') {
            _this.add_groups(param.id, data);
          }
          return func(data);
        }
      });
    };
    addCSS("#library_select_div {\n    //display: none;\n    height: 252px;\n    overflow:auto;\n    position: absolute;\n    z-index: 100000;\n    border: 1px solid #CCC;\n    background-color: white;\n    padding: 0;\n    margin: 0;\n}");
    addCSS("#library_select_div div {\n    padding: 10px;\n}");
    addCSS("#library_select_div div:hover {\n    background-color: #CCC;\n}");
    $(document).on('focus', $element.selector, function() {
      var $textbox, offset;
      log('focus');
      $textbox = $($element.selector);
      log($element.length);
      $(document.body).after('<div id="library_select_div"></div>');
      offset = $textbox.offset();
      $('#library_select_div').css({
        'width': parseFloat($textbox.css('width').split('px')[0]),
        'top': offset['top'] + parseFloat($textbox.css('height').split('px')[0]),
        'left': offset['left']
      });
      return setTimeout(function() {
        return $textbox.select();
      }, 100);
    });
    $(document).on('blur', $element.selector, function() {
      log('blur');
      return $('#library_select_div').remove();
    });
    $(document).on('change keyup', $element.selector, function() {
      var keyword, params,
        _this = this;
      keyword = $($element.selector).val();
      log(keyword);
      if (keyword === '') {
        return;
      }
      params = {
        'type': 'search',
        'keyword': keyword
      };
      log(params);
      return get_api(params, function(data) {
        log(data);
        $('#library_select_div').empty();
        return $(data).each(function(i, lib) {
          return $('#library_select_div').append("<div id=\"" + lib.id + "\">" + lib.name + "</div>");
        });
      });
    });
    $(document).on('mousedown', '#library_select_div div', function() {
      return func($(this).attr('id'));
    });
    return this;
  };
})(jQuery);