#!/usr/bin/Rscript --vanilla
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)
library(grid)

#------------------------------------------------------------------------------

printf <- function(...) invisible(print(sprintf(...)))

#------------------------------------------------------------------------------

png(filename='dirty-and-pause.png', width=860, height=640)

d <- read.csv('kernel-dwt-events.csv')
d$Time <- d$Time - d$Time[1]
time_range=c(0, max(d$Time))

p1 <- ggplot(d %>% filter(Event == 'AccDirty'), aes(x=Time, y=Value)) +
        geom_line() +
        xlab('Time (s)') +
        ylab('Accumulated dirty (page)') +
        xlim(time_range) +
        theme_bw()
d2 <- d %>% filter(Event == 'AccPause')
pause <- c(0, diff(d2$Value))
pause[pause < 0] <- 0
d3 <- data.frame(Time = d2$Time,
                 Event = rep('Pause', nrow(d2)),
                 Value=pause
)
d4 <- rbind(d2, d3)
p2 <- ggplot(d4, aes(x=Time, y=Value, color=Event)) +
        geom_line() +
        xlab('Time (s)') +
        ylab('Pause (ms)') +
        xlim(time_range) +
        theme_bw() +
        theme(legend.position='none')
grid.arrange(p1, p2, nrow=2)

dev.off()
save.image(file='kernel-dwt-events.RData')
