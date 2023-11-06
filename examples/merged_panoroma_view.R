library(shiny)
library(googleway)

# Load Google api key
source("~/private/googlemap_api_key.R")
googleway::set_key(google_map_api_key)

ui <- fluidPage(

  fluidRow(verbatimTextOutput("text3")),
  fluidRow(google_mapOutput(outputId = "map_old")),
  fluidRow(verbatimTextOutput("text4"))
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


  output$text3 <- renderText({
    paste0("StreetView lat :", input$map_old_pano_position_changed$lat, " lng:", input$map_old_pano_position_changed$lon, "  image_taken_date: ", input$map_old_pano_image_date)
  })

  output$text4 <- renderText({
    paste0("StreetView Angle heading :", input$map_old_pano_view_changed$heading, " pitch:", input$map_old_pano_view_changed$pitch)

  })


} #server

#This allows the ui and server code to be in one file
shinyApp(ui, server)
