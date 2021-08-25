#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages
require(shiny)
require(dplyr)
require(leaflet)
require(plotly)
require(sf)

# Load Data
readRDS("support/osm_test.rds")-> df_ntp
readRDS("support/confirmed.rds")-> confirmed
readRDS("support/NTP_confirmed_data.rds")->  NTP_confirmed_data
case = colorspace::sequential_hcl(n=3, h =0 , c = c(200, 0), l = 30, rev = TRUE, power = 1.75)
grDevices::colorRamp(case) -> case_colorGenerator

NTP_confirmed_data$TOWNNAME %>% table() -> confirmed_by_city
confirmed_by_city %>% as.data.frame() -> cumulative_city
cumulative_city$. <- factor(cumulative_city$., levels = unique(cumulative_city$.)[order(cumulative_city$Freq, decreasing = F)])


table(NTP_confirmed_data$`發病日.從BO抓取.` ) %>% as.data.frame() -> dailyCases
dailyCases %>% mutate(
  Var1 = as.Date(Var1)
) -> dailyCases

# Define server logic required to draw a histogram
shinyServer(function(input, output){
  
    output$leafletPlot <- leaflet::renderLeaflet({
      
      if (input$region =="請選擇") {
        leaflet(confirmed)%>% 
          setView(
            lng = 121.5454, lat= 25.05, zoom = 11
          ) %>% addTiles() %>% 
          addMarkers(
            lng = ~lon,
            lat = ~lat,
            clusterOptions = markerClusterOptions())
      }else{
        leaflet(confirmed %>% filter(.,TOWNNAME==input$region ))%>% 
          setView(
            lng = 121.5454, lat= 25.05, zoom = 11
          ) %>% addTiles() %>% 
          addMarkers(
            lng = ~lon,
            lat = ~lat,
            clusterOptions = markerClusterOptions())
      } 
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
          )) %>% layout(
            font=list(
              family="Taipei Sans TC Beta",
              size=16
            ),
            paper_bgcolor='#cfd8dc',
            plot_bgcolor='#cfd8dc'
          )
    })
    
    output$plotHist <- plotly::renderPlotly({
      plot_ly(
        data = dailyCases,
        x = ~Var1 ,
        y = ~Freq,
        type = "bar",
        marker = list(color = ~Freq,
                      colors = grDevices::colorRamp(case),
                      line = list(color = I("white"),
                                  width = 0.5
                                 )
                      ),
        hoverlabel = list(
          bgcolor="orange",
          font=list(
            color="black",
            size=18
          ))
      ) %>% config(displayModeBar = F) %>% layout(
        title = list(text = "日發病量",y=0.97),
        xaxis = list(title = ""),
        yaxis = list(title = ""),
        font=list(
          family="Taipei Sans TC Beta",
          size=16
        ),
        paper_bgcolor='#cfd8dc',
        plot_bgcolor='#cfd8dc'
      )
    })
    
    output$Cumulative <- plotly::renderPlotly({
      plot_ly(
        data = cumulative_city,
        x = ~.,
        y = ~Freq,
        type = "bar",
        marker = list(color = ~Freq,
                      colors = grDevices::colorRamp(case),
                      line = list(color = 'rgb(8,48,107)',
                                  width = 1.5)),
        hoverlabel = list(
          bgcolor="orange",
          font=list(
            color="black",
            size=18
          ))
      ) %>% config(displayModeBar = F) %>%
        layout(
          title = list(text = "累積發病量(以地區分別)",y=0.97),
          xaxis = list(title = ""),
          yaxis = list(title = ""),
          font=list(
            family="Taipei Sans TC Beta",
            size=16
          ),
          paper_bgcolor='#cfd8dc',
          plot_bgcolor='#cfd8dc'
        )
    })
  
})


