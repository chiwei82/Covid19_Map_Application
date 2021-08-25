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
Cumulative <- plotly::plotlyOutput("Cumulative",width="100%",height="600px")

ui <- material_page(
  title = "Covid-19 Dashboard",
  nav_bar_fixed = F,
  nav_bar_color = "orange darken-3",
  font_color = "black",
  background_color="blue-grey lighten-4",
  # Place side-nav in the beginning of the UI
  material_side_nav(
    fixed = T,
    # Place side-nav tabs within side-nav
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Location (Quarantined)" = "side_nav_tab_1",
        "Choropleth (Quarantined)" = "side_nav_tab_2",
        "Cumulative (Sorted by city)" = "side_nav_tab_4",
        "Timeseries" = "side_nav_tab_3"
      ),
      icons = c("map", "insert_chart","show_chart","location_city")
    )
  ),
  # Define side-nav tab content
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_1",
    tags$table(
      tags$thead(
        tags$tr(
          tags$th("地區"),
          tags$th("類別"),
          tags$th("數量")
        )
      ),
      tags$tbody(
        tags$tr(
          tags$td(tags$div(class="chip",tags$div(class="chip",selectInput(
            "region",
            "選擇一個地區",
            c("請選擇","淡水區","三芝區","石門區","金山區","萬里區","汐止區","深坑區"
              ,"瑞芳區","平溪區","雙溪區","石碇區","貢寮區","新店區","中和區"
              ,"板橋區","永和區","土城區","烏來區","樹林區","三峽區","三重區"
              ,"蘆洲區","五股區","八里區","新莊區","林口區","泰山區","鶯歌區"
              ,"坪林區"
            )
          )))),
          tags$td(tags$div(class="chip",tags$div(class="chip","未解除隔離患者"))),
          tags$td("1935位 (僅包含地址填寫正確之數量)"
                  )
        )
      )
    ),
    leaflet
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_2",
    tags$table(
      tags$thead(
        tags$tr(
          tags$th("地區"),
          tags$th("類別"),
          tags$th("數量")
        )
      ),
      tags$tbody(
        tags$tr(
          tags$td(tags$div(class="chip",tags$div(class="chip","新北市"))),
          tags$td(tags$div(class="chip",tags$div(class="chip","未解除隔離患者"))),
          tags$td("1935位 (僅包含地址填寫正確之數量)")
        )
      )
    ),
    tags$div(class="container",
    choropleth)
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_3",
    tags$table(
      tags$thead(
        tags$tr(
          tags$th("地區"),
          tags$th("類別"),
          tags$th("數量")
        )
      ),
      tags$tbody(
        tags$tr(
          tags$td(tags$div(class="chip",tags$div(class="chip","新北市"))),
          tags$td(tags$div(class="chip",tags$div(class="chip","累積發病患者"))),
          tags$td("6315位")
        )
      )
    ),
    histplot
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "side_nav_tab_4",
    tags$table(
      tags$thead(
        tags$tr(
          tags$th("地區"),
          tags$th("類別"),
          tags$th("數量")
        )
      ),
      tags$tbody(
        tags$tr(
          tags$td(tags$div(class="chip",tags$div(class="chip","新北市"))),
          tags$td(tags$div(class="chip",tags$div(class="chip","累積發病患者"))),
          tags$td("6315位")
        )
      )
    ),
    Cumulative
  )
)


# Define UI for application that draws a histogram
shinyUI(ui)
