#!/usr/bin/Rscript --vanilla
library(dplyr)
library(ggplot2)

printf <- function(...) invisible(print(sprintf(...)))

d1 <- read.csv('data/2Mx5-default.csv')
printf('default: mean %.3f sd %.3f', mean(d1$Throughput), sd(d1$Throughput))
d1$Cache <- rep('default', times=nrow(d1))
d2 <- read.csv('data/2Mx5-3M.csv')
printf('3M: mean %.3f sd %.3f', mean(d2$Throughput), sd(d2$Throughput))
d2$Cache <- rep('3M', times=nrow(d2))
#d3 <- read.csv('data/2Mx5-256K-2.csv')
#printf('256K: mean %.3f sd %.3f', mean(d3$Throughput), sd(d3$Throughput))
#d3$Cache <- rep('256K', times=nrow(d3))
d <- rbind(d1, d2)

png(filename='edge-disk-write.png')
p <- ggplot(d, aes(x=Index, y=Throughput, color=Cache)) +
    geom_line() + geom_point() +
    theme_bw() +
    ylim(0, max(d$Throughput)) +
    xlab('n-th dd') +
    ylab('Write throughput (Throughput)') +
    labs(caption='Writes 5 2M-blocks in each test')
p
dev.off()
