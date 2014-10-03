// Generated by CoffeeScript 1.8.0
(function() {
  var fetch, findOne, get, put;

  window.srp = function() {
    var elem, target, text;
    elem = document.getElementById('content');
    text = elem.innerHTML;
    target = findOne(text);
    text = text.replace(/\[\[/g, "<a contenteditable=\"false\" href=\"" + target + "\">");
    text = text.replace(/\]\]/g, '</a>');
    return elem.innerHTML = text;
  };

  window.onload = function() {
    fetch('Directory');
    return document.getElementById('content').onclick = function(e) {
      if (e.target.pathname) {
        e.preventDefault();
        return fetch(e.target.pathname.substring(1));
      }
    };
  };

  fetch = function(name) {
    return get(name, function(res) {
      document.getElementById('content').innerHTML = res;
      return document.getElementById('title').innerText = name;
    });
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
    req.open('GET', name, true);
    return req.send();
  };

  put = function(name, content) {
    var req;
    req = new XMLHttpRequest();
    req.open('PUT', name, true);
    req.setRequestHeader('Content-Type', 'text/html');
    return req.send(content);
  };

  findOne = function(text) {
    return text.substring(text.indexOf('[[') + 2, text.indexOf(']]'));
  };

}).call(this);
