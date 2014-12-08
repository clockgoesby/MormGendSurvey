# Create the Constants for file paths
BASE_PATH <- "C:/Users/Brent/Dropbox/Professional/Projects/R"
DATA_FOLDER <- paste(BASE_PATH, "Data", sep="/")
WORKING_FOLDER <- paste(BASE_PATH, "Working", sep="/")
DATA1 <- "MormonGenderIssues_1.csv"
DATA2 <- "MormonGenderIssues_2.csv"

# Read CSV files into R
DataIn1 <- read.csv(file=paste(BASE_PATH, DATA1, sep="/"), header=FALSE, sep=",", skip=2)
DataIn2 <- read.csv(file=paste(BASE_PATH, DATA2, sep="/"), header=FALSE, sep=",", skip=2)

# Combine files
MGISraw.all <- rbind(DataIn1, DataIn2)

# Segment completed and incomplete, output incomplete (to archive)
MGISraw.incomp <- MGISraw.all[MGISraw.all$V10==0,]
MGISraw.comp <- MGISraw.all[MGISraw.all$V10==1,]
write.csv(MGISraw.incomp, file=paste(WORKING_FOLDER,"MGISraw_incomp.csv",sep="/"))

#Delete unwanted objects
rm(DATA1, DataIn1, DATA2, DataIn2, MGISraw.all, MGISraw.incomp)

######### START CLEANING HERE, 71,265 obs, 105 variables
# Rename V1 (has a funny character in it)
names(MGISraw.comp)[1] <- 'V1'

# Add IPcnt (# of survey submitted from same IP)
ipdup.cnt <- as.data.frame(table(MGISraw.comp$V6))
names(ipdup.cnt)[1] <- "IP"
names(ipdup.cnt)[2] <- "IPcnt"
MGISraw.comp <- merge(MGISraw.comp, ipdup.cnt, by.x = "V6", by.y = "IP", all.x=TRUE)

