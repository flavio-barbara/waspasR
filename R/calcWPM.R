#' @title calcWPM
#'
#' @description Calculates the ranking for the alternative's set according to
#' WPM method
#' @param normalDb A data set object with Alternatives X Criteria with
#' normalized values
#' @param vWeights Contains a set of user assigned values to weight the criteria
#'                 The sum of these weights must add up to 1.
#'                 The format of this input is an array of values.
#'
#' @return A data frame object that contains 2 columns and the the same number
#' of rows as the input matrix. The columns "Points" has the calculated
#' relative value of each alternative whose id is in the "Alternatives" column
#'
#' @examples
#'
#' \dontrun{
#' calcWPM(normalized_matrix, vector_weights)
#' matrix_wpm <- calcWPM(normalized_matrix, vector_weights)
#' }
#' @export

# Ranking for WPM Method: normalDb Matrix  = = >  AxC_WPM Matrix
calcWPM <- function(normalDb, vWeights) {
  tryCatch({
    # Test vector of Weights X matrix of values dimentions
    if (length(vWeights) !=  ncol(normalDb)) {
      return("Error: Vector of Weights values must be same size of number of Criteria")
    }
    # Test Vector of Weights contents, it must summarize 1
    if (sum(sapply(vWeights, as.numeric)) !=  1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    # WPM Calculation loop
    points <- rep(0, nrow(normalDb))
    alternatives <- 1:nrow(normalDb)
    AxC_WPM <- cbind(points, alternatives)
    for(iCol in 1:ncol(normalDb)) {
      for(iRow in 1:nrow(normalDb)) {
        normalDb[iRow, iCol] <- toString(as.numeric(normalDb[iRow, iCol])
                                         ^ as.numeric(vWeights[iCol]))
      }}
    # calculate ranking
    for(iRow in 1:nrow(normalDb)) {
      AxC_WPM[iRow, "Points"] <- prod(sapply(normalDb[iRow, ], as.numeric))
    }
    vWPM <- AxC_WPM[, c("Alternatives", "Points")]
    return(vWPM)
  },
  error = function(cond) {
    stop(paste("E[P]", cond))
  },
  warning = function(cond) {
    if (grepl("NAs intro", cond)) {
      return("W[P] Error: Some non numeric - alike value was found")
  }
})
}
