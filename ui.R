library(shiny) 
library(dplyr)
library(plotly)
library(ggplot2)
library(maps)
library(ggplot2)
library(mapproj)
library(RColorBrewer)
library(devtools)
library(shinythemes)
library(shinyWidgets)



navbarPage(
  theme = shinytheme("cerulean"),
  #==================the first page============================
  "shiny project",
  tabPanel(
    "Problem Statement",
    tabsetPanel(
      tabPanel(
        h4('Topic'),
        br(),
        h1('Is Air Pollution Preventing Skin Cancer?', align='center'),
        br(),
        HTML('<center><img src="https://familydoctor.org/wp-content/uploads/1994/05/shutterstock_390423625-1-705x452.jpg"></center>')
      ),
      tabPanel(
        h4('Background'),
        HTML('<center><img src="https://cdn.zmescience.com/wp-content/uploads/2016/04/layersofozone_1.jpeg"></center>')
      ),
      tabPanel(
        h4('Work Flow'),
        h3('Data:'),
        h4('Air quality index (AQI) of US counties (2002-2014) from United State Environmental Protectin Agency;'),
        h4('Ultraviolet Index (UV) of US major cities (2002-2014) from enigma.com;'),
        h4('US City-County data from simplemaps.com;'),
        h4('Built-in county data'),
        br(),
        h3('Tools'),
        h4('R Shiny, ggplot2, dplyr, plotly'),
        br(),
        h3('Procedures'),
        h4('Data Cleaning -> Data Analysis -> Data visualization in Shiny')
        
        
      )
    )
   

  ),
  #==================the second page==============================
  tabPanel("Data Visulization",
           fluidPage(
             #sidebarLayout(
             fluidRow(
               column(
                 3,
                 wellPanel(
                   selectizeInput(inputId = "year",
                                  label = h4("Select Year:"),
                                  #the unique function making a list of unique electable function
                                  choices = unique(aqi$year)),
                   sliderInput(inputId = "month",
                               label = h4("Select Month:"),
                               min=1,max=12,value=1),
                   radioButtons(inputId="radio", 
                                label = h4("Show UV?"),
                                choices = c("No", "Yes")),
                   selectizeInput(inputId = "city",
                                  label = h4("Select City:"),
                                  #the unique function making a list of unique electable function
                                  choices = unique(uv$city))
                  
                 ),
                 
                 wellPanel(
                   h4("Index"),
                   span("The Air Quality Index is:",
                        textOutput("AQI")
                   ),
                   span("The Ultraviolet Index is:",
                        textOutput("UV") 
                   )
                 )
                  
               ),
               column(
                 9,
                 tabsetPanel(
                   tabPanel(h4("National Map"),
                            plotOutput("month_average_aqi")


                   ),
                   tabPanel(h4("Yearly Change"),
                            h1('year'),
                            fluidRow(
                              column(6,plotlyOutput("year_distribution_aqi")),
                              column(6,plotlyOutput("year_distribution_uv"))
                            )
                        
                   ),
                   tabPanel(h4("Monthly Change"),
                            h1('month'),
                            fluidRow(
                              column(6,plotlyOutput("month_distribution_aqi")),
                              column(6,plotlyOutput("month_distribution_uv"))
                            )
                                 
                            
                   )
              
               )
             )
               #sidebarPanel(,
                           # width = 2
                            
                            
               #),
              # mainPanel(
                 
              #   )
           
                 #fluidRow(
                  #column(5,plotOutput("monthly_average")),
                  #column(5,plotOutput("another_monthly_average"))
                 #)
               #)
             )
           )
 
  ),
  #==================the third page============================
  tabPanel('Data Analysis',
           fluidPage(
             fluidRow(
               column(
                 3,
                 wellPanel(
                   pickerInput(
                     inputId = "City", 
                     label = h4("Select Cities:"), 
                     choices = c(unique(uv$city)), 
                     options = list(`actions-box` = TRUE), 
                     multiple = TRUE
                   )
                 )
               ),
               column(
                 9,
                 fluidRow(
                   column(5,
                          h3('Selected Cities'),
                          plotOutput('selected_city')),
                   column(7,
                          h3('Linear Regression'),
                          plotOutput('linearR'))
                 )
               )
               
               
             )
          #   sidebarLayout(
           #    sidebarPanel(
            #     pickerInput(
          #         inputId = "City", 
          #         label = "Cities", 
          #         choices = c(unique(uv$city)), 
          #         options = list(`actions-box` = TRUE), 
           #        multiple = TRUE
           #      )
           #    ),
            #   mainPanel(
            #     fluidRow(
           #        column(5,plotOutput('selected_city')),
            #       column(7,plotOutput('linearR'))
            #     )
                 #plotOutput('selected_city'),
                 #plotOutput('linearR')
            #   )
            # )
          )

      
   
    
    
  )
  
)
        


