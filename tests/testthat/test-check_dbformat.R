library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test on format validation function
# Creates a mini DB
data(choppers)

# test_that("checkInputFormat() Database OK.", {
#   db_ok <- checkInputFormat(choppers)
#   expect_equal(TRUE, db_ok)
# })

test_that("checkInputFormat() checks indicators.", {
  temp_db <- choppers
  temp_db[1, 1] <- "Any spurious data"
  expect_error(checkInputFormat(temp_db))
})

test_that("checkInputFormat() checks flags.", {
  temp_db <- choppers
  temp_db[1, 2] <- "Any spurious data"
  expect_error(checkInputFormat(temp_db))
})

test_that("checkInputFormat() checks weights, sum =  = 1.", {
  temp_db <- choppers
  temp_db[2, 2] <- "1"
  expect_error(checkInputFormat(temp_db))
})

test_that("checkInputFormat() Check Weights values.", {
  temp_db <- choppers
  temp_db[2, 2] <- "non convertible to numeric"
  db_ok <- checkInputFormat(temp_db)
  expect_equal(db_ok,
               "Error: Check Weights values, all must be numeric")
})

# test_that("checkInputFormat() checks AxC values.", {
#   temp_db <- choppers
#   temp_db[4, 2] <- "non convertible to numeric"
#   db_ok <- checkInputFormat(temp_db)
#   expect_equal(db_ok,
#               "Error: Check Aternatives x Criteria values, all must be numeric")
#   temp_db[4, 2] <- NA
#   expect_error(checkInputFormat(temp_db))
# })

test_that("checkInputFormat() checks parm waspas_df is missing.", {
  db_ok <- checkInputFormat()
  expect_equal(db_ok,
               "Parameter waspas_db is missing")
})

test_that("checkInputFormat() checks parm waspas_df is NOT a data.frame.", {
  db_ok <- checkInputFormat("something")
  expect_equal(db_ok,
               "Parameter waspas_db must be a data.frame")
})
