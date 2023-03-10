library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test the lambda application function
# Creates the test DB
data(choppers)
flags <- sliceData(choppers, "F")
values <- sliceData(choppers, "V")
norm_values <- normalize(values, flags)
vec_weights <- sliceData(choppers, "W")
wsm <- calcWSM(norm_values, vec_weights)
wpm <- calcWPM(norm_values, vec_weights)

# Test non - numeric values
test_that("applyLambda() deals with non - numeric input values.", {
  non_numeric <- wpm
  non_numeric[2, 2] <- "non - numeric value"
  lambda_tst <- applyLambda(wsm, non_numeric, lambda = 0.5)
  expect_equal(lambda_tst
               , "W[AL] Error: Some non numeric-alike value was found")
})

# Test value of lambda
test_that("applyLambda() deals with wrong input value of lambda.", {
  lambda_tst <- applyLambda(wsm, wpm, lambda = 1.5)
  expect_equal(lambda_tst, "Error: The lambda's value must be between 0 and 1")
  lambda_tst <- applyLambda(wsm, wpm, lambda =  - 0.5)
  expect_equal(lambda_tst, "Error: The lambda's value must be between 0 and 1")
})

# Test matrix_wsm X matrix_wpm (size and contents)
test_that("applyLambda() deals with wrong sizes of input matrices.", {
  wrong_wsm <- wsm[-1, ]
  wrong_wpm <- wpm[-1, ]
  lambda_tst <- applyLambda(wrong_wsm, wpm, lambda = 0.5)
  expect_equal(lambda_tst,
    "Error: WSM & WPM matrices entered must have same number of rows")
  lambda_tst <- applyLambda(wsm, wrong_wpm, lambda = 0.5)
  expect_equal(lambda_tst,
    "Error: WSM & WPM matrices entered must have same number of rows")
})

# Test WASPAS Ranking
test_that("applyLambda() check output values.", {
  lambda_tst <- applyLambda(wsm, wpm, lambda = 1)
  expect_equal(lambda_tst$WASPAS_Rank, lambda_tst$WSM_Rank)
  lambda_tst <- applyLambda(wsm, wpm, lambda = 0)
  expect_equal(lambda_tst$WASPAS_Rank, lambda_tst$WPM_Rank)
  lambda_tst <- applyLambda(wsm, wpm, lambda = 0.5)
  expect_equal(lambda_tst$WASPAS_Rank
               , (lambda_tst$WPM_Rank + lambda_tst$WSM_Rank) / 2)
})

# Covers tryCatch Errors
test_that("applyLambda() checks Error.", {
  expect_error(applyLambda(x,y,0))
})
