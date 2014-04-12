# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
  $('#comment_form input[type=submit]').click (e) ->
    e.stopPropagation()
    e.preventDefault()
    form = $('#new_comment')
    if form.find('#comment_author').val() == ''
      form.find('#error').html('Представтесь пожалуйста')
    else if form.find('#comment_body').val() == ''
      form.find('#error').html('Вы забыли написать текст комментария')
    else
      form.submit()