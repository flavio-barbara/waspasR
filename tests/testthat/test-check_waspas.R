library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test the WASPAS R function
# Creates the test DB
data(choppers)

# Test WASPAS Ranking
test_that("waspasR() check output values..", {
  waspasTest <- waspasR(choppers, lambda = 0.5)
  expect_equal(nrow(choppers), nrow(waspasTest) + 1)
  expect_equal(ncol(choppers), ncol(waspasTest) - 3)
})

# Covers tryCatch Errors
test_that("waspasR() checks Error.", {
  expect_error(waspasR())
})

