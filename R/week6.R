# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringi)
library(tidyverse)
# library()
# library()

# Data Import 
citations <- stri_read_lines(con = "../data/cites.txt")
citations_txt <- citations[!stri_isempty(citations)]
print(str_c("The number of blank lines eliminated was ", length(citations) - length(citations_txt)))
print(str_c("The average number of characters/citation was ", mean(str_length(citations_txt))))

# Data Cleaning 
slice_sample(citations_tbl, n = 20) %>%
View("Random Citations")
citations_tbl <- tibble(line = 1:length(citations_txt), cite = citations_txt) %>%
  mutate(authors = str_extract(cite, "^.*?(?=\\s\\()"),  
           year = str_extract(cite, "(?<=\\()\\d{4}(?=\\))"),
           title = str_extract(cite, "(?<=\\)\\.\\s)[^.(]+"),
           journal_title = str_extract(cite, "(?<=\\.\\s)[^.,]+(?=,\\s[0-9])"),
           book_title = str_extract(cite, "(?<=In\\s[^,]{1,50},\\s)[^\\(]+|(?<=\\d{4}\\)\\.\\s)[^.(]+(?=\\.\\s[^0-9]+:)"), 
           journal_page_start = str_extract(cite, "(?<=[,:]\\s)[0-9]+(?=[–-])"), #(?<=,\\s)[0-9]+(?=[–-])
           journal_page_end = str_extract(cite, "(?<=[–-])[0-9]+(?=\\.)"),
           book_page_start = str_extract(cite, "(?<=pp\\.\\s)[0-9]+(?=-)"),
           book_page_end = str_extract(cite, "(?<=[–-])[0-9]+(?=\\))"),
           doi = str_extract(cite, "10\\.[0-9]{4,}/[-._;()/:A-Z0-9]+")) %>%
  mutate(perf_ref = str_detect(title, pattern = regex("performance", ignore_case = TRUE))) %>%
  mutate(first_author = str_extract(authors, "^[^&,]+,\\s[A-Z]\\.(?:\\s[A-Z]\\.)?"))

# Analysis