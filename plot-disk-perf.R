#!/usr/bin/Rscript --vanilla
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)

printf <- function(...) invisible(print(sprintf(...)))
d1 <- read.csv('data/2Mx5-default.csv')
printf('default: mean %.3f sd %.3f', mean(d1$kBps), sd(d1$kBps))
d1$Cache <- rep('default', times=nrow(d1))
d2 <- read.csv('data/2Mx5-256K.csv')
printf('256K: mean %.3f sd %.3f', mean(d2$kBps), sd(d2$kBps))
d2$Cache <- rep('256K', times=nrow(d2))
d <- rbind(d1, d2)

png(filename='edge-disk-write.png', width=480, height=480)
p <- ggplot(d, aes(x=Index, y=kBps, color=Cache)) +
    geom_line() + geom_point() +
    theme_bw() +
    ylim(0, max(d$kBps)) +
    xlab('Test') +
    ylab('kBps') +
    labs(caption='Writes 5 2M-blocks in each test')
p
dev.off()

