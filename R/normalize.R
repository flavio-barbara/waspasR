#' @title normalize()
#'
#' @description Normalize the values of Alternatives X Criteria matrix according to a given
#'              Cost-Benefit vector of flags.
#' @param dfMatrix A data set object with Alternatives X Criteria  values to be normalized
#' @param vCostBenefit A vector of flags that determines if the criterion is a Cost or Benefit one
#'              Must be same size of Criteria, must contains just strings initiated with B, b, C or c
#'
#' @return A data frame object that contains the input matrix values normalized.
#'
#' @examples
#'
#' \dontrun{
#' normalize(myMatrix, myCostBenefFlags)
#' normalized_matrix <- normalize(row_values_matrix, flags_CostBenefit)}
#'
#' @export

#' #################### Normalization: dfMatrix Matrix  ==>  AxCNorm Matrix

normalize <- function(dfMatrix, vCostBenefit) {
  # Test vector of flags X matrix of values dimentions
  if (length(vCostBenefit) != ncol(dfMatrix)) {
    return("Error: Vector of Cost-Benefit flags must be same size of number of Criteria")
  }
  # Test flags contents, just strings initiated with B (Benefit) ou C (Cost) are permitted
  justBorC <- sort(unique(toupper(substr(vCostBenefit,1,1))))
  if (!identical(justBorC, c("B","C"))) {
    return("Error: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
  }
  # Normalization loop
  flagsCxB <- toupper(substr(vCostBenefit,1,1))
  for(iCol in 1:ncol(dfMatrix)){
    vAlternativeValues <- dfMatrix[1:lastRow,iCol]
    vAlternativeValues <- sapply(vAlternativeValues, as.numeric)
    maxv <- max(vAlternativeValues)
    minv <- min(vAlternativeValues)
    for(iRow in 1:nrow(dfMatrix)){
      if (flagsCxB[iCol] == "C"){  # Cost-Benefit == "C" (Cost)
        dfMatrix[iRow,iCol] <- toString(minv / as.numeric(dfMatrix[iRow,iCol]))
      } else {  # Cost-Benefit == "B" (Benefit)
        dfMatrix[iRow,iCol] <- toString(as.numeric(dfMatrix[iRow,iCol]) / maxv)
      }
    }}
  return(as.data.frame(dfMatrix))
}
