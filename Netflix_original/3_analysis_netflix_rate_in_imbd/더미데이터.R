# 더미 데이터
library(fastDummies)
netflix <- dummy_cols(netflix, select_columns = c('age', 'year', 'harmful_themes', 'lewdness', 'violence', 'profanity', 'fear', 'drugs', 'immatatable'))
netflix <- netflix[,-c(4:12)]
netflix[, 4:44] <- lapply(netflix[, 4:44], factor)