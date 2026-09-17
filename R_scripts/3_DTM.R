library(quanteda)

# transform dataframe to corpus object
corp_prep <- corpus(result, docid_field = 1, text_field = 4)

# expanded stopwords
# https://github.com/stopwords-iso/stopwords-de/blob/master/stopwords-de.txt 
stopwords_deutsch <- readLines("C://projects/projektarbeit/other_docs/stopwords_deutsch.txt", encoding = "UTF-8")
# self defined meaningless top words
topwords_deutsch <- readLines("C://projects/projektarbeit/other_docs/topwords_deutsch.txt", encoding = "UTF-8")


# tokenization and normalization: lowercase; remove punctuation, numbers, stopwords and topwords
corp_toks <- corp_prep %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(pattern = stopwords_deutsch, padding = T) %>%
  tokens_remove(pattern = topwords_deutsch, padding = T)


# get the most common 250 collocations, that appear at least 25 times, as a list
corp_kollokationen <- quanteda.textstats::textstat_collocations(corp_toks, min_count = 25)
corp_kollokationen <- corp_kollokationen[1:250, ]
kollokationen <- corp_kollokationen$collocation
kollokationen_liste <- strsplit(kollokationen, " ")
corp_toks <- tokens_compound(corp_toks, kollokationen_liste)


# create document-term-matrix und remove terms that appear in less than 3 documents
DTM <- corp_toks %>%
  tokens_remove("") %>%
  dfm() %>%
  dfm_trim(min_docfreq = 3)

# remove potentially empty rows/columns
leere_reihen <- rowSums(DTM) <= 0
DTM <- DTM[!leere_reihen, ]
result <- result[!leere_reihen, ]
