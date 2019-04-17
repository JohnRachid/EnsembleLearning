library(caret)
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
##splitting the data into train and test x and y respectivly
trainX = train[,1:4]
trainY = train[,5]
testX = test[,1:4]
testY = test[,5]

fitGrid_2 <- expand.grid(mfinal = (1:3)*3,         # Without this training goes on for a extremely long time.
                         maxdepth = c(1, 3),       # change to higher nums for mfinal and maxdepth for longer train time and better performance
                         coeflearn = c("Breiman")) 

fitControl_2 <- trainControl(method = "repeatedcv", # Without this training goes on for a extremely long time.
                             number = 5, 
                             repeats = 3)

control <- trainControl(method="repeatedcv", number=10, repeats=3) ##train control for RF
seed <- 7
metric <- "Accuracy"

set.seed(seed)

fit.adaboost <- train(trainX, trainY, method="AdaBoost.M1",trControl = fitControl_2, ##Train adaboost.m1
  tuneGrid = fitGrid_2, #and this is new, too!
  verbose = TRUE)
predict.adaboost <- predict(fit.adaboost, test)## use trained AdaBoost model on the test data

set.seed(seed)
fit.rf <- train(trainX, trainY, method="rf", metric=metric, trControl=control) ##train RF
predict.rf <- predict(fit.rf, test)## used trained RF model on the test data
# summarize results

print(fit.adaboost)
print(fit.rf)
##confusion matrixes
confusionMatrix(predict.rf, testY)
confusionMatrix(predict.adaboost, testY)
stopCluster(cl)##finish parallel processing
