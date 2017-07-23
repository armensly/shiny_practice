
library(shiny)
library(leaflet)

shinyUI(
        bootstrapPage(
                
                # Application title
                #titlePanel("US Higher Education Institutes"),
                tabsetPanel(id = "tab_selection",
                            tabPanel("Select by school name", value = "by_school",
                                     titlePanel("Selection by School Name:"),
                                     sidebarLayout(
                                             sidebarPanel(
                                                     selectInput("selection_school", "Select schools:", choices = c(), selectize = FALSE)
                                             ),
                                             
                                             # Show a plot of the generated distribution
                                             mainPanel(
                                                     leafletOutput("map_schools")
                                             )
                                     )
                            ),
                            
                            tabPanel("Select by program name", value = "by_program",
                                     titlePanel("Selection by Program:"),
                                     sidebarLayout(
                                             sidebarPanel(
                                                     selectInput("selection_program", "Select Programs:", choices = c(), selectize = FALSE)
                                             ),
                                             
                                             # Show a plot of the generated distribution
                                             mainPanel(
                                                     leafletOutput("map_programs")
                                             )
                                     )
                            ),
                            tabPanel("Select by program (clustered view)", value = "by_program_clustered",
                                     titlePanel("Selection by Program:"),
                                     sidebarLayout(
                                             sidebarPanel(
                                                     selectInput("selection_program_clustered", "Select Programs:", choices = c(), selectize = FALSE)
                                             ),
                                             
                                             # Show a plot of the generated distribution
                                             mainPanel(
                                                     leafletOutput("map_programs_clustered")
                                             )
                                     )
                            )
                )
        )
)
