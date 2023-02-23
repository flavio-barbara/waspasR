#' @title checkInputFormat
#'
#' @description Verify if the database to be submitted to WASPAS is correctly formatted
#'
#' @param dfMatrix The original database to be validated in its format
#'
#' @return True if everything is OK, an error message in case of bad format
#'
#' @examples
#'
#' \dontrun{
#' checkDF <- checkInputFormat(dfMatrix)
#' checkInputFormat(dfMatrix)
#' paste("My data.frame format:",checkInputFormat(dfMatrix))
#' }
#' @export

# Verify if a data.frame has the proper format to be the waspasR input database
checkInputFormat <- function(dfMatrix){
  tryCatch({
    # test flags, weights and criteria
    procStep <- "Flags"
    for(iRow in 1:3){
      flag <- toupper(substr(dfMatrix[iRow,1], 1, 1))
      if (!(flag %in% c("F","W","C"))){
        return("Error: Check the indicators in cells [1:3, 1], they must be 'C', 'F' or 'W'")
      }
    }
    # Test flags contents, just strings initiated with B (Benefit) ou C (Cost) are permitted
    flags <- sliceData(dfMatrix,"F")
    justBorC <- sort(unique(toupper(substr(flags,1,1))))
    if (!identical(justBorC, c("B","C"))) {
      return("Error: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
    }
    # Test Vector of Weights contents, it must summarize 1
    procStep <- "Weights"
    weights <- sliceData(dfMatrix,"W")
    weights <- sapply(weights, as.numeric)
    if (sum(weights) != 1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    # Test the values (if dfMatrix has just numeric-alike variables)
    procStep <- "Values"
    values <- sliceData(dfMatrix,"V")
    values <- sapply(values, as.numeric)
    procStep <- "End"
    # No return here due to use of "finally" # return(TRUE)
  },
  error=function(cond) {  stop(paste("E[CI]",cond))
  },
  warning=function(cond) {
    if (grepl("NAs intro", cond)){
      # Some non numeric-alike variable
      # will be dealt with in the "finally" clause
    }else{
      message(paste("W[CI]",cond))
    }
  },
  finally = {
    if (procStep == "Weights"){
      return("Error: Check Weights values, all must be numeric")
    }else if (procStep == "Values"){
      return("Error: Check Aternatives x Criteria values, all must be numeric")
    }else{
      return(TRUE)
    }
  })
}
