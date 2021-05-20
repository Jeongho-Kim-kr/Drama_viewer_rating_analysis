## 데이터 정의
rm(list=ls())

library(readxl)
netflix <- read_excel('netflix_original_종합_수정(sum).xlsx')

netflix <- netflix[,c(7:8,15,29:37)]
netflix <- na.omit(netflix)
netflix[, 4:12] <- lapply(netflix[, 4:12], factor)
netflix[, 1:3] <- lapply(netflix[, 1:3], as.numeric)


# ALL_rating outlier 제거: 낮은 점수 반영 못함
# myboxplot <- boxplot(netflix$All_rating)
# myboxplot$out
# netflix <- netflix[-c(which(netflix$All_rating<=3.7)),]
# myboxplot <- boxplot(netflix$All_rating)

### 년도
library(ggplot2)
ggplot(netflix,aes(x=as.factor(year),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(year)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("년도") + ylab("점수") + labs(fill = "년도")

### age
ggplot(netflix,aes(x=as.factor(age),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(age)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("age") + ylab("점수") + labs(fill = "age")

### harmful_themes
ggplot(netflix,aes(x=as.factor(harmful_themes),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(harmful_themes)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("harmful_themes") + ylab("점수") + labs(fill = "harmful_themes")

### lewdness
ggplot(netflix,aes(x=as.factor(lewdness),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(lewdness)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("lewdness") + ylab("점수") + labs(fill = "lewdness")

### violence
ggplot(netflix,aes(x=as.factor(violence),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(violence)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("violence") + ylab("점수") + labs(fill = "violence")

### profanity
ggplot(netflix,aes(x=as.factor(profanity),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(profanity)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("profanity") + ylab("점수") + labs(fill = "profanity")

### fear
ggplot(netflix,aes(x=as.factor(fear),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(fear)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("fear") + ylab("점수") + labs(fill = "fear")

### drugs
ggplot(netflix,aes(x=as.factor(drugs),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(drugs)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("drugs") + ylab("점수") + labs(fill = "drugs")

### immatatable
ggplot(netflix,aes(x=as.factor(immatatable),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(immatatable)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("immatatable") + ylab("점수") + labs(fill = "immatatable")

### cooks distance outlier제거
fit_tmp <- lm(All_rating ~ . , data=netflix)
cooks <- cooks.distance(fit_tmp)
plot(cooks, pch=".", cex=1.5, main = "Plot for Cook's Distance")

text(x=1:length(cooks), y=cooks, labels = ifelse(cooks > 4/nrow(netflix), names(cooks), ""), col = "red")
outlier <- names(cooks)[(cooks > 4/nrow(netflix))]
outlier <- as.integer(na.omit(outlier))
netflix <- netflix[-outlier, ]

## 일반회귀
fit_OLS <- lm(All_rating ~ . , data=netflix)
summary(fit_OLS)
anova(fit_OLS)
par(mfrow = c(2,2))
plot(fit_OLS)

## 로버스트 회귀
library('MASS')
fit_m <- rlm(All_rating ~ . , data=netflix)
summary(fit_m)
anova(fit_m)
par(mfrow = c(2,2))
plot(fit_m)