library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### - - - Test the lambda application function
# Creates the test DB
data(choppers)
flags <- sliceData(choppers, "F")
values <- sliceData(choppers, "V")
norm_values <- normalize(values, flags)
weightsVec <- sliceData(choppers, "W")
wsm <- calcWSM(norm_values, weightsVec)
wpm <- calcWPM(norm_values, weightsVec)

# Test non - numeric values
test_that("applyLambda() deals with non - numeric input values.", {
  nonnum <- wpm
  nonnum[2, 2] <- "non - numeric value"
  lambdaTst <- applyLambda(wsm, nonnum, lambda = 0.5)
  expect_equal(lambdaTst, "W[AL] Error: Some non numeric - alike value was found")
})

# Test value of lambda
test_that("applyLambda() deals with wrong input value of lambda.", {
  lambdaTst <- applyLambda(wsm, wpm, lambda = 1.5)
  expect_equal("Error: The lambda's value must be between 0 and 1", lambdaTst)
  lambdaTst <- applyLambda(wsm, wpm, lambda =  - 0.5)
  expect_equal("Error: The lambda's value must be between 0 and 1", lambdaTst)
})

# Test matrix_wsm X matrix_wpm (size and contents)
test_that("applyLambda() deals with wrong sizes of input matrices.", {
  wsmWrong <- wsm[ - 1, ]
  wpmWrong <- wpm[ - 1, ]
  lambdaTst <- applyLambda(wsmWrong, wpm, lambda = 0.5)
  expect_equal("Error: WSM & WPM matrices entered must have same number of rows"
    , lambdaTst)
  lambdaTst <- applyLambda(wsm, wpmWrong, lambda = 0.5)
  expect_equal("Error: WSM & WPM matrices entered must have same number of rows"
    , lambdaTst)
})

# Test WASPAS Ranking
test_that("applyLambda() check output values.", {
  lambdaTst <- applyLambda(wsm, wpm, lambda = 1)
  expect_equal(lambdaTst$WASPAS_Rank, lambdaTst$WSM_Rank)
  lambdaTst <- applyLambda(wsm, wpm, lambda = 0)
  expect_equal(lambdaTst$WASPAS_Rank, lambdaTst$WPM_Rank)
  lambdaTst <- applyLambda(wsm, wpm, lambda = 0.5)
  expect_equal(lambdaTst$WASPAS_Rank
               , (lambdaTst$WPM_Rank + lambdaTst$WSM_Rank) / 2)
})

# Covers tryCatch Errors
test_that("applyLambda() checks Error.", {
  expect_error(applyLambda())
})
