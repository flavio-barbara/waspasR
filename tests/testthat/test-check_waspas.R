library(testthat)        # Load testthat package
library(waspasR)         # Load our package
# Test WASPAS Ranking
test_that("waspasR() check wrong input.", {
  testChoppers <- choppers
  testChoppers[1,1] <- "Spurious indicator"
  waspasTest <- waspasR(choppers, lambda = 0.5)
  expect_equal(waspasTest,
               "Error: The cost-benefit flags array must be the same size as the number of criteria")
})
