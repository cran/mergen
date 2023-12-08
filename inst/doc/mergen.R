## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup,include=FALSE------------------------------------------------------
library(mergen)

## -----------------------------------------------------------------------------
myAgent <- setupAgent(name="openai",type="chat",model="gpt-4",ai_api_key = "your_key")
myAgent

## -----------------------------------------------------------------------------
myAgent <- setupAgent(name="replicate",type=NULL,model="llama-2-70b-chat",ai_api_key="my_key")
myAgent

## ----eval=FALSE---------------------------------------------------------------
#  answer <- sendPrompt(myAgent,
#                       "how do I perform PCA on data in
#                       a file called test.txt?",return.type = "text")
#  answer

## ----echo = FALSE-------------------------------------------------------------
answer <- "\n\nThe following R code will read the file called \"test.txt\", normalize the table and do PCA. First, the code will read the file into an R data frame: \n\n```\ndata <- read.table(\"test.txt\", header = TRUE, sep = \"\\t\")\n```\n\nNext, the data will be normalized to the range of 0 to 1:\n\n```\nnormalized.data <- scale(data, center = TRUE, scale = TRUE)\n```\n\nFinally, the normalized data will be used to do a Principal Component Analysis (PCA):\n\n```\npca <- princomp(normalized.data)\n```"
print (answer)

## ----include=FALSE------------------------------------------------------------
botResponses <- list(
    "\n\nThe following R code will read the file called \"test.txt\", normalize the table and do PCA. First, the code will read the file into an R data frame: \n\n```R\ndata <- read.table(\"test.txt\", header = TRUE, sep = \"\\t\")\n```\n\nNext, the data will be normalized to the range of 0 to 1:\n\n```{r}\nnormalized.data <- scale(data, center = TRUE, scale = TRUE)\n```\n\nFinally, the normalized data will be used to do a Principal Component Analysis (PCA):\n\n```{R}\npca <- princomp(normalized.data)\n```",

    "\n\nThe second response.The following R code will read the file called \"test.txt\", normalize the table and do PCA. First, the code will read the file into an R data frame: \n\n```\ndata <- read.table(\"test.txt\", header = TRUE, sep = \"\\t\")\n```\n\nNext, the data will be normalized to the range of 0 to 1:\n\n```\nnormalized.data <- scale(data, center = TRUE, scale = TRUE)\n```\n\nFinally, the normalized data will be used to do a Principal Component Analysis (PCA):\n\n```\npca <- princomp(normalized.data)\n```",

    "\n\nThe third response.The following R code will read the file called \"test.txt\", normalize the table and do PCA. First, the code will read the file into an R data frame: \n\n```{r}\nplot(1:10)```\n\nNext, the data will be normalized to the range of 0 to 1:\n\n"
)

answer <- list(init.response=botResponses[[1]],
              init.blocks=extractCode(clean_code_blocks(botResponses[[1]])),
              final.response=botResponses[[3]],
              final.blocks=extractCode(clean_code_blocks(botResponses[[3]])),
              code.works=TRUE,
              exec.result="path/to/html/file",
              tried.attempts=3)

## ----eval=FALSE---------------------------------------------------------------
#  answer <- selfcorrect(myAgent, prompt="How do I perform PCA?",attempts=3)

## -----------------------------------------------------------------------------
print(answer)

## -----------------------------------------------------------------------------
code_cleaned <- clean_code_blocks(answer$final.response)
cat(code_cleaned)

## -----------------------------------------------------------------------------
final_code <- extractCode(code_cleaned,delimiter = "```")
print (final_code)

## -----------------------------------------------------------------------------
executeCode(final_code$code)

