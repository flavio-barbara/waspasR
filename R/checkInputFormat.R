#' @title checkInputFormat
#'
#' @description Verify if the database to be submitted to WASPAS is correctly
#' formatted
#'
#' @param waspas_db The original database to be validated in its format
#'
#' @return True if everything is OK, an error message in case of bad format
#'
#' @export

# Verify if a data.frame has the proper format to be the waspasR input database
checkInputFormat <- function(waspas_db) {
  if (missing(waspas_db)) return("Parameter waspas_db is missing")
  if (!is.data.frame(waspas_db))
    return("Parameter waspas_db must be a data.frame")
  tryCatch({
    # test indicators: Flags, Weights and Criteria
    proc_step <- "Indicators"
    indicators <- c("C","F","W")
    i1 <- toupper(substr(toString(waspas_db[1,1]), 1, 1))
    i2 <- toupper(substr(toString(waspas_db[2,1]), 1, 1))
    i3 <- toupper(substr(toString(waspas_db[3,1]), 1, 1))
    indicators_uploaded <- sort(c(i1, i2, i3))
    if (!identical(indicators, indicators_uploaded)) stop()
    # Test flags contents, just strings initiated with B (Benefit) ou
    #  C (Cost) are permitted
    flags <- sliceData(waspas_db, "F")
    just_bc <- sort(unique(toupper(substr(flags, 1, 1))))
    proc_step <- "Flags"
    if (!identical(just_bc, c("B", "C"))) stop()
    # Test Vector of Weights contents, it must summarize 1
    proc_step <- "Weights-1"
    weights <- sliceData(waspas_db, "W")
    weights <- sapply(weights, as.numeric)
    proc_step <- "Weights-2"
    if (sum(weights) !=  1) stop()
    # Test the values (if waspas_db has just numeric - alike variables)
    proc_step <- "Values"
    values <- sliceData(waspas_db, "V")
    values <- sapply(values, as.numeric)
    if (sum(is.na(values)) > 0) stop()
    proc_step <- "End"
    # No return here due to use of "finally" # return(TRUE)
  },
  error = function(cond) {
    stop(paste("E[CI]", cond))
  },
  warning = function(cond) {
    if (grepl("NAs intro", cond)) {
      # Some non numeric - alike variable
      # will be dealt with in the "finally" clause
    }
  },
  finally = {
    if (proc_step ==  "Indicators") {
      return(paste("Error: Check the indicators in cells [1:3, 1], the strings"
                   , " must be intiated with 'C', 'F' or 'W'"))
    } else if (proc_step ==  "Flags") {
      return(paste("Error: Vector of flags must contains just strings initiated"
      , "with B or C (i.e. b, c, B, C, Cost, Benefit, Ben etc.)"))
    } else if (proc_step ==  "Weights-1") {
      return("Error: Check Weights values, all must be numeric")
    } else if (proc_step ==  "Weights-2") {
      return("Error: Values in Vector of Weights must summarize 1")
    } else if (proc_step ==  "Values") {
      return("Error: Check Aternatives x Criteria values, all must be numeric")
    } else {
      return(TRUE)
    }
  })
}
