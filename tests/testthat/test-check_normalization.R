library(testthat)               # Load testthat package
library(waspasR)                # Load our package

#### - - - Test on normalization function
# Creates the DB
data(choppers)
flags <- sliceData(choppers, "F")
values <- sliceData(choppers, "V")

# Tests if the output is really normalized (maximum value must be 1)
test_that("normalize() returns a normalized set.", {
  norm_values <- normalize(values, flags)
  is_max_eq_1 <- max(sapply(norm_values, as.numeric))
  expect_equal(1, is_max_eq_1)
})

# Test if normalize() deals with parameters with different sizes
test_that("normalize() deals with parameters with different sizes.", {
  wrong_flags <- append(flags, "one more flag")
  normalized_out <- normalize(values, wrong_flags)
  expect_equal(normalized_out,
               paste("Error: The cost - benefit flags array must be the same"
               , "size as the number of criteria"))
})

# Test if normalize() deals with a wrong set of flags
test_that("normalize() deals with a wrong set of flags.", {
  wrong_flags <- flags
  wrong_flags[1, 1] <- "a wrong flag"
  normalized_out <- normalize(values, wrong_flags)
  expect_equal(normalized_out,
        paste("Error: Vector of flags must contains just strings initiated with"
              , "B or C (i.e. b, c, B, C, Cost, Benefit, Ben etc.)"))
})

# Test if normalize() deals with non numeric - alike values
test_that("normalize() deals non numeric - alike values.", {
  wrong_vals <- values
  wrong_vals[1, 1] <- "non numeric - alike value"
  normalized_out <- normalize(wrong_vals, flags)
  expect_equal(normalized_out,
               "W[N] Error: Some non numeric-alike value was found")
})

# Covers tryCatch Errors
test_that("normalize() checks Error.", {
  expect_error(normalize())
})
