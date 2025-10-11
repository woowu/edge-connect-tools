#!/usr/bin/Rscript --vanilla
library(dplyr)
library(ggplot2)

printf <- function(...) invisible(print(sprintf(...)))

d <- read.csv('data/2Mx5-256K-dirty.csv')
printf('median %.3f max %.3f (KB)', median(d$Dirty), max(d$Dirty))

png(filename='edge-disk-dirty.png')
p <- ggplot(d, aes(x=Index, y=Dirty)) +
    geom_line() + geom_point() +
    theme_bw() +
    xlab('Time (s)') +
    ylab('Dirty (KB)') +
    labs(caption='Continuously writes 5 2M-blocks without sync')
p
dev.off()
