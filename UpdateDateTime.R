# Select the dates in which the tweets were created and convert them into IST date-time format
tweets = read.csv("AllTweets.csv")
tweets$DateTime = as.POSIXct(tweets$DateTime, origin = "1970-01-01", tz = "Asia/Calcutta")

# Group by the day and hour and count the number of tweets that occurred in each hour
ggplot_data = tweets %>%
  mutate(day = day(DateTime),
         month = month(DateTime, label = TRUE),
         hour = hour(DateTime)) %>%
  mutate(day_hour = paste(month,"-",day,"-",hour, sep = "")) %>%
 group_by(day_hour) %>%
  tally()

# Simple line ggplot
ggplot(ggplot_data, aes(x = day_hour, y = n)) +
  geom_line(aes(group = 1)) +
  geom_point()+
  theme_minimal()+
  geom_text(aes(label = round(n,1)), vjust = "inward", hjust = "inward")+
  ggtitle("Tweet Freqeuncy from  25th January 11pm to 9am on 26th January with #RepublicDay hashtag")+
  ylab("Tweet Count")+
  xlab("Month - Day - Hour")
