## 데이터 정의
rm(list=ls())

library(readxl)
netflix <- read_excel('netflix_original_종합_수정(sum)_(정량화보함).xlsx')

netflix <- netflix[,c(9,15,18,32:40)]
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
ggplot(netflix,aes(x=as.factor(Year),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Year)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("년도") + ylab("점수") + labs(fill = "년도")

### age
ggplot(netflix,aes(x=as.factor(Age),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Age)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("age") + ylab("점수") + labs(fill = "Age")

### harmful_themes
ggplot(netflix,aes(x=as.factor(Harmful_themes),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Harmful_themes)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("harmful_themes") + ylab("점수") + labs(fill = "Harmful_themes")

### lewdness
ggplot(netflix,aes(x=as.factor(Lewdness),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Lewdness)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("lewdness") + ylab("점수") + labs(fill = "Lewdness")

### violence
ggplot(netflix,aes(x=as.factor(Violence),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Violence)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("violence") + ylab("점수") + labs(fill = "Violence")

### profanity
ggplot(netflix,aes(x=as.factor(Profanity),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Profanity)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("profanity") + ylab("점수") + labs(fill = "Profanity")

### fear
ggplot(netflix,aes(x=as.factor(Fear),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Fear)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("fear") + ylab("점수") + labs(fill = "Fear")

### drugs
ggplot(netflix,aes(x=as.factor(Drugs),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Drugs)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("drugs") + ylab("점수") + labs(fill = "Drugs")

### immatatable
ggplot(netflix,aes(x=as.factor(Immatatable),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Immatatable)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("immatatable") + ylab("점수") + labs(fill = "Immatatable")

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
