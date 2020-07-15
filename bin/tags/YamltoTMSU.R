###############################################################################
## Extract YAML tags and create text file that lists                         ##
## each command to create the corresponding tmsu tags.                       ##
##                                                                           ##
## * Create a Text file of commands so there is an opportunity to review the ##
##   commands before they are executed                                       ##
## * Don't print the tags to STDOUT because trying to fight messages         ##
##   from errors etc. becomes a PITA                                         ##
###############################################################################

StartTime <- Sys.time()

#### *** Load or Install RMarkdown ###############################################
  if(require('rmarkdown')){
    library('rmarkdown', quietly = TRUE)
  }else{
    install.packages('rmarkdown')
    library('rmarkdown', quietly = TRUE)
  }

  if(require('R.utils')){
    library('R.utils', quietly = TRUE)
  }else{
    install.packages('R.utils')
    library('R.utils', quietly = TRUE)
  }

##### Load or Install dplyr ###################################################
if(require('dplyr')){
    library('dplyr', quietly = TRUE)
  }else{
    install.packages('dplyr')
    library('dplyr', quietly = TRUE)
  }

##### Load or Install Purrr ######################################################
  if(require('purrr')){
    library('purrr', quietly = TRUE )
  }else{
    install.packages('purrr')
    library('purrr', quietly = TRUE)
  }

#### Set Working Directory (Actually Don't) =====================================

########################################################################################
## Setting the working Directory is a bit of a nuisance, there are a few options:     ##
##                                                                                    ##
##   1. Hardcode the working directory (easiest)                                      ##
##   2. Take an optional Argument (moderate)                                          ##
##   3. Set the working directory as the file location (suprisingly complicated)      ##
##                                                                                    ##
## For this reason I''ve chosen to just hardcode it, I may want to consider, however, ##
## changing this to an argument.                                                      ##
########################################################################################

args <- commandArgs(trailingOnly = TRUE)

 if (length(args)!=0) {
   if (args[1]=="--help" | args[1]=="-h") {
       print("First Argument should be the notes parent directory,
           this will go through all MD files, extract the yaml
            tags and save them in tmp`")
   } else {
       DIR <- args[1]
   }
 } else {
       DIR <- "~/Notes/MD/notes"
 }
 setwd(DIR)




#### List all the Notes with a YAML Header =======================================
   # TODO use regex not slow list building

noteFiles <-  c(dir(pattern="*.Rmd", recursive = TRUE),
                dir(pattern="*.md", recursive = TRUE),
                dir(pattern="*.txt", recursive = TRUE),
                dir(pattern="*.markdown", recursive = TRUE))

 ##########################################################################################
 ## It isnt too hard to generate symlinks corresponding to the tags, see                 ##
 ## ``~/bin/ListTags.R` but I found this to be convoluted and the results, subpar, if    ##
 ## TMSU wasnt available this would be possible though! but it would be a bit tricky :/. ##
 ##########################################################################################

#### Run For Loop over Yaml ======================================================
# Create an empty dynamic Vector
tagVector <- c()

## Run the following code over the entire folder

for (i in noteFiles){

  yamlExtract <- yaml_front_matter(input = i)
  MDTags      <- (yamlExtract$tags)
  MDTags      <- as.character(MDTags)

  ## Consider Removing the Notebooks Tag?
#  MDTags      <- gsub("Notebooks/", "", MDTags)

  ## Different tags are denoted by "/" characters and so
  ## should be seperated
  MDTags      <- unlist(strsplit(MDTags, "/", fixed = FALSE))

  ## If a note doesn't have tags then the it should not become
  ## command so only add them if it is not null
  if(!is.null(MDTags)) {

    ## Tag Names can have spaces so use '' to hide those
    ## spaces from the shell
      ## If you add quote marks it will no longer be null
      #3 So make sure to add these inside the test
    MDTags      <- paste0("'", MDTags, "'")

    MDTags      <- c(paste(i, MDTags))
  }

  ## Finally join the tags for this note to the list of all tags
  tagVector   <- c(MDTags, tagVector)
##    gen_symlinks(i) # adds a lotof time.
}


EndTime <- Sys.time()

#### Add the command prefix to the file and tags===================================
if (length(tagVector) >0 ) {
    tagVector <- as.matrix(tagVector)
} else {
    print("The Tags were not generated")
}
tagVector <- paste("tmsu tag", tagVector)

#### Add a CD Command
tagVector <- c(paste('cd', DIR), tagVector)
tagVector <- c("#!/bin/bash", tagVector)


#### Write to a CSV ===============================================================
# Write a document containing all the tags

fileLocation  <- "/tmp/00tags.sh"
write.table(tagVector, file = fileLocation, quote = FALSE,
            row.names = FALSE, col.names = FALSE)

## Tell the user that it worked
print(paste("Output saved to", fileLocation))
print(paste("You essentially want to run cat", fileLocation, "| bash"))
print("Just make sure to check over the commands that will be run")

#### Optional Arguments =========================================================
# Print Statement

args <- commandArgs(trailingOnly = TRUE)
if (length(args)!=0) {
  if (args[1]=="p" | args[1]=="-p") {
    print(tagVector)
  }
  if (args[1]=="--help" | args[1]=="-h") {
    print("Using the p argument will print the tags")
  }
}

print(paste(length(tagVector), "Tags Successfully Generated in ", round((EndTime- StartTime),3)*1000, "MilliSeconds"))




## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
