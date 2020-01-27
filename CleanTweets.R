CleanTweets <- function(filename, remove_rts = TRUE){
  
  # Import the CleanText function
  source("CleanText.R")
  
  # Parse the .json file given by the Twitter API into an R data frame
  raw_tweets <- parse_stream(filename)
  # If remove_rst = TRUE, filter out all the retweets from the stream
  if(remove_rts == TRUE){
    raw_tweets = filter(raw_tweets,raw_tweet$is_retweet == FALSE)
  }
  # Keep only the tweets that are in English
  raw_tweets <- filter(raw_tweets, raw_tweets$lang == "en")
  # Select the features that you want to keep from the Twitter stream and rename them
  # so the names match those of the columns in the Tweets table in our database
  filtered_tweet <- raw_tweets[,c("screen_name","text","created_at")]
  names(filtered_tweet) <- c("User","Tweet","DateTime")
  # Finally cleaning the tweet text
  filtered_tweet$Tweet <- sapply(filtered_tweet$Tweet, normalize_text)
  # Return the processed data frame
  return(filtered_tweet)
}