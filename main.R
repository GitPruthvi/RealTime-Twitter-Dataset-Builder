library("RSQLite")
library("rtweet")
library("dplyr")
library("knitr")
library("readr")
library("tm")
library("lubridate")
library("wordcloud")
library("ggplot2")


setwd("C:\\...")

conn = dbConnect(RSQLite::SQLite(), dbname="IndependanceDayTweets.db")

# dbExecute(conn, "CREATE TABLE Tweets(
#                   ID INTEGER PRIMARY KEY,
#                   User TEXT,
#                   Tweet TEXT,
#                   DateTime INTEGER);")

token  =  create_token(app='The Most common words used in Tweets on 26th Janurary, Independce Day of India',
                      consumer_key = '',
                      consumer_secret = '',
                      access_token = '',
                      access_secret = '')

keys  =  "#RepublicDay, #26th, #26thJan, #26thJanuary, #Republic, #71st, #HappyRepublicDay, #71stRepublicDay, #RepublicDay2020, #RepublicDayIndia"

# Initialize the streaming hour count
count  =  1

# Initialize a while loop that stops when the number of hours hits 10hrs
while(count <= 10){
  # Set the stream time to 1 hour for each iteration of 3600 seconds
  countdown  =  3600
  # Create the file name where the 1 hour stream will be stored in json format
  filename  =  paste0("Tweets_",format(Sys.time(),'%d_%m_%Y__%H_%M_%S'),".json")
  # Stream Tweets containing the desired keys for the specified amount of time
  stream_tweets(q = keys, timeout = countdown, file_name = filename)
  # Clean the streamed tweets and select the desired fields
  clean_tweets  =  CleanTweets(filename, remove_rts = TRUE)
  # Append the streamed tweets to the Tweets table in the SQLite database
  dbWriteTable(conn, "Tweets", clean_tweets, append = T)
  # Delete the .json file from this 1-hour stream as data is already been stored in SQLite database
  file.remove(filename)
  # Add the hours to the tally
  count  =  count + 1
}

#Creating a dataframe in R containing all the tweets data from the database
data  =  dbGetQuery(conn, "SELECT * FROM Tweets")
#Creating a csv file of the data
write.table(data, file="AllTweets.csv",sep=",",row.names = FALSE)
#
tweets = read.csv("AllTweets.csv")

# Create a term-document matrix and sort the words by frequency
dtm  =  TermDocumentMatrix(VCorpus(VectorSource(tweets$Tweet)))
dtm_mat  =  as.matrix(dtm)
sorted  =  sort(rowSums(dtm_mat), decreasing = TRUE)
freq_df  =  data.frame(words = names(sorted), freq = sorted)

# Plot the wordcloud
set.seed(55)
wordcloud(words = freq_df$words, freq = freq_df$freq, min.freq = 100,
          max.words=50, random.order=FALSE, rot.per=0.1,
          colors=brewer.pal(8, "Dark2"))
