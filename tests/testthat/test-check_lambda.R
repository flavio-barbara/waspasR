library(testthat)        # Load testthat package
library(waspasR)         # Load our package

#### --- Test the lambda application function
# Creates the test DB
data(choppers)
flags <- sliceData(choppers,"F")
values <- sliceData(choppers,"V")
norm_values <- normalize(values,flags)
weightsVec <- sliceData(choppers,"W")
wsm <- calcWSM(norm_values, weightsVec)
wpm <- calcWPM(norm_values, weightsVec)

# Test value of lambda
test_that("applyLambda() deals with wrong input value of lambda...", {
  lambdaTest <- applyLambda(wsm, wpm, lambda = 1.5)
  expect_equal("Error: The lambda's value must be between 0 and 1", lambdaTest)
  lambdaTest <- applyLambda(wsm, wpm, lambda = -0.5)
  expect_equal("Error: The lambda's value must be between 0 and 1", lambdaTest)
})

# Test WSM_matrix X WPM_matrix (size and contents)
test_that("applyLambda() deals with wrong sizes of input matrices...", {
  wsmWrong <- wsm[-1,]
  wpmWrong <- wpm[-1,]
  lambdaTest <- applyLambda(wsmWrong, wpm, lambda = 0.5)
  expect_equal("Error: WSM and WPM matrices entered must have same number of rows", lambdaTest)
  lambdaTest <- applyLambda(wsm, wpmWrong, lambda = 0.5)
  expect_equal("Error: WSM and WPM matrices entered must have same number of rows", lambdaTest)
})

# Test WASPAS Ranking
test_that("applyLambda() check output values..", {
  lambdaTest <- applyLambda(wsm, wpm, lambda = 1)
  expect_equal(lambdaTest$WASPAS_Rank, lambdaTest$WSM_Rank)
  lambdaTest <- applyLambda(wsm, wpm, lambda = 0)
  expect_equal(lambdaTest$WASPAS_Rank, lambdaTest$WPM_Rank)
  lambdaTest <- applyLambda(wsm, wpm, lambda = 0.5)
  expect_equal(lambdaTest$WASPAS_Rank, (lambdaTest$WPM_Rank + lambdaTest$WSM_Rank) / 2)
})
