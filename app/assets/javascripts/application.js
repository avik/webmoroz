// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.cookie
//= require jquery_ujs
//= require bootstrap-tour
//= require bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
// require_tree .
//= require dashboard
//= require_self

$.getScript('http://vk.com/js/api/openapi.js?105');

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ru_RU/all.js#xfbml=1&appId=553281794754505";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

window.fbAsyncInit = function() {
  FB.init({
    appId      : '553281794754505', // App ID
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });
  FB.Event.subscribe('edge.create', function(param) {
    $.getJSON("/users/mark_increase_social", {social: 'fb'}, function( mark ) {
      if (mark) $("#num_mark").html(mark);
    });
  });
  VK.init({apiId: 3965772, onlyWidgets: true});
  VK.Widgets.Like("vk_like", {type: "button", height: 24});
  VK.Widgets.Comments("vk_comments", {limit: 15, width: "738", attach: "*"});
  VK.Widgets.Group("vk_groups", {mode: 2, wide: 1, width: "718", height: "400"}, 61591348);
  VK.Observer.subscribe('widgets.like.shared', function(param) {
    $.getJSON("/users/mark_increase_social", {social: 'vk'}, function( mark ) {
      if (mark) $("#num_mark").html(mark);
    });
  });
};

$(function() {
  $(document).ready(function(){
    $('[data-behaviour~=datepicker]').datepicker({
      startView: 2,
      format: "dd.mm.yyyy",
      language: "ru",
      autoclose: true
    });
    $('.carousel').carousel({
      interval: 6000
    })
    $('.popover_hover').popover(
      { trigger: "hover" }
    );
    $('.tooltip-hover').tooltip(
    );
    $('#info_tab a').click(function (e) {
      e.preventDefault();
      $(this).tab('show');
    })
  })
});

