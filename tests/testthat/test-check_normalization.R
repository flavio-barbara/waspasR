context("check-normalization")  # Our file is called "test-check_normalization.R"
library(testthat)               # load testthat package
library(waspasR)                # load our package

#### --- test on normalization function
# Tests if the output is really normalized (maximum value must be 1)
test_that("normalize() returns a normalized set...", {
  isMaxEqual1 <- max(sapply(normOutput, as.numeric))
  expect_equal(1, isMaxEqual1)
})

# Test if normalize() deals with parameters with different sizes
test_that("normalize() deals with parameters with different sizes...", {
  wrongFlags <- append(flags, "one more flag")
  myOutput <- normalize(values, wrongFlags)
  expect_equal(myOutput,
               "Error #01: Vector of Cost-Benefit flags must be same size of number of Criteria")
})

# Test if normalize() deals with a wrong set of flags
test_that("normalize() deals with a wrong set of flags...", {
  wrongFlags <- flags
  wrongFlags[1,1] <- "a wrong flag"
  myOutput <- normalize(values, wrongFlags)
  expect_equal(myOutput,
               "Error #02: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
})
