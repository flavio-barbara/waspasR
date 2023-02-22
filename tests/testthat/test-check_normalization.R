library(testthat)               # Load testthat package
library(waspasR)                # Load our package

#### --- Test on normalization function
# Creates the DB
data(choppers)
flags <- sliceData(choppers,"F")
values <- sliceData(choppers,"V")
norm_values <- normalize(values,flags)

# Tests if the output is really normalized (maximum value must be 1)
test_that("normalize() returns a normalized set...", {
  isMaxEqual1 <- max(sapply(norm_values, as.numeric))
  expect_equal(1, isMaxEqual1)
})

# Test if normalize() deals with parameters with different sizes
test_that("normalize() deals with parameters with different sizes...", {
  wrongFlags <- append(flags, "one more flag")
  myOutput <- normalize(values, wrongFlags)
  expect_equal(myOutput,
               "Error: The cost-benefit flags array must be the same size as the number of criteria")
})

# Test if normalize() deals with a wrong set of flags
test_that("normalize() deals with a wrong set of flags...", {
  wrongFlags <- flags
  wrongFlags[1,1] <- "a wrong flag"
  myOutput <- normalize(values, wrongFlags)
  expect_equal(myOutput,
               "Error: Vector of flags must contains just strings initiated with B or C (i.e. b,c,B,C,Cost,Benefit,Ben etc.)")
})
