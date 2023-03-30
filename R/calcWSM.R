#' @title calcWSM
#'
#' @description Calculates the ranking for the alternative's set according to
#' WSM method.
#' @param normal_db A data set object with normalized values of
#' Alternatives X Criteria
#' @param vec_weights Contains a set of user assigned values to weight
#' the criteria.
#' The sum of these weights must add up to 1.
#' The format of this input is an array of values.
#'
#' @return A data frame object that contains 2 columns and the the same number
#' of rows as the input matrix. The column "WSM_Rank" has the calculated
#' relative value of each alternative whose id is in the "Alternative" column
#'
#' @export

# Ranking for WSM Method: normal_db Matrix into wsm Matrix

calcWSM <- function(normal_db, vec_weights) {
  tryCatch({
    # Test vector of Weights X matrix of values dimentions
    if (length(vec_weights) !=  ncol(normal_db)) {
      return(paste("Error: The weight vector must be the same size as the"
      , "number of criteria"))
    }
    # Test Vector of Weights contents, it must summarize 1
    if (sum(sapply(vec_weights, as.numeric)) !=  1) {
      return("Error: Values in Vector of Weights must summarize 1")
    }
    # WSM Calculation loop
    WSM_Rank <- rep(0, nrow(normal_db))
    Alternative <- seq_len(nrow(normal_db))
    wsm <- cbind(Alternative, WSM_Rank)
    for (iCol in seq_len(ncol(normal_db))) {
      for (iRow in seq_len(nrow(normal_db))) {
        normal_db[iRow, iCol] <- toString(as.numeric(normal_db[iRow, iCol])
                                          * as.numeric(vec_weights[iCol]))
      }
    }
    # calculate ranking
    for (iRow in seq_len(nrow(normal_db))) {
      wsm[iRow, "WSM_Rank"] <- sum(sapply(normal_db[iRow, ], as.numeric))
    }
    wsm_db <- wsm[, c("Alternative", "WSM_Rank")]
    return(wsm_db)
  },
  error = function(cond) {
    stop(paste("E[S]", cond))
  },
  warning = function(cond) {
    if (grepl("NAs intro", cond)) {
      return("W[S] Error: Some non numeric - alike value was found")
    }
  })
}
