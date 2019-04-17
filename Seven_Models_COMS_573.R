library(caret)
library(mlbench)
library(ggplot2)
library(caretEnsemble)
library(doParallel)
cl <- makePSOCKcluster(5)
registerDoParallel(cl)


set.seed(107)

train <- read.csv("lab4-train.csv", 
                 head = TRUE,
                 sep = ",")

test <- read.csv("lab4-test.csv",
			head = TRUE,
			sep = ",")

trainX = train[,1:4]
trainY = train[,5]
testX = test[,1:4]
testY = test[,5]

control <- trainControl(method="repeatedcv", number=7, repeats=3, savePredictions="final", classProbs=FALSE, allowParallel = TRUE, )
algorithmList <- c('nnet', 'kknn', 'regLogistic', 'naive_bayes', 'J48')

##Sadly I had to train all of these one by one. I tried to use caretList but it does not play nice with 
##confusion matrices

##NEURAL NETWORK
set.seed(seed)
fit.nnet <- train(trainX, trainY, method="nnet",trControl=control)
predict.nnet <- predict(fit.nnet, test)

##K NEAREST NEIGHBOR
set.seed(seed)
fit.kknn <- train(trainX, trainY, method="kknn",trControl=control)
predict.kknn <- predict(fit.kknn, test)

##REGLOGISTIC
set.seed(seed)
fit.regLogistic <- train(trainX, trainY, method="regLogistic",trControl=control)
predict.regLogistic <- predict(fit.regLogistic, test)

##NAIVE BAYES
set.seed(seed)
fit.naive_bayes<- train(trainX, trainY, method="naive_bayes",trControl=control)
predict.naive_bayes<- predict(fit.naive_bayes, test)

##J48
set.seed(seed)
fit.J48<- train(trainX, trainY, method="J48",trControl=control)
predict.J48<- predict(fit.J48, test)

##ADABOOST.M1
set.seed(seed)
fitGrid_2 <- expand.grid(mfinal = (1:3)*3,         # Without this training goes on for a extremely long time.
                         maxdepth = c(1, 3),       # change to higher nums for mfinal and maxdepth for longer train time and better performance
                         coeflearn = c("Breiman")) 

fitControl_2 <- trainControl(method = "repeatedcv", # Without this training goes on for a extremely long time.
                             number = 5, 
                             repeats = 3)
fit.adaboost <- train(trainX, trainY, method="AdaBoost.M1",trControl = fitControl_2,
  tuneGrid = fitGrid_2, #and this is new, too!
  verbose = TRUE)
predict.adaboost <- predict(fit.adaboost, test)
##RANDOM FORREST
set.seed(seed)
fit.rf <- train(trainX, trainY, method="rf", metric=metric, trControl=control)
predict.rf <- predict(fit.rf, test)


##Majority Voting Experiments

MajorityVoting <- function(J48Weight, naiveWeight, regWeight, kknnWeight, nnetWeight, adaWeight,rfWeight ){

majorityVote <- predict.nnet ## this is becuase I did not know to get a new vector in the same factor as what predict returns
yesCounter <- 0

## Also had to check these manually. R is interesting...
for(i in 1:length(testY)){

		if(predict.J48[i] == 'yes'){
			yesCounter <- yesCounter + J48Weight
		}
		if(predict.naive_bayes[i] == 'yes'){
			yesCounter <- yesCounter + naiveWeight
		}
		if(predict.regLogistic[i] == 'yes'){
			yesCounter <- yesCounter + regWeight
		}
		if(predict.kknn[i] == 'yes'){
			yesCounter <- yesCounter + kknnWeight
		}
		if(predict.nnet[i] == 'yes'){
			yesCounter <- yesCounter + nnetWeight
		}	
		if(predict.adaboost[i] == 'yes'){
			yesCounter <- yesCounter + adaWeight
		}
		if(predict.rf[i] ==  'yes'){
			yesCounter <- yesCounter + rfWeight
		}
		ifelse(yesCounter >= 4, majorityVote[i] <- 'yes' , majorityVote[i] <- 'no' )
		yesCounter <- 0
	}

confusionMatrix(majorityVote, testY)
}
MajorityVoting(1, 1, 1, 1, 1, 1, 1) ##unweighted Voting
MajorityVoting(1.25, 1, 1.5, .5, 1.25,.75,.75)##this and below are weighted majority voting
MajorityVoting(1.5, .5, .5, .5, 2,1.5,.5)
MajorityVoting(3, .5, .5, .5, .5,1,1)
MajorityVoting(2, .5, 1.5, .5, 2,.25,.25)
stopCluster(cl)