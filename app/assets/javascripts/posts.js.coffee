# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  # Highlight
  $('pre code').each (i, e) ->
    hljs.highlightBlock(e)

  # Text from textarea to div
  $('#post_body_div').text($('#post_body').val())

  # Focus on post body area
  if ($('.post_form'))
    $('#post_body_div').focus()

  # Keybord events
  $('#post_body_div').keydown (e) ->
    # Newline at 'Enter' press
    if e.which == 13 # Enter
      e.preventDefault()
      if $(this).text().slice(-1) != '\n'
        $(this).append('\n')
      $(this).paste_in_position('\n')
    # Four whitespaces at 'Enter' press
    if e.keyCode == 9 # Tab
      e.preventDefault()
      $(this).paste_in_position('    ')
    # Submit post form on ctrl+s
    if e.ctrlKey && e.which == 83 # Ctrl+s
      e.preventDefault()
      $('.post_form input[type=submit]').trigger('click')

  # Form submition
  $('.post_form input[type=submit]').click (e) ->
    e.stopPropagation()
    e.preventDefault()
    form = $('.post_form')
    body = form.find('#post_body_div').text().replace(/&nbsp; /g, ' ')
    if body == ''
      form.find('#error').html('<h4>Но вы же ничего не написали!</h4>')
    else if form.find('#post_title').val() == ''
      form.find('#error').html('<h4>Посту нужно название!</h4>')
    else
      form.find('#post_body').val(body)
      form.submit()
  
  # Showing/hiding markdown help div
  $('#show_markdown_help').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#markdown_help').show()
    $('body').click ->
      $('#markdown_help').hide()
    $('#markdown_help').click (e) ->
      e.stopPropagation()
      e.preventDefault()

$.fn.paste_in_position = (text_to_paste) ->
  if (window.getSelection)
    selection = window.getSelection()
    range = selection.getRangeAt(0)
    br = document.createTextNode(text_to_paste)
    range.deleteContents();
    range.insertNode(br);
    range.setStartAfter(br);
    range.setEndAfter(br);
    range.collapse(false);
    selection.removeAllRanges();
    selection.addRange(range);