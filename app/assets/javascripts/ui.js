$(function () {
  $('#menuLink').click(function (e) {
    e.preventDefault();
    $('#layout, #menu, #menuLink').toggleClass('active');
  });
});
