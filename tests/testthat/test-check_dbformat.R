library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test on format validation function
# Creates a mini DB
data(choppers)
testDB <- choppers[1:5, 1:5]
testDB[2,2:5] <- list("0.25","0.3","0.2","0.25")
# Tests the indicators
test_that("checkInputFormat() checks weights... OK", {
  DBOK <- checkInputFormat(testDB)
  expect_equal(TRUE, DBOK)
})
test_that("checkInputFormat() checks indicators... Wrong", {
  tempDB <- testDB
  tempDB[1,1] <- "Any spurious data"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Check the indicators in cells [1:3, 1], they must be 'C', 'F' or 'W'")
})
test_that("checkInputFormat() checks indicators... Not 3 indicators", {
  tempDB <- testDB[-1 ,] # "remove first line"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Check the indicators in cells [1:3, 1], they must be 'C', 'F' or 'W'")
})

# Tests the Cost-Benefit flags
test_that("checkInputFormat() checks flags... OK", {
  DBOK <- checkInputFormat(testDB)
  expect_equal(TRUE, DBOK)
})
test_that("checkInputFormat() checks flags... not OK", {
  tempDB <- testDB
  tempDB[1,2] <- "Any spurious data"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
})

# Tests the weights
test_that("checkInputFormat() checks weights... Not OK", {
  tempDB <- testDB
  tempDB[2,2]<-"1"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Values in Vector of Weights must summarize 1")
})
test_that("checkInputFormat() checks flags... OK", {
  tempDB <- testDB
  DBOK <- checkInputFormat(tempDB)
  expect_equal(TRUE, DBOK)
})

# Tests the values
test_that("checkInputFormat() checks values... OK", {
  DBOK <- checkInputFormat(testDB)
  expect_equal(TRUE, DBOK)
  })
test_that("checkInputFormat() checks values... Not OK", {
  tempDB <- testDB
  tempDB[4,2] <- "non convertible to numeric"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(TRUE, DBOK)
})

