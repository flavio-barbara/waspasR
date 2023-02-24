library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test WSM Calculation function
# Creates the test DB
data(choppers)
flags <- sliceData(choppers,"F")
values <- sliceData(choppers,"V")
norm_values <- normalize(values,flags)
weightsVec <- sliceData(choppers,"W")
# Test vector of Weights X matrix of values dimensions
test_that("calcWSM() checks wrong dimensions...", {
  tempVec <- weightsVec[,-1]
  wrong <- calcWSM(norm_values, tempVec)
  expect_equal("Error: The weight vector must be the same size as the number of criteria"
               , wrong)
})

# Test Vector of Weights contents, it must summarize 1
test_that("calcWSM() checks Vector of Weights... Not OK", {
  tempVec <- weightsVec
  tempVec[1,1] <- "1"
  wrong <- calcWSM(norm_values, tempVec)
  expect_equal(wrong, "Error: Values in Vector of Weights must summarize 1")
  tempVec <- weightsVec
  tempVec[1,1] <- "non numeric-alike value"
  wrong <- calcWSM(norm_values, tempVec)
  expect_equal(wrong, "W[S] Error: Some non numeric-alike value was found")
})
test_that("calcWSM() checks Vector of Weights... OK", {
  DBOK <- calcWSM(norm_values, weightsVec)
  expect_equal(seq(1,15), DBOK[,1])
  expect_equal(sum(sapply(DBOK[,2], as.numeric)), sum(DBOK[,2]))
})

# Covers tryCatch Errors
test_that("calcWSM() checks Error.", {
  expect_error(calcWSM())
})
