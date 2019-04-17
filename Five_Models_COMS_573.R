library(caret)
library(mlbench)
library(ggplot2)

library(doParallel) ##Begin start of parallel processing
cl <- makePSOCKcluster(5)
registerDoParallel(cl)##end start of parallel processing


set.seed(107)

train <- read.csv("lab4-train.csv", 
                 head = TRUE,
                 sep = ",")

test <- read.csv("lab4-test.csv",
			head = TRUE,
			sep = ",")
##split the train and test data into x and y respectivly
trainX = train[,1:4]
trainY = train[,5]
testX = test[,1:4]
testY = test[,5]

control <- trainControl(method="repeatedcv", number=7, repeats=3, savePredictions="final", classProbs=FALSE, allowParallel = TRUE, )##train control for the models
algorithmList <- c('nnet', 'kknn', 'regLogistic', 'naive_bayes', 'J48')

##Sadly I had to train all of these one by one. I tried to use caretList but it does not play nice with 
##confusion matrices

##NEURAL NETWORK
set.seed(seed)
fit.nnet <- train(trainX, trainY, method="nnet",trControl=control)##training
print(fit.nnet)
predict.nnet <- predict(fit.nnet, test)##predicting on test data
confusionMatrix(predict.nnet, testY) 

##K NEAREST NEIGHBOR
set.seed(seed)
fit.kknn <- train(trainX, trainY, method="kknn",trControl=control)##training
print(fit.kknn)
predict.kknn <- predict(fit.kknn, test)##predicting on test data
confusionMatrix(predict.kknn, testY)

##REGLOGISTIC
set.seed(seed)
fit.regLogistic <- train(trainX, trainY, method="regLogistic",trControl=control)##training
print(fit.regLogistic)
predict.regLogistic <- predict(fit.regLogistic, test)##predicting on test data
confusionMatrix(predict.regLogistic, testY)

##NAIVE BAYES
set.seed(seed)
fit.naive_bayes<- train(trainX, trainY, method="naive_bayes",trControl=control)##training
print(fit.naive_bayes)
predict.naive_bayes<- predict(fit.naive_bayes, test)##predicting on test data
confusionMatrix(predict.naive_bayes, testY)

##J48
set.seed(seed)
fit.J48<- train(trainX, trainY, method="J48",trControl=control)##training
print(fit.J48)
predict.J48<- predict(fit.J48, test)##predicting on test data
confusionMatrix(predict.J48, testY)




##majority Voting Experiments

MajorityVoting <- function(J48Weight, naiveWeight, regWeight, kknnWeight, nnetWeight){

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
		ifelse(yesCounter >= 3, majorityVote[i] <- 'yes' , majorityVote[i] <- 'no') ##if 3 or more models vote yes then the final result of the voting is a yes
		yesCounter <- 0
	}

confusionMatrix(majorityVote, testY)
}
MajorityVoting(1, 1, 1, 1, 1) ## Unweighted voting 
MajorityVoting(1.25, 1, 1, .5, 1.25) ##this and below is Weighted Majority Voting
MajorityVoting(1, 1, .5, .5, 2)
MajorityVoting(.5, .5, .5, .5, 3)
MajorityVoting(.5, .5, 1.5, 2, .5)
stopCluster(cl)##finish parallel processing