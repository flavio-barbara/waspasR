#' @title checkInputFormat
#'
#' @description Verify if the database to be submitted to WASPAS is correctly formated
#'
#' @param dfMatrix The original database to be validated in its format
#'
#' @return tbd
#'
#' @examples
#'
#' \dontrun{
#' checkDF <- checkInputFormat(dfMatrix)
#' checkInputFormat(dfMatrix)
#' paste("My data.frame format:",checkInputFormat(dfMatrix))
#'
#' @export

#' #################### Verify if a data.frame has the proper format to be the waspasR input database

checkInputFormat <- function(dfMatrix){
  # test flags, weights and criteria
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
  weights <- sliceData(dfMatrix,"W")
  if (sum(sapply(weights, as.numeric)) != 1) {
    return("Error: Values in Vector of Weights must summarize 1")
  }
  # Test the values
  tryCatch(
    { values <- sliceData(dfMatrix,"V")
    values <- sapply(values, as.numeric)
    },
    error=function(cond) {
      return(paste("Check the values, all must be numeric. ",cond))
    },
    warning=function(cond) {
      return(paste("Check the values, all must be numeric. ",cond))
    })
  return(TRUE)
}
