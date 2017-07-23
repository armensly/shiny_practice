#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

#setwd("~/coursera/coursera_developing_data_products/week3_pa/")
#nces_schools <- read.csv("../week2_pa/data/nces/hd2015.csv", fileEncoding = "CP1252", stringsAsFactors = FALSE)
#nces_schools$LONGITUD <- as.numeric(nces_schools$LONGITUD)
#nces_schools$LATITUDE <- as.numeric(nces_schools$LATITUDE)
#nces_schools[458, "LONGITUD"] <- -121.925678
#nces_schools[458, "LATITUDE"] <- 37.477779
#nces_schools <- subset(nces_schools, select = c("INSTNM", "LATITUDE", "LONGITUD", "UNITID"))
#colnames(nces_schools)[which(colnames(nces_schools) == "LATITUDE")] <- "lat"
#colnames(nces_schools)[which(colnames(nces_schools) == "LONGITUD")] <- "lng"
#nces_programs <- read.csv("../week2_pa/data/nces/c2015_a.csv", stringsAsFactors = FALSE)
#nces_programs <- nces_programs[nces_programs$CIPCODE != 99, c("UNITID", "CIPCODE")]
#nces_cip_codes <- read.csv("../week2_pa/data/nces/CIPCode2010.csv", stringsAsFactors = FALSE)
#nces_cip_codes <- subset(nces_cip_codes, select = c("CIPCode", "CIPTitle"))
#nces_cip_codes$CIPCode <- as.numeric(substr(nces_cip_codes$CIPCode, 2, nchar(nces_cip_codes$CIPCode)))
#nces_programs_cip_expanded <- merge(nces_programs, nces_cip_codes, by.x = c("CIPCODE"), by.y = c("CIPCode"))
#nces_programs_school_expanded <- merge(nces_programs_cip_expanded, nces_schools, by = c("UNITID"))
#nces_programs_school_expanded$UNITID <- NULL
#rm(nces_programs_cip_expanded, nces_programs, nces_cip_codes)
#dim(nces_programs_school_expanded)
#dim(nces_schools)
#nces_schools <- nces_schools[order(nces_schools$INSTNM),]
#write.csv(nces_schools, "final_schools.csv", row.names = F)
#write.csv(nces_programs_school_expanded, "final_progrrams.csv", row.names = F)
nces_schools <- read.csv("final_schools.csv")
#nces_programs_school_expanded <- read.csv("final_programs.csv")
#nces_programs_school_expanded <- nces_programs_school_expanded[(nces_programs_school_expanded$CIPCODE <12 & nces_programs_school_expanded$CIPCODE >= 11) | nces_programs_school_expanded$CIPCODE == 26.1103 | nces_programs_school_expanded$CIPCODE == 51.2706,]
#write.csv(nces_programs_school_expanded, "final_computer_programs.csv", row.names = FALSE)
nces_programs_school_expanded <- read.csv("final_computer_programs.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
        filtered_schools <- reactive({
                subset(nces_schools, INSTNM == input$selection_school)
        })
        filtered_programs <- reactive({
                subset(nces_programs_school_expanded, CIPTitle == input$selection_program)
        })
        output$map_schools <- renderLeaflet(
                leaflet() %>% addTiles(), # %>% addMarkers() %>% fitBounds(min_lng, min_lat, max_lng, max_lat),#,
                updateSelectInput(session, "selection_school", choices = nces_schools$INSTNM, selected = nces_schools$INSTNM[1])
                #updateSelectInput(session, "selection_program", choices = schools, selected = schools[1])
        )
        output$map_programs <- renderLeaflet(
                leaflet() %>% addTiles(), # %>% addMarkers() %>% fitBounds(min_lng, min_lat, max_lng, max_lat),#,
                #updateSelectInput(session, "selection_school", choices = schools, selected = schools[1]),
                updateSelectInput(session, "selection_program", choices = nces_programs_school_expanded$CIPTitle, selected = nces_programs_school_expanded$CIPTitle[1])
        )
        output$map_programs_clustered <- renderLeaflet(
                leaflet() %>% addTiles(), # %>% addMarkers() %>% fitBounds(min_lng, min_lat, max_lng, max_lat),#,
                #updateSelectInput(session, "selection_school", choices = schools, selected = schools[1]),
                updateSelectInput(session, "selection_program_clustered", choices = nces_programs_school_expanded$CIPTitle, selected = nces_programs_school_expanded$CIPTitle[1])
        )
        observe({
                #print(dim(filtered_schools()))
                if (input$tab_selection == "by_school") {
                        #str(filtered_schools())
                        leafletProxy(mapId = "map_schools", data = filtered_schools()) %>% clearMarkers() %>% addMarkers(popup = filtered_schools()$INSTNM) %>% setView(-85.832237, 38.918846, 2)
                } else if (input$tab_selection == "by_program") {
                        #str(filtered_programs())
                        leafletProxy(mapId = "map_programs", data = filtered_programs()) %>% clearMarkers() %>% addCircleMarkers(popup = filtered_programs()$INSTNM, fillOpacity = 0.2, weight = 1, radius = 2) %>% setView(-85.832237, 38.918846, 2)        
                } else {
                        leafletProxy(mapId = "map_programs_clustered", data = filtered_programs()) %>% clearMarkers() %>% addCircleMarkers(popup = filtered_programs()$INSTNM, clusterOptions = markerClusterOptions(), weight = 1) %>% setView(-85.832237, 38.918846, 2)        
                }
        })
})
