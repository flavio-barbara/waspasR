#' @title waspasR()
#'
#' @description Runs the complete process from slicing the original database,
#'    processing all the computational steps, like computing WSM and WPM formulas,
#'    applying the lambda as proposed by the method WASPAS, and the building the
#'    comp.ete output in a new data.frame with the criteria as column names,
#'    all the original data and appending 3 new columns with the WSM, WPM and
#'    WASPAS ranking ("WSM_Rank","WPM_Rank","WASPAS_Rank").
#'
#' @param dfMatrix The original data set in a proper format. The format can be
#'    checked by checkInputFormat() function.
#'
#' @param lambda The lambda value (between 0 and 1)
#'
#' @return A data.frame object that contains the input matrix with its values
#'    normalized. Or an error message if some bad data is entered.
#'
#' @examples
#'
#' \dontrun{
#' waspas_set <- waspasR(chopper, lambda = 0.23)
#' waspas_set <- waspasR(myRawData, lambda = 0.8)
#' }
#' @export

# Putting everything togheter
waspasR <- function(dfMatrix, lambda) {
  # Test the normalization
  #browser()
  tryCatch({
    # Slice the raw data into specific objects
    alternatives <- sliceData(dfMatrix,"A")
    criteria <- sliceData(dfMatrix,"C")
    weights <- sliceData(dfMatrix,"W")
    flags <- sliceData(dfMatrix,"F")
    values <- sliceData(dfMatrix,"V")
    # Normalize values
    normalized <- normalize(values, flags)
    # If something went wrong just stops
    if (is.character(normalized)) return(normalized)    # Calculate WSM and WPN
  },
  error=function(cond) {  stop(paste("E[WN]",cond))
  },
  warning=function(cond) {  stop(paste("W[WN]",cond))
  })
  # Test the methods calculations
  tryCatch({
    wsm <- calcWSM(normalized, weights)
    wpm <- calcWPM(normalized, weights)
    # If something went wrong just stops
    if (is.character(wsm)) return(wsm)
    # Apply lambda to get WASPAS
    waspas <- applyLambda(wsm, wpm, lambda)
  },
  error=function(cond) {  stop(paste("E[WC]",cond))
  },
  warning=function(cond) {  stop(paste("W[WC]",cond))
  })
  # Test the output database building
  tryCatch({
    # Bind all the stuff
    waspas_matrix <- data.frame(matrix(nrow = nrow(dfMatrix)-1, ncol = ncol(dfMatrix)+3))
    colnames(waspas_matrix) <- cbind("alternatives", criteria, "WSM_Rank","WPM_Rank","WASPAS_Rank")
    waspas_matrix[1,1]="W"
    waspas_matrix[1,1:ncol(weights)+1] <- weights
    waspas_matrix[2,1]="F"
    waspas_matrix[2,1:ncol(flags)+1] <- flags
    waspas_matrix[3:nrow(waspas_matrix), 1] <- t(alternatives)
    waspas_matrix[3:nrow(waspas_matrix), 1:ncol(values)+1] <- values
    waspas_matrix[3:nrow(waspas_matrix), "WSM_Rank"] <- waspas[,"WSM_Rank"]
    waspas_matrix[3:nrow(waspas_matrix), "WPM_Rank"] <- waspas[,"WPM_Rank"]
    waspas_matrix[3:nrow(waspas_matrix), "WASPAS_Rank"] <- waspas[,"WASPAS_Rank"]
    return(as.data.frame(waspas_matrix))
  },
  error=function(cond) {  stop(paste("E[WB]",cond))
  },
  warning=function(cond) {  stop(paste("W[WB]",cond))
  })
}
