#' A data pre-processing Function
#'
#' This function processes chief complaints and generates a sequence of integers based on the
#' @param x a dataframe of strings
#' @keywords process
#' @export
#' @examples
#' process()

process <- function(x) {

  x <- gsub("0", "ZERO", x)
  x <- gsub("1", "ONE", x)
  x <- gsub("2", "TWO", x)
  x <- gsub("3", "THREE", x)
  x <- gsub("4", "FOUR", x)
  x <- gsub("5", "FIVE", x)
  x <- gsub("6", "SIX", x)
  x <- gsub("7", "SEVEN", x)
  x <- gsub("8", "EIGHT", x)
  x <- gsub("9", "NINE", x)
  x <- gsub('[[:punct:]]', '', x)

  sequences <- texts_to_sequences(tokenizer, x)

  data <- pad_sequences(sequences, maxlen = 100)
  return(data)
}
