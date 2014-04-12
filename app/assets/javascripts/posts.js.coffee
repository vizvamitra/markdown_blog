# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
  $('pre code').each (i, e) ->
    hljs.highlightBlock(e)

$ ->
  $('#show_markdown_help').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#markdown_help').show()
    $('body').click ->
      $('#markdown_help').hide()
    $('#markdown_help').click (e) ->
      e.stopPropagation()
      e.preventDefault()