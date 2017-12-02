set.seed(308)

#load
library(data.table)
cat('loading...\n')
dir <- 'simdata'
files <- list.files(path=dir, pattern='*.csv')
temp <- lapply(paste0(dir, '/', files), fread, sep=',')
df <- rbindlist(temp)

#dataset
library(dplyr)
# sdf <- sample_n(df, 500000)
sdf <- sample_n(df, 5000)
x <- sdf[, c('DL', 'TMP', 'RAD', 'DVI'), with=F]
y <- sdf[['DVR']]

#train (cubist)
library(Cubist)
cat('training...\n')
model <- cubist(x, y)
sink('output/cubist.txt'); print(summary(model)); sink()

#train (mob)
library(party)
ctrl <- party::mob_control(
                           alpha=0.05,
                           bonferroni=TRUE,
                           minsplit=500,
                           objfun=deviance,
                           verbose=FALSE)
model <- party::mob(DVR ~ DL+TMP|DVI, data=sdf, control=ctrl, model=linearModel)
plot(model)

#train (M5P)
#  - M5P controls: WOW(M5P)
library(RWeka)
library(partykit)
model <- M5P(DVR~TMP+DL+DVI,
             data=sdf,
             control=Weka_control(N=F, M=200))
print(model)
summary(model)
plot(as.party.Weka_tree(model))

#todo: plot prediction