#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages
library(shiny)
library(dplyr)
library(leaflet)
library(plotly)

# Load Data
readRDS("support/osm_test.rds")-> df_ntp
readRDS("support/confirmed.rds")-> confirmed
readRDS("support/NTP_confirmed_data.rds")->  NTP_confirmed_data
case = colorspace::sequential_hcl(n=3, h =0 , c = c(200, 0), l = 30, rev = TRUE, power = 1.75)
grDevices::colorRamp(case) -> case_colorGenerator

# Define server logic required to draw a histogram
shinyServer(function(input, output){
  
    output$leafletPlot <- leaflet::renderLeaflet({
      leaflet(confirmed) %>% 
        setView(
          lng = 121.5454, lat= 24.9928, zoom = 10.3
        ) %>% addTiles() %>% 
        addMarkers(
          lng = ~lon,
          lat = ~lat,
          clusterOptions = markerClusterOptions())
      
      })
    
    output$plotlyPlot <- plotly::renderPlotly({
      plotly::plot_ly() %>%
        plotly::add_sf(
            data = df_ntp ,
            type= "scatter",
            split= ~name.en,
            showlegend=F,
            hoverinfo="text",
            text= ~name_and_case_number,
            hoveron = "fills",
            stroke=I("gray"),
            color = ~Range, 
            colors = grDevices::colorRamp(case),
            hoverlabel = list(
              bgcolor="orange",
              font=list(
                color="black",
                size=15
                )
          ))
    })
    
    output$plotHist <- plotly::renderPlotly({
      plot_ly(
        data = NTP_confirmed_data,
        x = ~發病日.從BO抓取. ,
        type = "histogram",
        stroke = I("white")
      ) %>% config(displayModeBar = F)
    })
  
})


