# ==============================
# Twitter Sentiment Analysis Shiny App
# ==============================

library(shiny)
library(tidyverse)
library(tidytext)
library(wordcloud)
library(RColorBrewer)

# ---------------------
# UI
# ---------------------
ui <- fluidPage(
  titlePanel("Twitter Sentiment Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV (target,text)", accept = ".csv"),
      numericInput("maxwords", "Max words in Wordcloud:", value = 100, min = 10, max = 500),
      checkboxGroupInput("sent_filter", "Filter sentiment for Wordcloud:",
                         choices = c("positive", "negative", "neutral"),
                         selected = c("positive", "negative", "neutral"))
    ),
    
    mainPanel(
      plotOutput("sentPlot"),
      plotOutput("wordCloud")
    )
  )
)

# ---------------------
# Server
# ---------------------
server <- function(input, output) {
  
  # Reactive: load and preprocess CSV
  tweets_data <- reactive({
    req(input$file)
    df <- read_csv(input$file$datapath, col_names = FALSE)
    
    # Ensure at least 2 columns
    if(ncol(df) < 2) stop("CSV must have at least 2 columns: target,text")
    colnames(df)[1:2] <- c("target", "text")
    
    df %>%
      mutate(sentiment = case_when(
        target == 0 ~ "negative",
        target == 4 ~ "positive",
        target == 2 ~ "neutral"
      )) %>%
      select(text, sentiment)
  })
  
  # Reactive: tidy tokens, remove stopwords
  tidy_tweets <- reactive({
    df <- tweets_data()
    df %>%
      mutate(text = str_replace_all(text, "[[:punct:]]", "")) %>%
      unnest_tokens(word, text) %>%
      anti_join(stop_words, by = "word")
  })
  
  # Sentiment plot
  output$sentPlot <- renderPlot({
    df <- tidy_tweets() %>%
      inner_join(get_sentiments("bing"), by = "word") %>%
      count(sentiment = sentiment.y)
    
    ggplot(df, aes(x = sentiment, y = n, fill = sentiment)) +
      geom_col() +
      labs(title = "Tweet Sentiment Distribution", x = "Sentiment", y = "Word Count") +
      theme_minimal()
  })
  
  # Wordcloud plot
  output$wordCloud <- renderPlot({
    df <- tidy_tweets() %>%
      filter(sentiment %in% input$sent_filter) %>%   # filter selected sentiments
      count(word, sort = TRUE)
    
    wordcloud(words = df$word,
              freq = df$n,
              max.words = input$maxwords,
              colors = brewer.pal(8, "Dark2"))
  })
}

# ---------------------
# Run App
# ---------------------
shinyApp(ui, server)
