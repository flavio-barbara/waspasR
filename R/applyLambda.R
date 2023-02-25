#' @title applyLambda
#'
#' @description Apply the lambda to assign a relative importance to each of the
#'   previously used methods (WSM and WPM). Lambda values range from zero to one
#' @param matrix_wsm The data set object obtained from the application of the
#' @param matrix_wpm The data set object obtained from the application of the
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
#' applyLambda(matrix_wsm, matrix_wpm, lambda)
#' waspas_rank <- applyLambda(matrix_wsm, matrix_wpm, lambda)
#' waspas_rank <- applyLambda(matrix_wsm, matrix_wpm, 0)
#' waspas_rank <- applyLambda(matrix_wsm, matrix_wpm, 0.5)
#' waspas_rank <- applyLambda(matrix_wsm, matrix_wpm, 0.99)
#' }
#' @export

# Determines relative values according to the WASPAS method
applyLambda <- function(matrix_wsm, matrix_wpm, lambda) {
  tryCatch({
    # Test value of lambda
    if (! (as.numeric(lambda) >=  0 & as.numeric(lambda) <=  1)) {
      return("Error: The lambda's value must be between 0 and 1")
    }
    # Test matrix_wsm X matrix_wpm (size and contents)
    if (nrow(matrix_wsm) !=  nrow(matrix_wpm)) {
      return("Error: WSM & WPM matrices entered must have same number of rows")
    }
    # WASPAS Ranking
    waspas_matrix <- cbind(matrix_wsm, matrix_wpm[, "points"], WASPAS = 0.0)
    colnames(waspas_matrix) <- c("Alternative"
                                 , "WSM_Rank", "WPM_Rank", "WASPAS_Rank")
    waspas_matrix[, "WASPAS_Rank"] <-
          as.numeric(waspas_matrix[, "WSM_Rank"]) * lambda  +
          as.numeric(waspas_matrix[, "WPM_Rank"]) * (1 - lambda)
    return(as.data.frame(waspas_matrix))
  },
  error = function(cond) {
    stop(paste("E[AL]", cond))
  },
  warning = function(cond) {
    if (grepl("NAs intro", cond)) {
      return("W[AL] Error: Some non numeric-alike value was found")
    }
  })
}
