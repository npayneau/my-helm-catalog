class Dashing.Image extends Dashing.Widget

  ready: ->
    # Init

  onData: (data) ->
    node = $(@node)
    status = node.find("img").parent().parent().parent()
    # Define color regarding buid status
    if data.status == 'open'
      status.removeClass("dead-status")
    else if data.status == 'dead'
      status.addClass("dead-status")