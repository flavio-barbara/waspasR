#' Data about helicopters
#'
#' A small database with real helicopter names and criteria that make sense.
#' The values and weights are generated at random.
#' The only requirement for the methods is that their sum be 1.
#' The set of Cost-Benefit flags make no sense in terms of the criteria they refer to
#' and are just a set of strings starting with the letter "C" (cost) or "B" (benefit).
#' That is, a criterion that must be monotonic of benefit (we want to maximize it) can have
#' a "c" flag, while a criterion that the user would rightly judge to be cost (we want to
#' minimize it) can have a "b" flag.
#'
#' @docType data
#'
#' @usage data(choppers)
#'
#' @format An object of class \code{"data.frame"}
#' \describe{
#'  \item{alternatives}{A set of helicopters names that can be bought in the marketplace.
#'  These data are in the first column, from row 4 to the last.}
#'  \item{criteria}{set of criteria that a helicopter buyer may deem relevant for making a
#'  purchase decision. These data are in the 3rd row, from col 2 to the last.}
#'  \item{weights}{Arbitrated by the decision maker, they relativize the value of the
#'  criteria in percentage terms, thus making a weighting of these criteria.
#'  These data are in the 2nd row, from col 2 to the last.}
#'  \item{flags}{They determine whether the specific criterion is cost, that is,
#'  the smaller, the better, or benefit, the greater the better.
#'  These data are in the 1st row, from col 2 to the last.}
#'  \item{values}{Randomly generated value, within a range that makes sense
#'  These data are in the 5th row, from col 2 to the last.}
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
#' data(choppers)
#' head(choppers)
#'
"choppers"
