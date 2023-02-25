##############################################################################
# Source:                                                                    #
#   https://www.mzes.uni - mannheim.de/socialsciencedatalab/article/r - package/ #
#                                                                            #
#   https://iqss.github.io/dss - rbuild/package - development.html               #
##############################################################################



# GIT Stuff - to run in Terminal tab

# git remote add origin https://github.com/flavio - barbara/waspasR.git
# (add all to commit)
# git add *
# git commit  - m "Just temporary local commit"
# git push  - u origin master
# git diff
# (remove a file from git, exemple removing NAMESPACE)
# git rm NAMESPACE

# manuals
devtools::document(pkg = ".", roclets = NULL, quiet = FALSE)
?applyLambda
?calcWPM
?calcWSM
?checkInputFormat
?choppers
?normalize
?sliceData
?waspasR

# News
usethis::use_news_md(open = rlang::is_interactive())

# vignette
usethis::use_vignette("waspas-in-a-nutshell", "WASPAS in a nutshell")

# Generate the test environment
usethis::use_testthat()

# CRAN cheks
# # The following function runs a local R CMD check
devtools::check()
devtools::check_rhub()
devtools::check_win_devel()
# Update your NEWS file
# Update DESCRIPTION (e.g. version number)
devtools::spell_check(pkg = ".", vignettes = TRUE, use_wordlist = FALSE)


#install MY PACK :D
.rs.restartR()
detach("package:waspasR", unload = TRUE)
install.packages('C:/Users/flavi/waspasR_0.1.0.tar.gz', repos = NULL, type = 'source')
library(waspasR)
data("choppers")
myc<- choppers
myc[2, 2]<- "cu"
myc[2, 2]<- "1.06"
myc[2, 2]<- "0.06"
myc[4, 2]<- "cu"
myc[4, 2]<- "20964933"



install.packages("pkgdown")

usethis::use_news_md(open = rlang::is_interactive())

usethis::use_vignette("waspas - in - a - nutshell", "WASPAS in a nutshell")

# Run all tests - development
.rs.restartR()
devtools::test()

# If an error occurs run detach command first, then test_coverage
detach("package:waspasR", unload = TRUE)
devtools::test_coverage()

# The following function runs a local R CMD check
devtools::check()

# Check for CRAN specific requirements
######## ATENÇÃO!!! - -  - > demora 12 horas roda logo o results<- check
# rhub::check_for_cran()

# Check for win - builder
devtools::check_win_devel()
#
# # install MiKTeX if a pdf error occurs
# https://miktex.org/download
# # check the path
Sys.getenv("PATH")
# C:/Users/flavi/AppData/Local/Programs/MiKTeX/miktex/bin/x64
Sys.setenv(PATH = paste(Sys.getenv("PATH"), "C:/Users/flavi/AppData/Local/Programs/MiKTeX/miktex/bin/x64", sep = ";"))
# Check for CRAN specific requirements using rhub and save it in the results objects

######## ATENÇÃO!!! - -  - > demora mais de 12 horas !!! #########
results <- rhub::check_for_cran()

# Get the summary of your results
results$cran_summary()

# Generate your cran - comments.md, then you copy - paste the output from the function above
usethis::use_cran_comments()

# add to .Rbuildignore
usethis::use_build_ignore(c("results"))
usethis::use_build_ignore(c("sketch.R"))

# Checking for good practice ######## ATENÇÃO!!! - -  - > demora
library(goodpractice)
goodpractice::gp()
# good practice II
install.packages("remotes")
remotes::install_github("jumpingrivers/inteRgrate")
check_pkg() ###>>> Demora um pouco
check_lintr()
check_tidy_description()
usethis::use_tidy_description()
check_r_filenames()
check_gitignore()
check_version()

library(covr) # Test Coverage for Packages
covr::codecov(token = "311e9d7d - 874b - 4718 - 90c9 - d81f11c898ac")


# Test of functions ~~~~~~~~~~~~~~~~~~~~
data(choppers)    # Dataset
# save(choppers, file = "data/choppers.RData")
checkInputFormat(choppers)
alternatives <- sliceData(choppers, "A")
criteria <- sliceData(choppers, "C")
weights <- sliceData(choppers, "W")
flags <- sliceData(choppers, "F")
values <- sliceData(choppers, "V")
norm_matrix <- normalize(values, flags)
wsm <- calcWSM(norm_matrix, weights)
wpm <- calcWPM(norm_matrix, weights)
mywaspas <- applyLambda(wsm, wpm, lambda = 0.5)
# Complete Test ~~~~~~~~~~~~~~~~~~~~
a <- waspasR(choppers, 0.23)
b <- a[3:nrow(a), c("alternatives", "WASPAS_Rank")]
b <- b[order(b[, 2], decreasing = TRUE), ]
head(b)
# END of Test of functions ~~~~~~~~~~~~~~~~~~~~ END

#SANDBOX *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~
# library(readxl)
# library(writexl)
#
# myChoppers <- read_excel("data/WASPAS_Data_chopper.xlsx", col_names = F)
# write.csv(sampleDataSet, "data/sampleDataSet.csv", row.names = FALSE)
# sampleDataSet <- read.csv("data/sampleDataSet.csv", header = TRUE, sep = ", ", quote = "\"")

# save(choppers, file = "data/waspas_choppers.RData")
# Matrix <- xlsx[4:nrow(xlsx), 2:ncol(xlsx)]
# vetpesos<- xlsx[2, 2:ncol(xlsx)]
# norm_matrix <- normalize(Matrix, vetpesos, initCol = 1, initRow = 1)
# write_xlsx(choppers, "./datachoppers.xlsx")
# edit(choppers)
# choppers <- readRDS("data/waspas_choppers.RData")
# choppers[1, 1] <- ifelse(choppers[1, 1] = =  "Flavio", "F", "Flavio")
# saveRDS(choppers, file = "data/waspas_choppers.RData")

