library(dplyr)
library(reshape2) 
library(ggplot2)

Labels <- readLines("C://projects/projektarbeit/TopicLabels.txt")

# create and plot heatmap for Die Grünen
dieGrünen <- result %>% filter(partei %in% c(41111, 41112, 41113))
topic_proportion_pro_wahlperiode_grünen <- 
  aggregate(theta[dieGrünen$abschnitt_id,], 
            by = list(wahljahr = dieGrünen$wahljahr), mean)

colnames(topic_proportion_pro_wahlperiode_grünen)[2:(K+1)] <- Labels 
vizDataFrame_grüne <- melt(topic_proportion_pro_wahlperiode_grünen, id.vars = "wahljahr")

ggplot(vizDataFrame_grüne, aes(x = wahljahr, y = variable, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "darkgreen") +
  labs(x = "Wahljahr", y = "Topic", fill = "Proportion") +
  theme_minimal()

# create and plot heatmap for FDP
fdp <- result %>% filter(partei == 41420)
topic_proportion_pro_wahlperiode_fdp <- 
  aggregate(theta[fdp$abschnitt_id,], 
            by = list(wahljahr = fdp$wahljahr), mean)

colnames(topic_proportion_pro_wahlperiode_fdp)[2:(K+1)] <- Labels
vizDataFrame_fdp <- melt(topic_proportion_pro_wahlperiode_fdp, id.vars = "wahljahr")

ggplot(vizDataFrame_fdp, aes(x = wahljahr, y = variable, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#FFD700") +
  labs(x = "Wahljahr", y = "Topic", fill = "Proportion") +
  theme_minimal()


# create and plot heatmap for SPD
spd <- result %>% filter(partei == 41320)
topic_proportion_pro_wahlperiode_spd <- 
  aggregate(theta[spd$abschnitt_id,], 
            by = list(wahljahr = spd$wahljahr), mean)

colnames(topic_proportion_pro_wahlperiode_spd)[2:(K+1)] <- Labels 
vizDataFrame_spd <- melt(topic_proportion_pro_wahlperiode_spd, id.vars = "wahljahr")

ggplot(vizDataFrame_spd, aes(x = wahljahr, y = variable, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "darkred") +
  labs(x = "Wahljahr", y = "Topic", fill = "Proportion") +
  theme_minimal()


# plot total distribution
topic_proportion_pro_wahlperiode_insg <- 
  aggregate(theta[result$abschnitt_id,], 
            by = list(wahljahr = result$wahljahr), mean)

colnames(topic_proportion_pro_wahlperiode_insg)[2:(K+1)] <- Labels
vizDataFrame_grüne <- melt(topic_proportion_pro_wahlperiode_insg, id.vars = "wahljahr")

ggplot(vizDataFrame_grüne, aes(x = wahljahr, y = variable, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "black") +
  labs(x = "Wahljahr", y = "Topic", fill = "Proportion") +
  theme_minimal()

#######################################################################

# table of topic labels and top 20 terms

Top_20_Terms <- apply(terms(topmod, 20), 2, paste, collapse = ", ")
LabelTerms <- data.frame(Labels, Top_20_Terms)

file1 <- file("Top20Terms.txt", open = "w")

for (i in 1:nrow(LabelTerms)) {
  line <- paste(LabelTerms$Labels[i], LabelTerms$Top_20_Terms[i], sep = "\n")
  writeLines(line, file1)
  writeLines("\n\n", file1)
}
