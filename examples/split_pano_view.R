library(shiny)
library(googleway)

# Load Google api key
source("~/private/googlemap_api_key.R")
googleway::set_key(google_map_api_key)

ui <- fluidPage(

  # Copy the chunk below to make a group of checkboxes
  radioButtons("radio", label = h3("Map Click Operation"),
                     choices = list("None" = 1, "Add a Marker" = 2, "Remove a Marker" = 3),
                     selected = 1),

  fluidRow(width = 12,
                 google_mapOutput(outputId = "map")),
  fluidRow(width = 12,
                 google_mapOutput(outputId = "pano")),
  fluidRow(verbatimTextOutput("text1")),
  fluidRow(verbatimTextOutput("text2")),
  fluidRow(verbatimTextOutput("text3"))

)

server <- function(input, output, session) {

  output$map <- renderGoogle_map({
    df <- data.frame(transformer_number = "AGM00002", lat = 44.56424, lon =  -80.94006)

    # google_map(location = c(44.564296, -80.939121), zoom = 16, split_view = "pano")%>%
    #   googleway::add_markers(data = df,lat = "lat", lon = "lon")

    google_map(data = df, location = c(44.564296, -80.939121), split_view = "pano")%>%
      googleway::add_markers(lat = "lat", lon = "lon", split_view = "pano", draggable = T, layer_id = "layer1")
  })



  output$text1 <- renderText({
    paste0("StreetView lat :", input$map_pano_position_changed$lat, " lng:", input$map_pano_position_changed$lon, "  image_taken_date: ", input$map_pano_image_date)

  })

  output$text2 <- renderText({
    paste0("StreetView Angle heading :", input$map_pano_view_changed$heading, " pitch:", input$map_pano_view_changed$pitch)

  })

  output$text3 <- renderText({
     paste0("Drag Marker lat :", input$map_marker_drag$lat, " lng:", input$map_marker_drag$lon)

  })

  # Remove a marker
  observeEvent(input$map_marker_click, {
    if(input$radio == 3){
      googleway::google_map_update("map") %>%
        clear_markers(layer_id = input$map_marker_click$layerId)
    }
  })

  # Add a marker when click on the map
  observeEvent(input$map_map_click,{
    if(input$radio == 2){
      df <- data.frame(lat = input$map_map_click$lat, lon = input$map_map_click$lon)
      googleway::google_map_update("map") %>%
        googleway::add_markers(data = df, lat = "lat", lon = "lon", split_view = "pano", draggable = T, layer_id = paste0("layerid", sample.int(1000, 1)))
    }
  })



} #server

#This allows the ui and server code to be in one file
shinyApp(ui, server)
