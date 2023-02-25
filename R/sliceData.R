#' @title sliceData
#'
#' @description Slice a matrix or data.frame in “all - in - one” format into
#' dedicated vectors/matrices as data.frame objects
#'
#' @param waspas_db A matrix or data.frame in “all - in - one” format
#' @param output_obj A flag to determine the vector or matrix (data.frame)
#' to extract from the input matrix must be 'A' (Alternatives), 'C' (Criteria),
#' 'F' (Flags), 'V' (Values) or 'W' (Weights)
#'
#' @return A data.frame one - dimensional (vector) or two - dimensional (matrix)
#' with one of the Following objects:
#'  - if output_obj == "A": A vector of Alternatives
#'  - if output_obj == "C": A vector of Criteria
#'  - if output_obj == "F": A vector of Cost - Benefit Flags
#'  - if output_obj == "I": A vector containing the indicators in cells [1:3, 1]
#'  - if output_obj == "V": A matrix of values per Alternative x Criterion
#'  - if output_obj == "W": A vector of Weights
#'
#' @examples
#'
#' \dontrun{
#' AlternativesList <- sliceData(waspas_db, "A")
#' CriteriaList <- sliceData(waspas_db, "C")
#' cost_benefit_Flags <- sliceData(waspas_db, "F")
#' values_matrix <- sliceData(waspas_db, "M")
#' vectorWeights <- sliceData(waspas_db, "W")
#' }
#' @export

# Extract data from main data.frame
sliceData <- function(waspas_db, output_obj) {
  tryCatch({
    # extract vectors of flags, weights and criteria
    output_obj <- toupper(substr(output_obj, 1, 1))
    if (output_obj %in% c("C", "F", "W")) {
      for (iRow in 1:3) {
        if (waspas_db[iRow, 1] ==  output_obj) {
          return(waspas_db[iRow, 2:ncol(waspas_db)])
        }
      }
    } else if (output_obj == "A") {
      alternatives <- waspas_db[4:nrow(waspas_db), 1]
      # Transpose the result to output in the same standard of the other slices
      vec_alts <- as.data.frame(t(alternatives))
      return(vec_alts)
    } else if (output_obj == "V") {
      return(waspas_db[4:nrow(waspas_db), 2:ncol(waspas_db)])
    } else if (output_obj == "I") {
      indicators <- waspas_db[1:3, 1]
      # Transpose the result to output in the same standard of the other slices
      vec_inds <- as.data.frame(t(indicators))
      return(vec_inds)
    } else {
      return(paste("Error: The value of parameter [output_obj] must be"
      , "'A', 'C', 'F', 'I', 'V' or 'W', please reffer to help"))
    }
  },
  error = function(cond) {
    stop(paste("E[SD]", cond))
  })
}
