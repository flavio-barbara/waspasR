#' Data about helicopters
#'
#' A database with real data about helicopters, relevant criteria for deciding
#' which would be the best option in a real acquisition process, according to
#' the work published and cited below.
#' The values were raised by the contributors cited in the references below
#' at the time they published the work (January 2023)
#' The database used in tests and recomended for user test is the choppers.RData,
#' this csv file was thought of as a tool to be made available to the user of
#' the waspasR package so that they can easily download and view it in spreadsheet
#' utilities (eg excel, Calc, etc.) and easily understand the structure that the
#' database data to be submitted to WASPAS must have.
#'
#' @docType csv data
#'
#' @usage sampleDataSet <- read.csv("data/sampleDataSet.csv")
#'
#' @format An object of class \code{"data.frame"}
#' \describe{
#'  \item{alternatives}{A set of helicopters names that can be bought in the marketplace.
#'  These data are in the first column, from row 4 to the last.}
#'  \item{criteria}{set of criteria that a helicopter buyer may deem relevant for making a
#'  purchase decision. These data are in the 3rd row, from col 2 to the last.}
#'  \item{weights}{Arbitrated by the decision maker, they attribute different
#'     relative importance to the values of the criteria in percentage terms,
#'     thus making a weighting of these criteria.}
#'  \item{flags}{They determine whether the specific criterion is cost, that is,
#'  the smaller, the better, or benefit, the greater the better.
#'  These data are in the 1st row, from col 2 to the last.}
#'  \item{values}{Randomly generated value, within a range that makes sense
#'  These data are in the fourth row, from col 2 to the last.}
#'  }
#' @references This data set was created with the help of Gustavo, Marcos & Marcio, in the work
#' cited below:
#' Soares de Assis, Gustavo & Santos, Marcos & Basilio, Marcio. (2023). Use of the WASPAS Method
#' to Select Suitable Helicopters for Aerial Activity Carried Out by the Military Police of the
#' State of Rio de Janeiro. Axioms. 12. 77. 10.3390.
#'
#' @keywords datasets
#'
#' @examples
#' data(sampleDataSet)
#' head(sampleDataSet)
#'
"sampleDataSet"
