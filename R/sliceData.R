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
#'  - if outData == "I": A vector containing the indicators in cells [1:3, 1]
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
#' vectorWeights <- sliceData(dfMatrix, "W")
#' }
#' @export

# Extract data from main data.frame
sliceData <- function(dfMatrix, outData) {
  tryCatch({
    # extract vectors of flags, weights and criteria
    outData <- toupper(substr(outData, 1, 1))
    if (outData %in% c("C","F","W")){
      for(iRow in 1:3){
        if (dfMatrix[iRow,1] == outData){
          return(dfMatrix[iRow,2:ncol(dfMatrix)])
        }
      }
    }else if (outData =="A"){
      alternatives <- dfMatrix[4:nrow(dfMatrix),1]
      # Transpose the result to output in the same standard of the other extractions
      altsVector <- as.data.frame(t(alternatives))
      return(altsVector)
      #return(as.data.frame(dfMatrix[4:nrow(dfMatrix),1]))
    }else if (outData =="V"){
      return(dfMatrix[4:nrow(dfMatrix),2:ncol(dfMatrix)])
    }else if (outData =="I"){
      indicators <- dfMatrix[1:3, 1]
      # Transpose the result to output in the same standard of the other extractions
      indsVector <- as.data.frame(t(indicators))
      return(indsVector)
    }else{
      return("Error: The value of parameter [outData] must be 'A','C','F','I','V' or 'W', please reffer to help")
    }
  },
  error=function(cond) {  stop(paste("E[SD]",cond))
  },
  warning=function(cond) {  stop(paste("W[SD]",cond))
  })
}
