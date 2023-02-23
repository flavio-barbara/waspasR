library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test on slicing function
# Creates the DB
data(choppers)
# Tests wrong parameter
test_that("sliceData() checks wrong parameter...", {
  wrong <- sliceData(choppers, "1")
  expect_equal("Error: The value of parameter [outData] must be 'A','C','F','I','V' or 'W', please reffer to help"
               , wrong)
})

# Tests the output of flags, weights and criteria
test_that("sliceData() slices flags...", {
  DBOK <- sliceData(choppers, "F")
  expect_equal(choppers[1,2:18], DBOK)
})
test_that("sliceData() slices weights...", {
  DBOK <- sliceData(choppers, "W")
  expect_equal(choppers[2,2:18], DBOK)
})
test_that("sliceData() slices criteria...", {
  DBOK <- sliceData(choppers, "C")
  expect_equal(choppers[3,2:18], DBOK)
})

# Tests the output of alternatives
test_that("sliceData() slices alternatives...", {
  DBOK <- sliceData(choppers, "a")
  chopperAlternatives <- as.data.frame(t(choppers[4:18,1]))
  expect_equal(chopperAlternatives, (DBOK))
})

# Tests the output of values
test_that("sliceData() slices values...", {
  DBOK <- sliceData(choppers, "V")
  expect_equal(choppers[4:18, 2:18], DBOK)
})

# Tests the output of indicators
test_that("sliceData() slices indicators...", {
  DBOK <- sliceData(choppers, "i")
  chopperIndicators <- as.data.frame(t(choppers[1:3, 1]))
  expect_equal(chopperIndicators, DBOK)
})

# Covers tryCatch Errors
test_that("sliceData() checks Error.", {
  expect_error(sliceData())
})

