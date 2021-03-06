# This is the Letters-KNN.R file. It runs the letterdata.csv file through the KNN Supervised Learning algorithm
# Initial conditions:
#    All packages listed in the 'libraries' section of the code must be installed prior to running this script
#    
# Citations;
# Normalize() function from book by Brett Lantz. Some other code snippets may have been borrowed from this book as well:
#     Lantz, Brett. Machine Learning with R: Learn How to Use R to Apply Powerful Machine Learning Methods and Gain an Insight into Real-world Applications. 
#     Birmingham, UK: Packt Publishing, 2013.Original data from Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science.
#


library(C50)
library(gmodels)
library(neuralnet)
library(grid)
library(MASS)
library(nnet)
library(class)
library(kernlab)
normalize <- function(x) { return((x - min(x)) / (max(x) - min(x)))}

# Read in lettersdata file and randomize 
letters <- read.csv("letterdata.csv")
letters[2:17] <- as.data.frame(lapply(letters[2:17], normalize))
set.seed(1234)
letters <- letters[sample(nrow(letters)),]

#open output file
fname <- ("../output/Letters-KNN.Rout")
out <- file(fname, open="wt")
sink(out, type="output")

for (i in seq(1:5)){
  #vary the size of the training partition based on the iteration; start with 5/10 of the data and go up to 9/10
  split <- floor(nrow(letters)*(4+i)/10)
  #always use the last 1/10 of the data for testing - use testBase as the starting index
  testBase <- floor(nrow(letters)*9/10)
  lettersTrain <- letters[1:(split),2:17]
  lettersTest <- letters[(testBase+1):nrow(letters),2:17]
  lettersTrainLabels <- letters[1:split, 1]
  lettersTestLabels <- letters[(testBase+1):nrow(letters), 1]
  
  # Test Run #0; Train, predict, check results
  startTime<-as.POSIXlt(Sys.time(), "UTC")
  pred <- knn(train = lettersTrain, test = lettersTest, cl = lettersTrainLabels, k=11)
  print("Test Time: ")
  print(Sys.time()-startTime)
  print("Test Accuracy", out)
  print(postResample(lettersTestLabels,pred), out)
  #print(CrossTable(lettersTestLabels, pred, prop.chisq=FALSE, prop.r=FALSE, dnn=c('actual letter', 'predicted letter')),out)
}
closeAllConnections()
sink()