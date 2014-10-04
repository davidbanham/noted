// Generated by CoffeeScript 1.8.0
(function() {
  var error, fetch, findOne, get, put, replace;

  window.srp = function() {
    var elem, text;
    elem = document.getElementById('content');
    text = elem.innerHTML;
    text = replace(text);
    elem.innerHTML = text;
    return save();
  };

  window.onload = function() {
    fetch(window.location.pathname.substring('1') || 'Directory');
    return document.getElementById('content').onclick = function(e) {
      if (e.target.pathname && e.target.innerText.substr(0, 4) !== 'http') {
        e.preventDefault();
        return fetch(e.target.pathname.substring(1));
      }
    };
  };

  fetch = function(name) {
    return get(name, function(res) {
      document.getElementById('content').innerHTML = res;
      document.getElementById('title').innerText = name;
      return history.pushState({
        name: name
      }, name, "/" + name);
    });
  };

  window.onpopstate = function(e) {
    return fetch(e.state.name);
  };

  window.load = function() {
    var name;
    name = document.getElementById('title').innerText;
    return fetch(name);
  };

  window.save = function() {
    var content, name;
    name = document.getElementById('title').innerText;
    content = document.getElementById('content').innerHTML;
    return put(name, content);
  };

  get = function(name, cb) {
    var req;
    req = new XMLHttpRequest();
    req.onload = function() {
      return cb(this.responseText);
    };
    req.open('GET', 'api/' + name, true);
    return req.send();
  };

  put = function(name, content) {
    var req;
    req = new XMLHttpRequest();
    req.onload = function() {
      if (req.status !== 200) {
        error(true);
      }
      if (req.status === 200) {
        return error(false);
      }
    };
    req.onerror = function() {
      return error(true);
    };
    req.open('PUT', 'api/' + name, true);
    req.setRequestHeader('Content-Type', 'text/html');
    return req.send(content);
  };

  error = function(state) {
    if (state) {
      return document.body.style.background = 'red';
    }
    return document.body.style.background = null;
  };

  findOne = function(text) {
    var from;
    from = text.indexOf('[[');
    if (from === -1) {
      return null;
    }
    return text.substring(from + 2, text.indexOf(']]'));
  };

  replace = function(text) {
    var target;
    target = findOne(text);
    if (!target) {
      return text;
    }
    text = text.replace(/\[\[/, "<a contenteditable=\"false\" href=\"" + target + "\">");
    text = text.replace(/\]\]/, '</a>');
    return replace(text);
  };

  document.addEventListener('keydown', function(e) {
    if (e.which === 27) {
      return e.target.blur();
    }
  });

}).call(this);
