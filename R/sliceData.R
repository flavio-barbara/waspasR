#' @title sliceData
#'
#' @description Slice a matrix or data.frame in “all-in-one” format into dedicated vectors/matrices
#'              as data.frame objects
#'
#' @param dfMatrix A matrix or data.frame in “all-in-one” format
#' @param outData A flag to determine the vector or matrix (data.frame) to extract from the input matrix
#'                must be 'A' (Alternatives), 'C' (Criteria), 'F' (Flags), 'V' (Values) or 'W' (Weights)
#'
#' @return A data.frame one-dimensional (vector) or two-dimensional (matrix) with one of the Following objects:
#'  - if outData == "A": A vector of Alternatives
#'  - if outData == "C": A vector of Criteria
#'  - if outData == "F": A vector of Cost-Benefit Flags
#'  - if outData == "V": A matrix of values per Alternative x Criterion
#'  - if outData == "W": A vector of Weights
#'
#' @examples
#'
#' \dontrun{
#' AlternativesList <- sliceData(dfMatrix, "A")
#' CriteriaList <- sliceData(dfMatrix, "C")
#' cost_benefit_Flags <- sliceData(dfMatrix, "F")
#' values_matrix <- sliceData(dfMatrix, "M")
#' vectorWeights <- sliceData(dfMatrix, "W")}
#'
#' @export

#' #################### dfMatrix Matrix  ==>  AxCNorm Matrix

sliceData <- function(dfMatrix, outData) {
  # extract vectors of flags, weights and criteria
  if (outData %in% c("C","F","W")){
    for(iRow in 1:3){
      if (dfMatrix[iRow,1] == outData){
        return(dfMatrix[iRow,2:ncol(dfMatrix)])
      }else if(dfMatrix[iRow,1] == outData){
        return(dfMatrix[iRow,2:ncol(dfMatrix)])
      }else if(dfMatrix[iRow,1] == outData){
        return(dfMatrix[iRow,2:ncol(dfMatrix)])
      }
    }
  }else if (outData =="A"){
    return(as.data.frame(dfMatrix[4:nrow(dfMatrix),1]))
  }else if (outData =="V"){
    return(dfMatrix[4:nrow(dfMatrix),2:ncol(dfMatrix)])
  }else{
    return("Error #07: The value of parameter [outData] must be 'A','C','F','V' or 'W', please reffer to help")
  }
}
