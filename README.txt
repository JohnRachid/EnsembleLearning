This consists of 3 different scripts to run in the languge R mainly using the caret repository. All models use the lab4-train.csv and lab4-test.csv
to train and test the models. This data is from the UC Irvine Machine Learning Repository found at 
	 https://archive.ics.uci.edu/ml/index.php
and the data for this project can be found at
	https://archive.ics.uci.edu/ml/datasets/Blood+Transfusion+Service+Center


RF_and_AdaBoost_M1.R 
	This file trains both the RF and AdaBoost.M1 models on the data and determines the optimal hyper parameters for each model.
	After this the model will output accuracy and performance on the training model and output the confusion matrix and statistics
	on the testing data.
Five_Models_COMS_573.R
	This file trains 5 different types of models on the data and determines the optimal hyper parameters for each model.
	After this the model will output accuracy and performance on the training model and output the confusion matrix and statistics
	on the testing data. After this the optimal models will be used in an ensemble with both unweighted and weighted majority voting.
	The weights were set by me and somewhat related to the performance of the model. This outputs the confusion matrix and statistics
	on the ensembles performance on the test data.
Seven_Models_COMS_573.R
	This file does the same as Five_Models_COMS_573.R however it also adds the models from RF_and_AdaBoost_M1.R for a total of seven models.

HOW TO RUN
	The enviroment I ran this in was RGUI 64-bit 3.5.3. This is a pretty bad enviroment to work in and would randomly duplicate my code so
	if the code runs in a odd way please double check for code duplication. Also sometimes the code will work then if you reload the file it will not work. 
	please let me know if you run into any problems as this works on my machine.
	
	BEFORE YOU CAN RUN THE CODE YOU MUST INSTALL THE DEPENDENCIES
		caret: install.packages("caret", dependencies = c("Depends", "Suggests"))
		mlbench: install.packages("mlbench")
		this should install all needed dependencies however if it prompts you saying a library is needed you may need to do install.packages("packagename") fir that package
		
	Steps
	1. Once RGUI is installed navigate to the folder this project is in and double click the .RData
	2. This should open the saved workspace on your device
	3. Then navigate to the upper left hand corner and click on the foder arrow icon.
	4. From here select which file you want to run according to the descriptions above.
	5. Once you open the file click inside the files window and press your devices hotkey to highlight all. (control + A on windows)
	6. Now click on the third icon from the left on the upper left of the screen. It looks like a piece of paper pointing to another piece of paper.
	7. The program should run and output all of the data to the R Console
