library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test on format validation function
# Creates a mini DB
data(choppers)

test_that("checkInputFormat() Database OK.", {
  DBOK <- checkInputFormat(choppers)
  expect_equal(TRUE, DBOK)
})

test_that("checkInputFormat() checks indicators.", {
  tempDB <- choppers
  tempDB[1,1] <- "Any spurious data"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() checks flags.", {
  tempDB <- choppers
  tempDB[1,2] <- "Any spurious data"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() checks weights, sum==1.", {
  tempDB <- choppers
  tempDB[2,2]<-"1"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() checks weights.", {
  tempDB <- choppers
  tempDB[2,2]<-"Any spurious data"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Values in Vector of Weights must summarize 1")
})

test_that("checkInputFormat() checks values.", {
  tempDB <- choppers
  tempDB[4,2] <- "non convertible to numeric"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK,
               "Error: Check Aternatives x Criteria values, all must be numeric")
})

