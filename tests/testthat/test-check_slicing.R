library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test on slicing function
# Creates the DB
data(choppers)
# Tests wrong parameter
test_that("sliceData() checks wrong parameter...", {
  wrong <- sliceData(choppers, "1")
  expect_equal(wrong, paste("Error: The value of parameter [output_obj] must be"
  , "'A', 'C', 'F', 'I', 'V' or 'W', please reffer to help"))
})

# Tests the output of flags, weights and criteria
test_that("sliceData() slices flags...", {
  db_ok <- sliceData(choppers, "F")
  expect_equal(choppers[1, 2:18], db_ok)
})
test_that("sliceData() slices weights...", {
  db_ok <- sliceData(choppers, "W")
  expect_equal(choppers[2, 2:18], db_ok)
})
test_that("sliceData() slices criteria...", {
  db_ok <- sliceData(choppers, "C")
  expect_equal(choppers[3, 2:18], db_ok)
})

# Tests the output of alternatives
test_that("sliceData() slices alternatives...", {
  db_ok <- sliceData(choppers, "a")
  alternatives <- as.data.frame(t(choppers[4:18, 1]))
  expect_equal(alternatives, (db_ok))
})

# Tests the output of values
test_that("sliceData() slices values...", {
  db_ok <- sliceData(choppers, "V")
  expect_equal(choppers[4:18, 2:18], db_ok)
})

# Tests the output of indicators
test_that("sliceData() slices indicators...", {
  db_ok <- sliceData(choppers, "i")
  indicators <- as.data.frame(t(choppers[1:3, 1]))
  expect_equal(indicators, db_ok)
})

# Covers tryCatch Errors
test_that("sliceData() checks Error.", {
  expect_error(sliceData())
})
