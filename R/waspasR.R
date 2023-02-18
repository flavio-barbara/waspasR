#' @title waspasR()
#'
#' @description Normalize the values of Alternatives X Criteria matrix according to a given
#'              Cost-Benefit vector of flags.
#'              There are two ways to input the values:
#'              (a) The "All in One" format is a data.frame matrix with all the WSM, WPM and WASPAS data
#'              and metadata, in this case the parameter vCostBenefit can be null.
#'              (b) The "Simple" format is a data.frame matrix with just the values of Alternatives x Criteria,
#'              in this case the vector of Cost-Benefit flags must be entered in the parameter vCostBenefit.
#'              and metadata.
#' @param dfMatrix A data set object with Alternatives X Criteria  values to be normalized
#' @param vCostBenefit A vector of flags that determines if the criterion is a Cost or Benefit one
#'              Must be same size of Criteria, must contains just strings initiated with B, b, C or c
#' @param dataFormat Defines how the functions will deal with the input values. There are two possible values:
#'              "All-in-One" (wich is the same that the values 1) or "simple"  (wich is the same as 2),
#'              if ommited the function will assume the All-in-one format.
#'
#' @return A data frame object that contains the input matrix with its values normalized.
#'
#' @examples
#' normalize(myAllInOneMatrix)
#' normalized_matrix <- normalize(row_values_matrix, flags_CostBenefit, dataFormat = "simple")
#'
#' @export

#' #################### Normalization: dfMatrix Matrix  ==>  AxCNorm Matrix

waspasR <- function(dfMatrix, lambda) {
  # Slice the raw data into specific objects
  alternatives <- sliceData(choppers,"A")
  criteria <- sliceData(choppers,"C")
  weights <- sliceData(choppers,"W")
  flags <- sliceData(choppers,"F")
  values <- sliceData(choppers,"V")
  # Normalize values
  normalized <- normalize(values, flags, dataFormat = "Simple")
  # Calculate WSM and WPN
  wsm <- calcWSM(normalized, weights)
  wpm <- calcWPM(normalized, weights)
  # Apply lambda to get WASPAS
  waspas <- applyLambda(wsm, wpm, lambda)
  # Bind all the stuff
  waspas_matrix <- data.frame(matrix(nrow = nrow(alternatives)+2,ncol = ncol(criteria)+4))
  colnames(waspas_matrix) <- cbind("alternatives", criteria, "WSM_Rank","WPM_Rank","WASPAS_Rank")
  waspas_matrix[1,1]="W"
  waspas_matrix[1,1:ncol(weights)+1] = weights
  waspas_matrix[2,1]="F"
  waspas_matrix[2,1:ncol(flags)+1] = flags
  waspas_matrix[3:nrow(waspas_matrix), 1] = alternatives
  waspas_matrix[3:nrow(waspas_matrix), 1:ncol(values)+1] <- values
  waspas_matrix[3:nrow(waspas_matrix), "WSM_Rank"] <- waspas[,"WSM_Rank"]
  waspas_matrix[3:nrow(waspas_matrix), "WPM_Rank"] <- waspas[,"WPM_Rank"]
  waspas_matrix[3:nrow(waspas_matrix), "WASPAS_Rank"] <- waspas[,"WASPAS_Rank"]
  return(as.data.frame(waspas_matrix))
}
