StartTime <- Sys.time()

#### *** Load or Install RMarkdown ###############################################

  if(require('rmarkdown')){
    library('rmarkdown')
  }else{
    install.packages('rmarkdown')
    library('rmarkdown')
  }

  if(require('R.utils')){
    library('R.utils')
  }else{
    install.packages('R.utils')
    library('R.utils')
  }
##### Load or Install dplyr ###################################################
  if(require('dplyr')){
    library('dplyr')
  }else{
    install.packages('dplyr')
    library('dplyr')
  }

##### Load or Install Purrr ######################################################

  if(require('purrr')){
    library('purrr')
  }else{
    install.packages('purrr')
    library('purrr')
  }

setwd("~/Notes")

#### List all the Notes with a YAML Header =======================================
noteFiles <- c(dir(pattern="*.Rmd", recursive = TRUE),
               dir(pattern="*.md", recursive = TRUE),
               dir(pattern="*.txt", recursive = TRUE),
               dir(pattern="*.markdown", recursive = TRUE)
               )


  # Generate Symlinks

## I was playing with the idea of creating the symlinks as well
## But I don't think there is any need to do this when I could just pass
## the tags to TMSU which I've implemented in another script.
## I'll leave this in here though because it might be useful later somwehre?

gen_symlinks <- function(file) {

    for (tagDirPath in MDTags) {
        #actDirPath  <- paste0("./00Notebooks/", tagDirPath)
        actDirPath  <- paste0("~/Documents/00Notebooks/", tagDirPath)
	dir.create(path = actDirPath, recursive = TRUE)
        linkPath=paste0( actDirPath, "/", file)
          print(paste("Symlink from", file, "to", linkPath))
          createLink(link = linkPath, target = file)
       }
}

#### Run For Loop over Yaml ======================================================
# Create an empty dynamic Vector
tagVector <- c()

# Run the following code over the entire folder
c=0
for (i in noteFiles){
  c = c + 1
  yamlExtract <- yaml_front_matter(input = i )
  MDTags      <- (yamlExtract$tags)
  tagVector <- c(MDTags, tagVector)

   gen_symlinks(i) # adds a lotof time.
}
#tagVector <- flatten_chr(tagVector)

EndTime <- Sys.time()

#### Remove Repetition ===========================================================
cat("\n")
tagVector <- as.matrix(tagVector)
tagVector      <- unique(tagVector)

#### Write to a CSV ===============================================================
# Write a document containing all the tags
# write.csv(tagVector, file = "~/Desktop/YamlScript/tags.csv", quote = TRUE, row.names = FALSE)
write.csv(tagVector, file = "/tmp/00tags.csv", quote = FALSE, row.names = FALSE)


#### Optional Arguments =========================================================
# Print Statement

args <- commandArgs(trailingOnly = TRUE)
if (length(args)!=0) {
  if (args[1]=="p" | args[1]=="-p") {
    print(tagFreq)  # I could list this by frequency
  }
  if (args[1]=="--help" | args[1]=="-h") {
    print("Using the p argument will print the tags")
  }
}

print(paste(length(tagVector), "Tags Successfully Generated in ",
            round((EndTime- StartTime),3)*1000, "MilliSeconds")
            )


## Now just add the following to `.vimrc`
## imap <expr> <C-c><C-y> fzf#vim#complete('Rscript ~/bin/ListTags.R >  /dev/null 2>&1; cat /tmp/00tags.csv')


## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
