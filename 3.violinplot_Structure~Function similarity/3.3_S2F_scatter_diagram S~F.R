setwd("")

## install packages--
# install.packages('ggplot2')
# install.packages('dplyr')

library(ggplot2)
require(dplyr)

df <- read.csv('similarity_2_function_forPlot.csv',header = TRUE,sep = ',')
df <- df[!is.na(df$Function_similarity),]
df$Structure_similarity <- round(df$Structure_similarity,2)
#normalization
min(df$Function_similarity)
max(df$Function_similarity)
df$Function_similarity <- (df$Function_similarity-min(df$Function_similarity))/(max(df$Function_similarity)-min(df$Function_similarity))


d <- mutate(df,Structure_similarity=factor(Structure_similarity)) %>%
  group_by(Structure_similarity) %>%
  summarise(median.default(Function_similarity))

cut_off <- 0.6
df$Structure_level <- 'High'
df$Structure_level[df$Structure_similarity < cut_off] <- 'Medium'
df$Structure_level[df$Structure_similarity < 0.07] <- 'Low'

df$Structure_similarity <- as.factor(df$Structure_similarity)
df <- df %>% group_by(Structure_similarity) %>% filter(n() >= 5)


# Violin plot
ggplot(df,aes(x=Structure_similarity,y=Function_similarity,color=Structure_level))+
  geom_violin()+
  geom_point(position = position_jitter(0.1),size=.1,alpha=.5)+
  stat_summary(fun=median,geom='line',aes(group=1),color='black')+
  stat_summary(fun=median,geom='point',color='red',size=.5)+
  scale_x_discrete(breaks=seq(0,1,0.2))


