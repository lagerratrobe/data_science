  library(tidyverse)

### creating data frame
music <- c("Blues", "Hip-hop", "Jazz", "Metal", "Rock")
number <- c(8, 7, 4, 6, 11)
df.music <- data.frame(music, number)
colnames(df.music) <- c("Music", "Amount")

### Create the plot
myplot <- ggplot(data=df.music, aes(x=music, y=number)) +
 geom_bar(stat="identity") +
 xlab(colnames(df.music)[1]) +
 ylab(colnames(df.music)[2]) +
 ylim(c(0,11)) +
 ggtitle("Ulubiony typ muzyki ród studentów")

pdf("Myplot.pdf", width=5, height=5)

plot(myplot)
dev.off()
