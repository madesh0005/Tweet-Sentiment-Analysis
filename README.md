# Twitter Sentiment Analysis Project

## Overview
This project performs **sentiment analysis** on a dataset of tweets using R and Shiny. Users can upload a CSV file containing tweets and their sentiment labels, and the app will generate a **sentiment distribution plot** and a **wordcloud** for the most frequent words.

## Features
- Upload a CSV file containing tweets (target and text).
- Automatically map numeric target to sentiment labels: `0 = negative`, `4 = positive`, `2 = neutral`.
- Tokenize tweet text and remove stopwords.
- Generate a **sentiment bar chart** showing counts of positive, negative, and neutral words.
- Generate a **wordcloud** for visualizing the most frequent words.
- Interactive options:
  - Adjust maximum words in the wordcloud.
  - Filter wordcloud by sentiment.

## Dataset Format
The CSV file should have **2 columns**:
1. `target` (numeric sentiment label)
2. `text` (tweet content)



##Libraries Used

tidyverse (data manipulation and visualization)
tidytext (text tokenization and stopwords)
wordcloud (wordcloud generation)
RColorBrewer (color palettes for wordcloud)
shiny (interactive web app)

##Author

MADESHWARAN M
