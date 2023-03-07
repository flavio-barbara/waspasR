#' @title waspasR()
#'
#' @description Runs the complete process from slicing the original database,
#'    processing all the computational steps, like computing WSM and WPM
#'    formulas, applying the lambda as proposed by the method WASPAS, and the
#'    building the complete output in a new data.frame with the criteria as
#'    column names, all the original data and appending 3 new columns with
#'    the WSM, WPM and WASPAS ranking ("WSM_Rank", "WPM_Rank", "WASPAS_Rank").
#'
#' @param waspas_df The original data set in a proper format. The format can be
#'    checked by checkInputFormat() function.
#'
#' @param lambda The lambda value (between 0 and 1)
#'
#' @return A data.frame object that contains the input matrix with its values
#'    normalized. Or an error message if some bad data is entered.
#'
#' @examples
#'
#' \donttest{
#' waspas_set <- waspasR(chopper, lambda = 0.23)
#' waspas_set <- waspasR(myRawData, lambda = 0.8)
#' }
#' @export

# Putting everything togheter
waspasR <- function(waspas_df, lambda) {
  # Test the entered data
  if (missing(waspas_df)) return("Parameter waspas_df is missing")
  if (missing(lambda)) return("Parameter lambda is missing")
  format_ok <- checkInputFormat(waspas_df)
  if (is.character(format_ok))
    return(format_ok)
  # Slice the raw data into specific objects
  alternatives <- sliceData(waspas_df, "A")
  criteria <- sliceData(waspas_df, "C")
  weights <- sliceData(waspas_df, "W")
  flags <- sliceData(waspas_df, "F")
  values <- sliceData(waspas_df, "V")
  # Normalize values
  normalized <- normalize(values, flags)
  # Run the methods calculations
  wsm <- calcWSM(normalized, weights)
  wpm <- calcWPM(normalized, weights)
  # Apply lambda to get WASPAS
  waspas <- applyLambda(wsm, wpm, lambda)
  # Bind all the stuff
  waspas_matrix <- data.frame(matrix(nrow = nrow(waspas_df) - 1
                                     , ncol = ncol(waspas_df) + 3))
  colnames(waspas_matrix) <- cbind("alternatives", criteria
                                   , "WSM_Rank", "WPM_Rank", "WASPAS_Rank")
  qtd_rows <- nrow(waspas_matrix)
  qtd_cols_weights <- ncol(weights) + 1
  qtd_cols_flags <- ncol(flags) + 1
  qtd_cols_values <- ncol(values) + 1
  waspas_matrix[1, 1] <- "W"
  waspas_matrix[1, 2:qtd_cols_weights] <- weights
  waspas_matrix[2, 1] <- "F"
  waspas_matrix[2, 2:qtd_cols_flags] <- flags
  waspas_matrix[3:qtd_rows, 1] <- t(alternatives)
  waspas_matrix[3:qtd_rows, 2:qtd_cols_values] <- values
  waspas_matrix[3:qtd_rows, "WSM_Rank"] <- waspas[, "WSM_Rank"]
  waspas_matrix[3:qtd_rows, "WPM_Rank"] <- waspas[, "WPM_Rank"]
  waspas_matrix[3:qtd_rows, "WASPAS_Rank"] <- waspas[, "WASPAS_Rank"]
  return(as.data.frame(waspas_matrix))
}
