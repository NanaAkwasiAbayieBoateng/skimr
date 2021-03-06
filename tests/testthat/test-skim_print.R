context("Print a skim_df object")

test_that("Skim prints a header for the entire output and each type", {
  input <- skim(iris)
  expect_output(print(input), "Skim summary statistics")
  expect_output(print(input), "n obs: 150")
  expect_output(print(input), "n variables: 5 \n")
  expect_output(print(input), "Variable type: factor")
  expect_output(print(input), "Variable type: numeric")
})

test_that("Skim prints a special header for grouped data frames", {
  input <- skim(dplyr::group_by(iris, Species))
  expect_output(print(input), " group variables: Species")
  expect_output(print(input), "n obs: 150")
  expect_output(print(input), "n variables: 5 \n")
})

test_that("Skim prints a special header for vectors", {
  input <- skim(lynx)
  expect_output(print(input), "Skim summary statistics")
  expect_output(print(input), "Variable type: ts")
})

test_that("Skim collapses counts and other multivalue stats into one cell", {
  input <- skim(iris)
  expect_output(print(skim, "set: 50, ver: 50, vir: 50, NA: 0"))
})

test_that("Skim aligns numeric vectors at the decimal point by default", {
  input <- skim(mtcars)
  expect_output(print(input), "  am       0       32 32   0.41   0.5   0")
  expect_output(print(input), "carb       0       32 32   2.81   1.62  1")
  expect_output(print(input), "drat       0       32 32   3.6    0.53  2.76")
  expect_output(print(input), "gear       0       32 32   3.69   0.74  3")
})

test_that("spark.print returns the correct result",{
  skip_on_os("windows")
  # Windows does not support block characters
  input <- inline_hist(chickwts$weight)
  expect_output(print(input), "▃▅▅▇▃▇▂▂")
  
})

test_that("Skimr kable prints as expected", {
  skimmed <- skim(iris)
  input <- capture.output(skimr::kable(skimmed))
  
  expect_length(input, 18)
  # Intentional long lines in this test
  expect_equal(input[1], "Skim summary statistics  ")
  expect_equal(input[2], " n obs: 150    ")
  expect_equal(input[3], " n variables: 5    ")
  expect_equal(input[4], "")
  expect_equal(input[5], "Variable type: factor")
  expect_equal(input[6], "")
  expect_equal(input[7], 
"|variable |missing |complete |n   |n_unique |top_counts                       |ordered |"
   )
  expect_equal(input[8], 
"|:--------|:-------|:--------|:---|:--------|:--------------------------------|:-------|"
   )
  expect_equal(input[9], 
"|Species  |0       |150      |150 |3        |set: 50, ver: 50, vir: 50, NA: 0 |FALSE   |"
  )
  expect_equal(input[10], "")
  expect_equal(input[11], "Variable type: numeric")
  expect_equal(input[12], "")  
  # Windows does not support block characters
  skip_on_os("windows")
  expect_equal(input[13], 
"|variable     |missing |complete |n   |mean |sd   |min |p25 |median |p75 |max |hist     |"
  )
  expect_equal(input[14], 
"|:------------|:-------|:--------|:---|:----|:----|:---|:---|:------|:---|:---|:--------|"
  )
  expect_equal(input[15], 
"|Petal.Length |0       |150      |150 |3.76 |1.77 |1   |1.6 |4.35   |5.1 |6.9 |▇▁▁▂▅▅▃▁ |"
   )
  expect_equal(input[16], 
"|Petal.Width  |0       |150      |150 |1.2  |0.76 |0.1 |0.3 |1.3    |1.8 |2.5 |▇▁▁▅▃▃▂▂ |"
  )
  expect_equal(input[17], 
"|Sepal.Length |0       |150      |150 |5.84 |0.83 |4.3 |5.1 |5.8    |6.4 |7.9 |▂▇▅▇▆▅▂▂ |"
   )
  expect_equal(input[18], 
"|Sepal.Width  |0       |150      |150 |3.06 |0.44 |2   |2.8 |3      |3.3 |4.4 |▁▂▅▇▃▂▁▁ |"
   )
})

test_that("skimr::pander prints as expected", {
  # This assumes the default option for line length (80).

  input <- utils::capture.output(skim(chickwts) %>% pander::pander() )
  expect_equal(length(input), 36)
  expect_equal(input[1], "Skim summary statistics  ")
  expect_equal(input[2], "   n obs: 71    ")
  expect_equal(input[3], " n variables: 2    ")
  expect_equal(input[4], "")
  expect_equal(input[5], 
 "----------------------------------------------------------------------------"
 )
  expect_equal(input[6], 
 " variable   missing   complete   n    n_unique           top_counts         "
 )
  expect_equal(input[7], 
 "---------- --------- ---------- ---- ---------- ----------------------------"
 )
  expect_equal(input[8], 
 "   feed        0         71      71      6       soy: 14, cas: 12, lin: 12, "
 )
  expect_equal(input[9], 
 "                                                          sun: 12           "
 )
  expect_equal(input[10], 
 "----------------------------------------------------------------------------"
  )
  expect_equal(input[11], "")
  expect_equal(input[12], "Table: Table continues below")
  expect_equal(input[13], "")
  expect_equal(input[14], " ")
  expect_equal(input[15], "---------")
  expect_equal(input[16], " ordered ")
  expect_equal(input[17], "---------")
  expect_equal(input[18], "  FALSE  ")
  expect_equal(input[19], "---------")
  expect_equal(input[20], "")
  expect_equal(input[21], "")
  expect_equal(input[22], 
 "----------------------------------------------------------------------------"
  )
  expect_equal(input[23], 
 " variable   missing   complete   n     mean     sd     min    p25    median "
  )
  expect_equal(input[24], 
 "---------- --------- ---------- ---- -------- ------- ----- ------- --------"
  )
  expect_equal(input[25], 
 "  weight       0         71      71   261.31   78.07   108   204.5    258   "
  )
  expect_equal(input[26], 
 "----------------------------------------------------------------------------"
  )
  expect_equal(input[27], "")
  expect_equal(input[28], "Table: Table continues below")
  expect_equal(input[29], "")
  expect_equal(input[30], " ")
  # Windows does not support block characters 
  skip_on_os("windows")
  expect_equal(input[31], "------------------------")
  expect_equal(input[32], "  p75    max     hist   ")
  expect_equal(input[33], "------- ----- ----------")
  expect_equal(input[34], " 323.5   423   ▃▅▅▇▃▇▂▂ ")
  expect_equal(input[35], "------------------------")
  expect_equal(input[36], "")
})
