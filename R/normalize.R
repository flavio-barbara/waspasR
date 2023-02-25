#' @title normalize()
#'
#' @description Normalize the values of Alternatives X Criteria matrix
#' according to a given Cost - Benefit vector of flags.
#' @param normalized_matrix A data set object with Alternatives X Criteria
#' values to be normalized
#' @param vec_cost_benefit A vector of flags that determines if the criterion
#' is a Cost or Benefit. Must be same size of Criteria, must contains
#' just strings initiated with B, b, C or c
#'
#' @return A data frame object that contains the input matrix values normalized
#'
#' @examples
#'
#' \dontrun{
#' normalize(myMatrix, myCostBenefFlags)
#' normalized_matrix <- normalize(row_values_matrix, flags_CostBenefit)
#' }
#' @export

# Normalization: normalized_matrix Matrix into normalDb Matrix
normalize <- function(normalized_matrix, vec_cost_benefit) {
  tryCatch({
    # Test if normalized_matrix has just numeric-alike variables
    sapply(normalized_matrix, as.numeric)
    # Test vector of flags X matrix of values dimentions
    if (length(vec_cost_benefit) !=  ncol(normalized_matrix)) {
      return(paste("Error: The cost - benefit flags array must be the same size"
      , "as the number of criteria"))
    }
    # Test flags contents, just strings initiated with 'B' (Benefit)
    # or 'C' (Cost) are permitted
    just_bc <- sort(unique(toupper(substr(vec_cost_benefit, 1, 1))))
    if (!identical(just_bc, c("B", "C"))) {
      return(paste("Error: Vector of flags must contains just strings initiated"
      , "with B or C (i.e. b, c, B, C, Cost, Benefit, Ben etc.)"))
    }
    # Normalization loop
    total_rows <- nrow(normalized_matrix)
    flags <- toupper(substr(vec_cost_benefit, 1, 1))
    for (iCol in seq_len(ncol(normalized_matrix))) {
      alternative_vals <- normalized_matrix[1:total_rows, iCol]
      alternative_vals <- sapply(alternative_vals, as.numeric)
      maxv <- max(alternative_vals)
      minv <- min(alternative_vals)
      for (iRow in seq_len(nrow(normalized_matrix))) {
        if (flags[iCol] ==  "C") {  # Cost
          normalized_matrix[iRow, iCol] <-
            toString(minv / as.numeric(normalized_matrix[iRow, iCol]))
        } else {  # Benefit
          normalized_matrix[iRow, iCol] <-
            toString(as.numeric(normalized_matrix[iRow, iCol]) / maxv)
        }
      }
    }
    return(as.data.frame(normalized_matrix))
    },
  error = function(cond) {
    stop(paste("E[N]", cond))
  },
  warning = function(cond) {
    if (grepl("NAs intro", cond)) {
      return("W[N] Error: Some non numeric-alike value was found")
    }
  })
}
