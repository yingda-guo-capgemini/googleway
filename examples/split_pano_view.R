library(shiny)
library(shinydashboard)
library(DT)
library(googleway)

# Load Google api key
source("~/private/googlemap_api_key.R")
googleway::set_key(google_map_api_key)

ui <- fluidPage(

  fluidRow(box(width = 12,
                 google_mapOutput(outputId = "map"))),
  fluidRow(box(width = 12,
                 google_mapOutput(outputId = "pano"))),
  fluidRow(verbatimTextOutput("text1")),
  fluidRow(verbatimTextOutput("text2"))
  # fluidRow(box(width = 12, google_mapOutput(outputId = "map_old"))),
  # fluidRow(verbatimTextOutput("text3")),
  # fluidRow(verbatimTextOutput("text4"))
)

server <- function(input, output, session) {



  output$map <- renderGoogle_map({
    df <- data.frame(transformer_number = "AGM00002", lat = 44.56424, lon =  -80.94006)

    # google_map(location = c(44.564296, -80.939121), zoom = 16, split_view = "pano")%>%
    #   googleway::add_markers(data = df,lat = "lat", lon = "lon")

    google_map(data = df, location = c(44.564296, -80.939121), split_view = "pano")%>%
      googleway::add_markers(lat = "lat", lon = "lon")
  })

  output$map_old <- renderGoogle_map({
    df <- data.frame(transformer_number = "AGM00002", lat = 44.56424, lon =  -80.94006)

    # google_map(location = c(44.564296, -80.939121), zoom = 16, split_view = "pano")%>%
    #   googleway::add_markers(data = df,lat = "lat", lon = "lon")

    google_map(data = df, location = c(44.564296, -80.939121))%>%
      googleway::add_markers(lat = "lat", lon = "lon")
  })


  output$text1 <- renderText({
    paste0("StreetView lat :", input$map_pano_position_changed$lat, " lng:", input$map_pano_position_changed$lon)

  })

  output$text2 <- renderText({
    paste0("StreetView Angle heading :", input$map_pano_view_changed$heading, " pitch:", input$map_pano_view_changed$pitch)

  })

  output$text3 <- renderText({
    paste0("StreetView lat :", input$map_old_pano_position_changed$lat, " lng:", input$map_old_pano_position_changed$lon)
  })

  output$text4 <- renderText({
    paste0("StreetView Angle heading :", input$map_old_pano_view_changed$heading, " pitch:", input$map_old_pano_view_changed$pitch)

  })


} #server

#This allows the ui and server code to be in one file
shinyApp(ui, server)
