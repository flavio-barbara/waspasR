library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test WPM Calculation function
# Creates the test DB
data(choppers)
flags <- sliceData(choppers,"F")
values <- sliceData(choppers,"V")
norm_values <- normalize(values,flags)
weightsVec <- sliceData(choppers,"W")
# Test vector of Weights X matrix of values dimensions
test_that("calcWPM() checks wrong dimensions...", {
  tempVec <- weightsVec[,-1]
  wrong <- calcWPM(norm_values, tempVec)
  expect_equal("Error: Vector of Weights values must be same size of number of Criteria"
               , wrong)
})

# Test Vector of Weights contents, it must summarize 1
test_that("calcWPM() checks Vector of Weights... Not OK", {
  tempVec <- weightsVec
  tempVec[1,1] <- "1"
  wrong <- calcWPM(norm_values, tempVec)
  expect_equal("Error: Values in Vector of Weights must summarize 1"
               , wrong)
})
test_that("calcWSM() checks Vector of Weights... OK", {
  DBOK <- calcWPM(norm_values, weightsVec)
  expect_equal(seq(1,15), DBOK[,1])
  expect_equal(sum(sapply(DBOK[,2], as.numeric)), sum(DBOK[,2]))
})
