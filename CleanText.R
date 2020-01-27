CleanText <- function(text){
  # Keep only ASCII characters
  text = iconv(text, "latin1", "ASCII", sub="")
  # Convert to lower case characters
  text = tolower(text)
  # Remove any HTML tags
  text = gsub("<.*?>", " ", text)
  # Remove URLs
  text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", text)
  # Keep letters and numbers only
  text = gsub("[^[:alnum:]]", " ", text)
  # Remove stop words
  text = removeWords(text,c("rt","gt",stopwords("en")))
  # Remove any extra white space
  text = stripWhitespace(text)                                 
  text = gsub("^\\s+|\\s+$", "", text)                         
  
  return(text)
}