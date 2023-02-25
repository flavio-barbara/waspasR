, library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test the WASPAS R function
# Creates the test DB
data(choppers)

# Test WASPAS wrong input
test_that("waspasR() check wrong input.", {
  tempDB <- choppers
  tempDB[2, 2] <- "non convertible to numeric"
  waspasTest <- waspasR(tempDB, 0)
  expect_equal(waspasTest, 
               "Error: Check Weights values, all must be numeric")
})

# Test WASPAS Ranking
test_that("waspasR() check output values.", {
  waspasTest <- waspasR(choppers, lambda = 0.5)
  expect_equal(nrow(choppers), nrow(waspasTest) + 1)
  expect_equal(ncol(choppers), ncol(waspasTest) - 3)
})

# Covers tryCatch Errors
test_that("waspasR() checks missing parameters", {
  waspasTest <- waspasR()
  expect_equal(waspasTest, 
               "Parameter dfMatrix is missing")
  waspasTest <- waspasR(choppers)
  expect_equal(waspasTest, 
               "Parameter lambda is missing")
})

