class ListEventsScreen < PM::TableScreen
  title "Upcoming Events"
  stylesheet ListEventsScreenStylesheet

  def on_load
    @events = []
    load_events
  end

  def load_events
    Motion::Blitz.loading # display a loading spinner

    AFMotion::JSON.get("http://calagator.org/events.json") do |response|
      if response.success?
        @events = response.object
        update_table_data
      else
        app.alert "Sorry, there was an error while trying to load the events."
        mp response.object
        mp response.error.localizedDescription
      end
      Motion::Blitz.dismiss # dismiss the loading spinner
    end
  end

  def table_data
    [{
      cells: @events.map do |event|
        mp event
        { title: event["title"] }
      end
    }]
  end


  # You don't have to reapply styles to all UIViews, if you want to optimize, another way to do it
  # is tag the views you need to restyle in your stylesheet, then only reapply the tagged views, like so:
  #   def logo(st)
  #     st.frame = {t: 10, w: 200, h: 96}
  #     st.centered = :horizontal
  #     st.image = image.resource('logo')
  #     st.tag(:reapply_style)
  #   end
  #
  # Then in will_animate_rotate
  #   find(:reapply_style).reapply_styles#

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
