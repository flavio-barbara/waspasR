#' @title normalize()
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
#'              "All-in-One" (which is the same that the values 1) or "simple" (which is the same as 2),
#'              if omitted the function will assume the All-in-one format.
#'
#' @return A data frame object that contains the input matrix with its values normalized.
#'
#' @examples
#'
#' \dontrun{
#' normalize(myAllInOneMatrix)
#' normalized_matrix <- normalize(row_values_matrix, flags_CostBenefit, dataFormat = "simple")}
#'
#' @export

#' #################### Normalization: dfMatrix Matrix  ==>  AxCNorm Matrix

normalize <- function(dfMatrix, vCostBenefit, dataFormat = "all-in-one") {
  # if the format of input matrix is All-in-one (vCostBenefit may be null)
  if (dataFormat == 1 | tolower(dataFormat) =="all-in-one"){
    vCostBenefit <- sliceData(dfMatrix, "F")
    workingMatrix <- sliceData(dfMatrix, "V")
  }else if (dataFormat == 2 | tolower(dataFormat) =="simple"){
    workingMatrix <- dfMatrix
  }else{
    return("Error #21: Parameter dataFormat must be 1 / 'All-inone' or 2 / 'Simple")
  }
  # Test vector of flags X matrix of values dimentions
  if (length(vCostBenefit) != ncol(workingMatrix)) {
    return("Error #01: Vector of Cost-Benefit flags must be same size of number of Criteria")
  }
  # Test flags contents, just strings initiated with B (Benefit) ou C (Cost) are permitted
  justBorC <- sort(unique(toupper(substr(vCostBenefit,1,1))))
  if (!identical(justBorC, c("B","C"))) {
    return("Error #02: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
  }
  # Normalization loop
  flagsCxB <- toupper(substr(vCostBenefit,1,1))
  for(iCol in 1:ncol(workingMatrix)){
    vAlternativeValues <- workingMatrix[1:nrow(workingMatrix),iCol]
    vAlternativeValues <- sapply(vAlternativeValues, as.numeric)
    maxv <- max(vAlternativeValues)
    minv <- min(vAlternativeValues)
    for(iRow in 1:nrow(workingMatrix)){
      if (flagsCxB[iCol] == "C"){  # Cost-Benefit == "C" (Cost)
        workingMatrix[iRow,iCol] <- toString(minv / as.numeric(workingMatrix[iRow,iCol]))
      } else {  # Cost-Benefit == "B" (Benefit)
        workingMatrix[iRow,iCol] <- toString(as.numeric(workingMatrix[iRow,iCol]) / maxv)
      }
    }}
  return(as.data.frame(workingMatrix))
}
