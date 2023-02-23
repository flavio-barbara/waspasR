#' @title calcWPM
#'
#' @description Calculates the ranking for the alternative's set according to WPM method
#' @param AxCNorm A data set object with Alternatives X Criteria with normalized values
#' @param vWeights Contains a set of user-assigned values to weight the criteria.
#'                 The sum of these weights must add up to 1.
#'                 The format of this input is an array of values.
#'
#' @return A data frame object that contains 2 columns and the the same number of rows as
#'        the input matrix. The columns "Points" has the calculated relative value of each
#'        alternative whose id is in the "Alternatives" column.
#'
#' @examples
#'
#' \dontrun{
#' calcWPM(normalized_matrix, vector_weights)
#' wpm_matrix <- calcWPM(normalized_matrix, vector_weights)
#' }
#' @export

# Ranking for WPM Method: AxCNorm Matrix  ==>  AxC_WPM Matrix
calcWPM <- function(AxCNorm, vWeights) {
  tryCatch({
    # Test vector of Weights X matrix of values dimentions
    if (length(vWeights) != ncol(AxCNorm)) {
      return("Error: Vector of Weights values must be same size of number of Criteria")
    }
    # Test Vector of Weights contents, it must summarize 1
    if (sum(sapply(vWeights, as.numeric)) != 1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    # WPM Calculation loop
    Points <- rep(0,nrow(AxCNorm))
    Alternatives <- 1:nrow(AxCNorm)
    AxC_WPM <- cbind(Points, Alternatives)
    for(iCol in 1:ncol(AxCNorm)){
      for(iRow in 1:nrow(AxCNorm)){
        AxCNorm[iRow,iCol] <- toString(as.numeric(AxCNorm[iRow,iCol])
                                             ^ as.numeric(vWeights[iCol]))
      }}
    # calculate ranking
    for(iRow in 1:nrow(AxCNorm)){
      AxC_WPM[iRow,"Points"] <- prod(sapply(AxCNorm[iRow,],as.numeric))
    }
    vWPM <- AxC_WPM[,c("Alternatives", "Points")]
    return(vWPM)
},
error=function(cond) {  stop(paste("E[P]",cond))
},
warning=function(cond) {  stop(paste("W[P]",cond))
})
}
