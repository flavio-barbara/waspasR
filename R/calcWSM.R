#' @title calcWSM
#'
#' @description Calculates the ranking for the alternative's set according to WSM method.
#' @param AxCNorm A data set object with normalized values of Alternatives X Criteria
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
#' calcWSM(normalized_matrix, vector_weights)
#' wpm_matrix <- calcWSM(normalized_matrix, vector_weights)
#' }
#' @export

# Ranking for WSM Method: AxCNorm Matrix  ==>  AxC_WSM Matrix

calcWSM <- function(AxCNorm, vWeights) {
  tryCatch({
    # WSM Calculation loop
    Points = rep(0,nrow(AxCNorm))
    Alternatives <- 1:nrow(AxCNorm)
    AxC_WSM <- cbind(Alternatives, Points)
    # Test vector of Weights X matrix of values dimentions
    if (length(vWeights) != ncol(AxCNorm)) {
      return("Error: The weight vector must be the same size as the number of criteria")
    }
    # Test Vector of Weights contents, it must summarize 1
    if (sum(sapply(vWeights,as.numeric)) != 1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    for(iCol in 1:ncol(AxCNorm)){
      for(iRow in 1:nrow(AxCNorm)){
        AxCNorm[iRow,iCol] <- toString(as.numeric(AxCNorm[iRow,iCol])
                                             * as.numeric(vWeights[iCol]))
      }}
    # calculate ranking
    for(iRow in 1:nrow(AxCNorm)){
      AxC_WSM[iRow,"Points"] <- sum(sapply(AxCNorm[iRow,],as.numeric))
    }
    vWSM <- AxC_WSM[,c("Alternatives","Points")]
    return(vWSM)
  },
  error=function(cond) {  stop(paste("E[S]",cond))
  },
  warning=function(cond) {
    if (grepl("NAs intro", cond)){
      return("W[S] Error: Some non numeric-alike value was found")
    }
  })
}
