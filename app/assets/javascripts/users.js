// filter users by initial
// only do this if we have many users
if ($('.user').length >= 50) {
  var allowedHashFilter = '0abcdefghijklmnopqrstuvwxyz';
  function hashchange() {
    var filterChar = location.hash.charAt(1);
    if (!filterChar) {
      filterChar = allowedHashFilter.charAt(Math.floor(Math.random() * allowedHashFilter.length));
    }
    var filter = '.user:not(.user-' + filterChar + ')';
    $('.user').show();
    $(filter).hide();
    
    // set the design for all buttons
    for (var i = 0; i < allowedHashFilter.length; i++) {
      var char = allowedHashFilter.charAt(i);
      $('.user-filter-' + char).removeClass('btn-primary btn-secondary disabled');
      if (filterChar === char) {
        $('.user-filter-' + char).addClass('btn-primary');
      } else {
        $('.user-filter-' + char).addClass('btn-secondary');
      }
      if ($('.user-' + char).length === 0) {
        $('.user-filter-' + char).addClass('disabled');
      }
    }
  }

  $(window).on('hashchange', hashchange);
  hashchange();
} else {
  $('.user').show();
  $('.user-filter').hide();
}
