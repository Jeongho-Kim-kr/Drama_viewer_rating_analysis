rm(list=ls())

library(readxl)
netflix <- read_excel('netflix_original_종합_수정(sum).xlsx')

# genre는 더미 데이터가 너무 많이 생겨 일단 보류
# netflix_G <- netflix[,c(3,7:8,15,29:37)]
netflix <- netflix[,c(7:8,15,29:37)]
netflix <- na.omit(netflix)
netflix[, 4:12] <- lapply(netflix[, 4:12], factor)
netflix[, 1:3] <- lapply(netflix[, 1:3], as.numeric)

qt(0.05, 10)

# 일반회귀
fit_OLS <- lm(All_rating ~ . , data=netflix)
summary(fit_OLS)
anova(fit_OLS)
par(mfrow = c(2,2))
plot(fit_OLS)

# 로버스트 회귀
library('MASS')
fit_m <- rlm(All_rating ~ . , data=netflix)
summary(fit_m)
anova(fit_m)
par(mfrow = c(2,2))
plot(fit_m)


# fit_lms <- lqs(All_rating ~ . , data=netflix, method = 'lms')
# summary(fit_lms)
# plot(fit_lms)

# fit_lts <- lqs(All_rating ~ . , data=netflix, method = 'lts', quantile=10)
# summary(fit_lts)
# plot(fit_lts)



