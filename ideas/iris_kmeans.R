x <- "Sepal.Length"
y <- "Sepal.Width"
cluster_count <- 3

subsetted <- iris[, c(x, y)]
clusters <- kmeans(subsetted, 3)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
  "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

par(mar = c(5.1, 4.1, 0.25, 1))
plot(subsetted,
  col = clusters$cluster,
  pch = 20, cex = 2)
points(clusters$centers, pch = 4, cex = 2, lwd = 3)
