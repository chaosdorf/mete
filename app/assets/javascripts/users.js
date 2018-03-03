var allowedHashFilter = '0abcdefghijklmnopqrstuvwxyz';
function hashchange() {
  var filterChar = location.hash.charAt(1);
  if (!filterChar) {
    filterChar = allowedHashFilter.charAt(Math.floor(Math.random() * allowedHashFilter.length));
  }
  var filter = '.user:not(.' + filterChar + ')';
  $('.user').show();
  $(filter).hide();
}

$(window).on('hashchange', hashchange);
hashchange();
