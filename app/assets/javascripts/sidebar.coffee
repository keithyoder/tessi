jQuery ($) ->
  # Dropdown menu
  $('.sidebar-dropdown > a').click ->
    $('.sidebar-submenu').slideUp 200
    if $(this).parent().hasClass('active')
      $('.sidebar-dropdown').removeClass 'active'
      $(this).parent().removeClass 'active'
    else
      $('.sidebar-dropdown').removeClass 'active'
      $(this).next('.sidebar-submenu').slideDown 200
      $(this).parent().addClass 'active'
    return
  #toggle sidebar
  $('#toggle-sidebar').click ->
    $('.page-wrapper').toggleClass 'toggled'
    return
  # bind hover if pinned is initially enabled
  if $('.page-wrapper').hasClass('pinned')
    $('#sidebar').hover (->
      console.log 'mouseenter'
      $('.page-wrapper').addClass 'sidebar-hovered'
      return
    ), ->
      console.log 'mouseout'
      $('.page-wrapper').removeClass 'sidebar-hovered'
      return
  #Pin sidebar
  $('#pin-sidebar').click ->
    if $('.page-wrapper').hasClass('pinned')
      # unpin sidebar when hovered
      $('.page-wrapper').removeClass 'pinned'
      $('#sidebar').unbind 'hover'
    else
      $('.page-wrapper').addClass 'pinned'
      $('#sidebar').hover (->
        console.log 'mouseenter'
        $('.page-wrapper').addClass 'sidebar-hovered'
        return
      ), ->
        console.log 'mouseout'
        $('.page-wrapper').removeClass 'sidebar-hovered'
        return
    return
  #toggle sidebar overlay
  $('#overlay').click ->
    $('.page-wrapper').toggleClass 'toggled'
    return
  #switch between themes
  themes = 'default-theme legacy-theme chiller-theme ice-theme cool-theme light-theme'
  $('[data-theme]').click ->
    $('[data-theme]').removeClass 'selected'
    $(this).addClass 'selected'
    $('.page-wrapper').removeClass themes
    $('.page-wrapper').addClass $(this).attr('data-theme')
    return
  # switch between background images
  bgs = 'bg1 bg2 bg3 bg4'
  $('[data-bg]').click ->
    $('[data-bg]').removeClass 'selected'
    $(this).addClass 'selected'
    $('.page-wrapper').removeClass bgs
    $('.page-wrapper').addClass $(this).attr('data-bg')
    return
  # toggle background image
  $('#toggle-bg').change (e) ->
    e.preventDefault()
    $('.page-wrapper').toggleClass 'sidebar-bg'
    return
  # toggle border radius
  $('#toggle-border-radius').change (e) ->
    e.preventDefault()
    $('.page-wrapper').toggleClass 'boder-radius-on'
    return
  #custom scroll bar is only used on desktop
  if !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    $('.sidebar-content').mCustomScrollbar
      axis: 'y'
      autoHideScrollbar: true
      scrollInertia: 300
    $('.sidebar-content').addClass 'desktop'
  return

# ---
# generated by js2coffee 2.2.0
