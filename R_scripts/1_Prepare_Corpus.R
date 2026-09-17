library(manifestoR)
library(dplyr)
library(tidytext)
library(quanteda)

# usage of personal API key
mp_setapikey("C://projects/projektarbeit/other_docs/manifesto_apikey.txt")

# Bündnis 90/Die Grünen (41111, 41112, 41113), FDP (41420) und SPD (41320) from 1983 to 2021
corp_regierung <- mp_corpus(
  edate > as.Date("1983-02-28") 
  & (party == 41113 | party == 41420 | party == 41320 | party == 41111 | party == 41112))

# if necessary second removal of punctuation and numbers
#corp_cleaned <- tm_map(corp_regierung, removePunctuation)
#corp_cleaned <- tm_map(corp_cleaned, removeNumbers)


df_corp_tidy <- corp_regierung %>% tidy()  # dim(df_corp_tidy) [1] 33 17

# split texts into chunks of 100 words and create new dataframe with new text chunks
result <- data.frame()
pb <- txtProgressBar(min = 1,max=nrow(df_corp_tidy), style=3)
for(id in 1:nrow(df_corp_tidy))
{
  setTxtProgressBar(pb,id)
  t <- df_corp_tidy$text[id]

  example <- tokens(t) %>% unlist()
  example_split <- sapply(seq(from=1, to=length(example), by=99), function(i) {
    if((i + 99) < length(example))
      example[i:(i+99)]
    else
      example[i:length(example)]
  })
  example_split %>% tokens()
  
  
  text <- seq(1, length(example_split))
  wahljahr <- seq(1, length(example_split))
  partei <- seq(1, length(example_split))
  abschnitt_id <- seq(1, length(example_split))

  for(n in 1:length(example_split))
  {
    text[n] <- paste(example_split[[n]], collapse = " ")
    partei[n] <- df_corp_tidy$party[id]
    wahljahr[n] <- floor(df_corp_tidy$date[id] / 100)
    abschnitt_id[n] <- paste(df_corp_tidy$manifesto_id[id], n, sep = "_")
  }
  
  df_neu <- data.frame(abschnitt_id, partei, wahljahr, text)
  
  result <- rbind(result, df_neu)
}
