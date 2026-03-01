# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(stringr)
# library()
# library()

# Data Import 
citations <- stri_read_lines(con = "../data/cites.txt")
citations_txt <- citations[!stri_isempty(citations)]
print(paste0("The number of blank lines eliminated was ", length(citations) - length(citations_txt)))
print(paste0("The average number of characters/citation was ", mean(str_length(citations_txt))))

# Data Cleaning 