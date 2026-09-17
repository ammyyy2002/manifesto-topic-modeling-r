library(dplyr)
library(quanteda)
library(udpipe)
library(tidyverse)
options(stringsAsFactors = FALSE)

# load POS-tagging model for tagging und lemmatization (Dependency Parsing)
m_ger <- udpipe::udpipe_download_model(language = "german-gsd")
m_ger <- udpipe_load_model(file = m_ger$file_model)

# annotate each text chunk
pb <- txtProgressBar(min = 1,max=nrow(result), style=3)
for (i in 1:nrow(result))
{
  setTxtProgressBar(pb,i)
  
  text <- result$text[i]
  text <- gsub("[ß]", "ss", text)
  text_prepared <- str_squish(text)
  
  # annotate the original text and save as data.frame
  df_text_annot <- udpipe::udpipe_annotate(m_ger, x = text_prepared) %>% 
    as.data.frame() %>%
    dplyr::select(-sentence)
  
  # filter all lemmatized nouns and proper nouns
  options(width = 60)
  knitr::opts_chunk$set(tidy.opts=list(width.cutoff=80), tidy=TRUE)
  text_tagged <- df_text_annot %>% filter(upos %in% c('NOUN','PROPN'))
  text_filtered <- paste(text_tagged$lemma, collapse = " ", sep = "")
  
  result$text[i] <- text_filtered
}
