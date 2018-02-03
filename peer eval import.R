library(readxl)

#From: The path for the directory that you put all the evals in
#To: File you want your summary saved to

from <- "/Users/Randy/Desktop/PeerEval/"
summary_file <- "/Users/Randy/Desktop/peereval2.csv"

#Get a vector of all the excel files in the directory, import them into a list

evals_path <- list.files(path = from, pattern = "*.xlsx")
evals_path2 <- paste(from, evals_path, sep = "")
eval.list <- lapply(evals_path2, read_excel)

#Pick the actual evaluation part out

eval.data <- as.data.frame(eval.list[1])
real_eval <- eval.data[6:13,c(2,3,5,6)]
all.eval <- real_eval
for(i in 2:length(eval.list)){
  eval.data <- as.data.frame(eval.list[i])
  real_eval <- eval.data[6:13,c(2,3,5,6)]
  all.eval <- rbind(all.eval, real_eval)
}
test <- as.data.frame(all.eval)

#Convert the indivual scores to integers and average them

sorted <- test[order(test$EPID.301.Self.and.Peer.Evaluation.Sheet),]
sorted$X__2 <- as.integer(sorted$X__2)
sorted$X__4 <- as.integer(sorted$X__4)
sorted$X__5 <- as.integer(sorted$X__5)
sorted$total <- as.integer(sorted$X__2 + sorted$X__4 + sorted$X__5)
sortedtable <- sorted[,c(1,5)]
sortedtable$EPID.301.Self.and.Peer.Evaluation.Sheet <- as.factor(sortedtable$EPID.301.Self.and.Peer.Evaluation.Sheet)
total_marks <- aggregate(total~EPID.301.Self.and.Peer.Evaluation.Sheet, sortedtable, mean)

#Write the summary file

write.csv(total_marks, file = summary_file)
