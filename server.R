library(shiny) 
library(dplyr)
library(plotly)
library(ggplot2)
library(maps)
library(ggplot2)
library(mapproj)
library(RColorBrewer)
library(devtools)


function(input, output) {
  
  #this manipulation happens in the data frame, hence the data frame column names are used instead of input output names
  #observe({
  #  county.Name = unique(aqi[year == input$year, county.Name])
  #  updateSelectizeInput(
  #    session, "county.Name",
  #    choices = county.Name,
  #    selected = county.Name[1]
  #  )
  #})

#========================================reactive functions========================  
  aqi_reac = reactive({
    aqi %>%
      filter(year==input$year &  month == input$month) %>%
      right_join(county_df, by='group')
  })
  
  uv_reac = reactive({
    uv %>%
      filter(year==input$year &  month == input$month)
  })
  
  
  uv_reac_selected = reactive({
    uv %>%
      filter(year==input$year &  month == input$month & city == input$city)
  })
  
  year = reactive({
    uv %>%
      filter(year==input$year & city == input$city)
  })
  
  month = reactive({
    uv %>%
      filter(month==input$month & city == input$city)
  })
  
  city_lm = reactive({
    uv %>%
      filter(city %in% input$City)
  })
  

#==================================county_month_average_aqi========================  
  output$month_average_aqi = renderPlot({
    

    if (input$radio=="No") {      #remember to use return
      return(ggplot(aqi_reac(), aes(x=long, y=lat))+geom_polygon(aes(group=group, fill=ave_aqi)) + 
               scale_fill_gradient(low="lightblue",high="blue") + coord_map()+ theme_bw()) 
    }
    if (input$radio=="Yes") {
      return(ggplot(aqi_reac(), aes(x=long, y=lat))+geom_polygon(aes(group=group, fill=ave_aqi))  + 
               scale_fill_gradient(low="lightblue",high="blue") + 
        coord_map()+geom_point(data=uv_reac(), aes(x=lng, y=lat, color=ave_uv_issued, size=1)) + 
        geom_point(data=uv_reac_selected(), aes(x=lng, y=lat), shape=21, shape = 21, colour = "black", size = 5, stroke = 5) +
        scale_color_gradient(low='green', high='red')+ theme_bw())
    }
      
  },height = 600, width = 900)
  
  output$AQI = renderText({
    round(uv[uv$year==input$year&uv$month==input$month&uv$city==input$city,ave_aqi],digits = 1)
  })
  
  
  output$UV = renderText({
    round(uv[uv$year==input$year&uv$month==input$month&uv$city==input$city,ave_uv_issued],digits = 1)
  })
  
  output$year_distribution_aqi = renderPlotly({
   ggplotly(ggplot(year(), aes(x=month, y=ave_aqi)) + geom_col()+
              geom_hline(yintercept=50, linetype="dashed", color = "green") + 
              geom_hline(yintercept=100, linetype="dashed", color = "red"))
      
  })
  
  output$year_distribution_uv = renderPlotly({
    ggplotly(ggplot(year(), aes(x=month, y=ave_uv_issued)) + geom_col() +
               geom_hline(yintercept=6, linetype="dashed", color = "orange"))
  })
  
  output$month_distribution_aqi = renderPlotly({
    ggplotly(ggplot(month(), aes(x=year, y=ave_aqi)) + geom_col() +
               geom_hline(yintercept=50, linetype="dashed", color = "green") +
               geom_hline(yintercept=100, linetype="dashed", color = "red"))
  })
  
  output$month_distribution_uv = renderPlotly({
    ggplotly(ggplot(month(), aes(x=year, y=ave_uv_issued)) + geom_col() +
               geom_hline(yintercept=6, linetype="dashed", color = "orange"))
  }) 
#===================================page 2=========================================  
  output$selected_city = renderPlot({
    ggplot(aqi_reac(), aes(x=long, y=lat))+geom_polygon(aes(group=group)) + 
      geom_point(data=uv_reac(), aes(x=lng, y=lat,color='red',size=1)) + 
      geom_point(data=city_lm(), aes(x=lng, y=lat), shape=21, shape = 21, colour = "gold", size = 2.3, stroke = 2) +
      theme_void()+ theme(legend.position="none")
      
  },height = 250, width = 400)
  
  output$linearR = renderPlot({
    ggplot(city_lm(),aes(ave_aqi,ave_uv_issued)) + geom_point()  +
        geom_smooth(method="lm",se=FALSE)+theme_bw() +xlab("AQI") +ylab("UV")
  })
  
}