#' @title calcWPM
#'
#' @description Calculates the ranking for the alternative's set according to
#' WPM method
#' @param normal_db A data set object with normalized values of
#' Alternatives X Criteria
#' @param vec_weights Contains a set of user assigned values to weight
#' the criteria.
#' The sum of these weights must add up to 1.
#' The format of this input is an array of values.
#'
#' @return A data frame object that contains 2 columns and the the same number
#' of rows as the input matrix. The columns "WPM_Rank" has the calculated
#' relative value of each alternative whose id is in the "Alternative" column
#'
#' @export

# Ranking for WPM Method: normal_db Matrix into wpm Matrix

calcWPM <- function(normal_db, vec_weights) {
  tryCatch({
    # Test vector of Weights X matrix of values dimentions
    if (length(vec_weights) !=  ncol(normal_db)) {
      return(paste("Error: The weight vector must be the same size as"
      , "the number of criteria"))
    }
    # Test Vector of Weights contents, it must summarize 1
    if (sum(sapply(vec_weights, as.numeric)) !=  1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    # WPM Calculation loop
    WPM_Rank <- rep(0, nrow(normal_db))
    Alternative <- seq_len(nrow(normal_db))
    wpm <- cbind(Alternative, WPM_Rank)
    for (iCol in seq_len(ncol(normal_db))) {
      for (iRow in seq_len(nrow(normal_db))) {
        normal_db[iRow, iCol] <- toString(as.numeric(normal_db[iRow, iCol])
                                          ^ as.numeric(vec_weights[iCol]))
      }
    }
    # calculate ranking
    for (iRow in seq_len(nrow(normal_db))) {
      wpm[iRow, "WPM_Rank"] <- prod(sapply(normal_db[iRow, ], as.numeric))
    }
    wpm_db <- wpm[, c("Alternative", "WPM_Rank")]
    return(wpm_db)
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
