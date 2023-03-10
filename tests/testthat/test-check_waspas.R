library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### Test the WASPAS R function
# Creates the test DB
data(choppers)

# Test WASPAS wrong input
test_that("waspasR() check wrong input.", {
  temp_db <- choppers
  temp_db[2, 2] <- "non convertible to numeric"
  waspas_test <- waspasR(temp_db, 0)
  expect_equal(waspas_test,
               "Error: Check Weights values, all must be numeric")
})

# Test WASPAS Ranking
test_that("waspasR() check output values.", {
  waspas_test <- waspasR(choppers, lambda = 0.5)
  expect_equal(round(max(waspas_test$WASPAS_Rank, na.rm=TRUE), 3), 0.617)
  expect_equal(round(min(waspas_test$WASPAS_Rank, na.rm=TRUE),3), 0.433)
})

# Covers tryCatch Errors
test_that("waspasR() checks missing parameters", {
  waspas_test <- waspasR()
  expect_equal(waspas_test,
               "Parameter waspas_df is missing")
  waspas_test <- waspasR(choppers)
  expect_equal(waspas_test,
               "Parameter lambda is missing")
})
