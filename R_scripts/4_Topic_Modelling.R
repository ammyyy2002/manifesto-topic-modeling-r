library(quanteda)
require(topicmodels)
library(LDAvis)
library("tsne")

# optimal number of topics determined (with script "CalculateTopicNumber.R") and validated
# http://rpubs.com/siri/ldatuning 
K <- 51

topmod <- LDA(DTM, K, method="Gibbs", control=list(
  iter = 500,
  seed = 1, 
  verbose = 25, 
  alpha = 0.02))


tmResult <- posterior(topmod)
attributes(tmResult)
terms(topmod, 20)

# pseudonymized names
top5termsPerTopic <- terms(topmod, 5)
topicNames <- apply(top5termsPerTopic, 2, paste, collapse = " ")

# calculating distributions and viewing the results
beta <- tmResult$terms
dim(beta)
theta <- tmResult$topics

# vizualization via LDAvis:
svd_tsne <- function(x) tsne(svd(x)$u)
json <- createJSON(phi = beta, theta = theta, doc.length = rowSums(DTM), 
                   vocab = colnames(DTM), term.frequency = colSums(DTM), 
                   mds.method = svd_tsne, plot.opts = list(xlab = "", ylab = ""))
serVis(json) # redirecting to website

# rank topics
topicProportions <- colSums(theta) / nrow(DTM)
sort(topicProportions, decreasing = TRUE)
