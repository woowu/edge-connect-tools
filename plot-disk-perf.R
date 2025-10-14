#!/usr/bin/Rscript --vanilla
library(dplyr)
library(ggplot2)

printf <- function(...) invisible(print(sprintf(...)))

d1 <- read.csv('data/2Mx5-default.csv')
d1$Time <- d1$Time - min(d1$Time)
printf('default: mean %.3f sd %.3f', mean(d1$Throughput), sd(d1$Throughput))
d1$Cache <- rep('default', times=nrow(d1))
d2 <- read.csv('data/2Mx5-3M.csv')
d2$Time <- d2$Time - min(d2$Time)
printf('3M: mean %.3f sd %.3f', mean(d2$Throughput), sd(d2$Throughput))
d2$Cache <- rep('3M', times=nrow(d2))
d3 <- read.csv('data/2Mx5-256K.csv')
d3$Time <- d3$Time - min(d3$Time)
printf('256K: mean %.3f sd %.3f', mean(d3$Throughput), sd(d3$Throughput))
d3$Cache <- rep('256K', times=nrow(d3))
d <- rbind(d1, d2, d3)

png(filename='edge-disk-write.png')
p <- ggplot(d, aes(x=Time, y=Throughput, color=Cache)) +
    geom_line() + geom_point() +
    theme_bw() +
    ylim(0, max(d$Throughput)) +
    xlab('Time (s)') +
    ylab('Write throughput (bBs)') +
    labs(caption='Continuously writes 5 2M-blocks')
p
dev.off()
save.image('plot-disk-perf.RData')
