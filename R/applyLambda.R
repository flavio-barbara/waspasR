#' @title applyLambda
#'
#' @description Apply the lambda to assign a relative importance to each of the previously
#'              used methods (WSM and WPM). Lambda values range from zero to one.
#' @param WSM_matrix The data set object obtained from the application of the
#' @param WPM_matrix The data set object obtained from the application of the
#' @param lambda The lambda value (between 0 and 1)
#'
#' @return A data frame object that contains the alternatives set scored by and
#'   classified in descending
#'         order (from best to worst classified) according to the weighting
#'         proposed by the WASPAS method
#'         using the input lambda.
#'
#' @examples
#'
#' \dontrun{
#' applyLambda(WSM_matrix, WPM_matrix, lambda)
#' waspas_rank <- applyLambda(WSM_matrix, WPM_matrix, lambda)
#' waspas_rank <- applyLambda(WSM_matrix, WPM_matrix, 0)
#' waspas_rank <- applyLambda(WSM_matrix, WPM_matrix, 0.5)
#' waspas_rank <- applyLambda(WSM_matrix, WPM_matrix, 0.99)
#' }
#' @export

# Determines relative values according to the WASPAS method
applyLambda <- function(WSM_matrix, WPM_matrix, lambda) {
  tryCatch({
    # Test value of lambda
    if (! (as.numeric(lambda) >= 0 & as.numeric(lambda) <= 1)) {
      return("Error: The lambda's value must be between 0 and 1")
    }
    # Test WSM_matrix X WPM_matrix (size and contents)
    if (nrow(WSM_matrix) != nrow(WPM_matrix)) {
      return("Error: WSM and WPM matrices entered must have same number of rows")
    }
    # WASPAS Ranking
    waspas_matrix <- cbind(WSM_matrix,WPM_matrix[,"Points"], WASPAS=0.0)
    colnames(waspas_matrix) <- c("Alternative", "WSM_Rank","WPM_Rank","WASPAS_Rank")
    waspas_matrix[,"WASPAS_Rank"] <- waspas_matrix[,"WSM_Rank"] *
      lambda + waspas_matrix[,"WPM_Rank"] * (1-lambda)
    return(as.data.frame(waspas_matrix))
  },
  error=function(cond) {  stop(paste("E[AL]",cond))
  },
  warning=function(cond) {  stop(paste("W[AL]",cond))
  })
}
