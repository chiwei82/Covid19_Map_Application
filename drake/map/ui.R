#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinymaterial)

leaflet <- leaflet::leafletOutput("leafletPlot",width="100%", height="600px")
choropleth <- plotly::plotlyOutput("plotlyPlot",width="100%",height="600px")
histplot <- plotly::plotlyOutput("plotHist",width="100%",height="600px")

ui <- material_page(
  title = "Covid-19 Dashboard",
  nav_bar_fixed = TRUE,
  nav_bar_color = "orange darken-3",
  font_color = "black",
  background_color="orange lighten-5",
  # Place side-nav in the beginning of the UI
  material_side_nav(
    fixed = TRUE,
    # Place side-nav tabs within side-nav
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Location" = "side_nav_tab_1",
        "Choropleth" = "side_nav_tab_2",
        "Timeseries" = "side_nav_tab_3"
      ),
      icons = c("map", "insert_chart","show_chart")
    )
  ),
  # Define side-nav tab content
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_1",
    leaflet
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_2",
    choropleth
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_3",
    histplot
  )
)


# Define UI for application that draws a histogram
shinyUI(ui)
