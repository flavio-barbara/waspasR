library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test on format validation function
# Creates a mini DB
data(choppers)

test_that("checkInputFormat() Database OK.", {
  DBOK <- checkInputFormat(choppers)
  expect_equal(TRUE, DBOK)
})

test_that("checkInputFormat() checks indicators.", {
  tempDB <- choppers
  tempDB[1, 1] <- "Any spurious data"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() checks flags.", {
  tempDB <- choppers
  tempDB[1, 2] <- "Any spurious data"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() checks weights, sum =  = 1.", {
  tempDB <- choppers
  tempDB[2, 2]<- "1"
  expect_error(checkInputFormat(tempDB))
})

test_that("checkInputFormat() Check Weights values.", {
  tempDB <- choppers
  tempDB[2, 2] <- "non convertible to numeric"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK, 
               "Error: Check Weights values, all must be numeric")
})

test_that("checkInputFormat() checks AxC values.", {
  tempDB <- choppers
  tempDB[4, 2] <- "non convertible to numeric"
  DBOK <- checkInputFormat(tempDB)
  expect_equal(DBOK, 
              "Error: Check Aternatives x Criteria values, all must be numeric")
})

test_that("checkInputFormat() checks Parameter dfMatrix is missing.", {
  DBOK <- checkInputFormat()
  expect_equal(DBOK, 
               "Parameter dfMatrix is missing")
})

test_that("checkInputFormat() checks Parameter dfMatrix must be a data.frame.", {
  DBOK <- checkInputFormat("something")
  expect_equal(DBOK, 
               "Parameter dfMatrix must be a data.frame")
})
