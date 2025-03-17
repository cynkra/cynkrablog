library(leaflet)
library(dplyr)

uiOutputBlock.leaflet_block <- function(x, ns) {
  leaflet::leafletOutput(ns("plot"))
}

server_output.leaflet_block <- function(x, result, output) {
  leaflet::renderLeaflet(result())
}

generate_server.leaflet_block <- blockr:::generate_server.plot_block

new_gpx_block <- function(...) {

  new_parser_block(
    quote({
      tmp <- gpx::read_gpx(data)
      route <- tmp$routes[[1]] %>% tibble::rowid_to_column()
    # prepare start/end coordinates
    waypoints <- tmp$waypoints
    start <- tmp$waypoints[1, ]
    end <- tmp$waypoints[2, ]

    start_idx <- route %>% 
      filter(Latitude == start$Latitude & Longitude == start$Longitude) %>%
      pull(rowid)

    end_idx <- route %>% 
      filter(Latitude == end$Latitude & Longitude == end$Longitude) %>%
      pull(rowid)

    attr(route, "start") <- start_idx
    attr(route, "end") <- end_idx
    route
    }),
    ...,
    class = "gpx_block"
  )
}

new_readrcsv_block <- function(...) {
  new_parser_block(quote(readr::read_csv()), ..., class = "csv_block")
}

new_leaflet_block <- function(...) {

  new_block(
    fields = list(),
    expr = quote({

      # extract start/end coordinates
      data_start <- data[attr(data, "start"), ]
      data_end <- data[attr(data, "end"), ]

      leaflet(data) %>%
    addTiles(
        urlTemplate = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
        attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
        options = tileOptions(
            subdomains = "abcd",
	        maxZoom = 20
        )
    ) %>%
    addPolylines(lat = ~Latitude, lng = ~Longitude, color = "#000000", opacity = 0.8, weight = 3) %>%
    addCircleMarkers(data = data_start, lat = ~Latitude, lng = ~Longitude, color = "#3eaf15", opacity = 0.8, weight = 5, radius = 10, label = "Start of race") %>%
    addCircleMarkers(data = data_end, lat = ~Latitude, lng = ~Longitude, color = "#e73939", opacity = 0.8, weight = 5, radius = 10, label = "End of race") %>%
    addMarkers(
        lng = 8.64389380440116,
        lat = 47.5413932128899,
        icon = list(
            iconUrl = "https://www.vanuatubeachbar.com/wp-content/uploads/leaflet-maps-marker-icons/mountains.png",
            iconWidth = 32,
            iconHeight = 37,
            iconAnchorX = 0,
            iconAnchorY = 0
        ),
        label = "Buch am Irchel: 4.83km at 4.2% **"
    ) %>%
    addMarkers(
        lng = 8.743660245090725,
        lat = 47.45665840019784,
        icon = list(
            iconUrl = "https://www.vanuatubeachbar.com/wp-content/uploads/leaflet-maps-marker-icons/mountains.png",
            iconWidth = 32,
            iconHeight = 37,
            iconAnchorX = 0,
            iconAnchorY = 0
        ),
        label = "Kyburg: 1.28km at 10.3% ****"
    ) %>%
    addMarkers(
        lng = 8.624014738015832,
        lat = 47.351512429613024,
        icon = list(
            iconUrl = "https://www.vanuatubeachbar.com/wp-content/uploads/leaflet-maps-marker-icons/mountains.png",
            iconWidth = 32,
            iconHeight = 37,
            iconAnchorX = 0,
            iconAnchorY = 0
        ),
        label = "Maur-Binz: 3.7km at 4.4% **"
    ) %>%
    addMarkers(
        lng = 8.607488349080088,
        lat = 47.36219723777833,
        icon = list(
            iconUrl = "https://www.vanuatubeachbar.com/wp-content/uploads/leaflet-maps-marker-icons/mountains.png",
            iconWidth = 32,
            iconHeight = 37,
            iconAnchorX = 0,
            iconAnchorY = 0
        ),
        label = "ZurichbergStrasse/Witikon: 2.63km at 5.3% **"
    ) %>%
    htmlwidgets::onRender(
      "function(x, el, data) {
        var map = this;
        map.on('click', function(e) {
        var coord = e.latlng;
        var lat = coord.lat;
        var lng = coord.lng;
        console.log('You clicked the map at latitude: ' + lat + ' and       longitude: ' + lng);
        });
      }"  
    )
    }),
    ...,
    class = c("leaflet_block", "map_block")
  )
}

stack <- new_stack(
  data = new_filesbrowser_block(file_path = "/Users/davidgranjon/david/Cynkra/cynkrablog/posts/2024-09-09-zurich-roadcycling-wc-2024/GPX-22-Winterthur-Zurich-1.gpx"),
  parser = new_gpx_block,
  map = new_leaflet_block
)

serve_stack(stack)