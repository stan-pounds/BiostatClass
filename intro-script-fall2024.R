#######################################
# The hashtag # in R
# The hashtag tells R "Ignore this comment written for humans."
# If a line starts with a hashtag, R ignores the entire line.
# R also ignores everything to the right of a hashtag in the middle of a line.
# Use hashtags to tell humans (including yourself) what you're trying to do.

# R tries to do everything it is told on lines with no hashtag.
# R also tries to do everything it is told on a line to the left of a hashtag.





####################################
# Source the SBP code into R
# In EACH R session, this must be done BEFORE using SBP

sbp.link="https://raw.githubusercontent.com/stan-pounds/Simple-Biostats-Program/main/setup-SBP.R"
source(sbp.link)



########################################
# Be sure to have the utils package for the download and choose.dir functions

get.package("utils") 

# if this doesn't work, it means source(sbp.link) didn't work
# double-check the WiFi connection and try these two sections again



########################################
# use R to download the Excel file with example data sets

local.dir=choose.dir()  # choose the directory where you want to save the example data sets
                        # the directory selection window may be behind other windows

dset.link="https://github.com/stan-pounds/BiostatClass/raw/master/Biostat-Class-DataSets-Fall2023.xlsx"
local.file=paste0(local.dir,"\\",basename(dset.link))
download.file(dset.link,local.file,mode="wb")

# you should see a progress bar for the download pop-up briefly
# you should see the file Biostat-Class-DataSets-Fall2023.xlsx in your chosen directory






#####################################
# Alternative Approach to Obtain Example Data Sets
#
# Visit https://github.com/stan-pounds/BiostatClass/blob/master/Biostat-Class-DataSets-Fall2023.xlsx
# Click the download icon, choose local directory to save the file





#####################################
# Read the nki70 data set from Excel into R

nki70=read.data()

# choose the file Biostat-Class-DataSets-Fall2023.xlsx that you just saved
# choose the penalized.nki70 data set
# selection window may be "behind" another window

# if you get an error, please notify the instructor
# you'll need some technical settings changed on your computer before going home
# don't panic, you may still continue with the rest of the exercise
# you should still be able to get the data in the next code section
  





####################################
# Technical back-up option to get nki70 data set
# Skip this if you already see the nki70 data set in R studio

obj.list=ls()
if (!"nki70"%in%obj.list)   
{
  warning("Getting nki70 data a different way.")
  warning("Please notify your instructor.")
  
  get.packages("penalized")
  library(penalized)
  data(nki70)
}
View(nki70)





##########################################
# Get documentation for the nki70 data set from the R package "penalized"

get.packages("penalized")
help(nki70)

# We will point you to data set documentation for examples & homework
# In your own research, you should document your own data sets.






####################################
# Descriptive stats, figures, and narrative for age (a numeric variable)

describe(Age,nki70)                     # default
describe(Age,nki70,fig=2)               # more figures
describe(Age,nki70,fig=3)               # even more figures
describe(Age,nki70,fig=2,clr="skyblue") # figures with skyblue color

# requires EXACT spelling and capitalization of data set and column name
# data set name: nki70; column name: Age
# must use quotes for column name; must match name in R exactly





####################################
# How do I know the names of colors available in R?
# Show available color names in R

show.colors()






####################################
# Descriptives for tumor grade (an ordered category variable)

describe(Grade,nki70)                 # default
describe(Grade,nki70,fig=2)           # more figures
describe(Grade,nki70,clr="Tropic")    # use the "Tropic" color palette
describe(Grade,nki70,clr="Spectral")  # use the "Spectral" color palette







####################################
# show available color palettes in R

show.palettes(3)  # palettes of 3 colors
show.palettes(4)  # palettes of 4 colors
show.palettes(10) # palettes of 10 colors





###################################
# Don't freak out if you get errors in R.
# Everyone who uses R gets errors.
# Dr. Pounds has been using R for over two decades.
# He has developed and published extensions of R.
# He still gets many many errors every time he uses R.
# Errors are usually just typos.
# So for practice, Run these lines with errors, fix the typos, run them again.

describe(age,nki70)         # capitalize Age
describe(Age,nki70,fg=2)    # should be fig=2 instead of fg=2
describe(Age;nki70)         # should be comma instead of semi-colon
describe(Age,nki70,clr=red) # color name "red" must be in quotes







###############################
# If time permits:
# 
# compute descriptive stats and graphs of the ER column of the nki70 data
# compute descriptive stats and graphs of the BBC column of the nki70 data
# choose your own colors for the figures
# try other options: txt=0, txt=1, txt=2, tbl=0, tbl=1, tbl=2





