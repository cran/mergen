#' Self correct the code returned by the agent
#'
#' The function attempts to correct the code returned by the agent
#' by re-feeding to the agent with the error message. If there are no
#' error messages function returns the original response.
#'
#' @param agent An object containing the agent's information (e.g., type and model).
#' @param prompt The prompt text to send to the language model.
#' @param context Optional context to provide alongside the prompt (default is rbionfoExp).
#' @param attempts Numeric value denoting how many times the code should be sent back for fixing.
#' @param output.file Optional output file created holding parsed code
#' @param ... Additional arguments to be passed to the \code{\link{sendPrompt}} function.
#' @return A list containing the following elements:
#' \item{init.response}{A character vector representing the initial prompt response.}
#' \item{init.blocks}{A list of initial blocks.}
#' \item{final.blocks}{A list of final blocks.}
#' \item{code.works}{A boolean value indicating whether the code works.}
#' \item{exec.result}{A character string representing the execution results.}
#' \item{tried.attempts}{An integer representing the number of attempts.}
#' @seealso \code{\link{promptContext}} for predefined contexts to use.
#' @examples
#' \dontrun{
#'
#' response <- selfcorrect(agent,prompt,context=rbionfoExp, max_tokens = 500)
#' }
#' @export
selfcorrect<-function(agent,prompt,context=rbionfoExp,attempts=3,output.file=NULL,...){

  #---------------------------------------------------------------------------
  # Validate arguments
  assertthat::assert_that(
    assertthat::`%has_name%`(agent,c("name","model","API","url","headers","ai_api_key","type")),
    assertthat::noNA(agent)
  )

  assertthat::assert_that(
    assertthat::is.string(prompt),
    assertthat::noNA(prompt)
  )

  assertthat::assert_that(
    assertthat::is.string(context)
  )

  assertthat::assert_that(
    assertthat::is.number(attempts),
    assertthat::noNA(attempts)
  )

  if (!is.null(output.file)) {
    assertthat::assert_that(
      assertthat::is.string(output.file),
      assertthat::noNA(output.file)
    )
  }
  #------------------------------------------------------------------------------------------
  if (agent$API =="openai"){
    if (agent$type == "completion"){
      stop("selfcorrect cannot be used with type completion. Can only be used with type chat.")
    }
    }

  # Send prompt
  response <- sendPrompt(agent,prompt,context,return.type="text",...)

  # Clean the code backtick structure and install.packages calls
  response<-clean_code_blocks(response)

  initial.response <- response


  # Parse the code
  blocks <- extractCode(text=initial.response,delimiter="```")
  initial.blocks <- blocks

  # Check if any code is returned
  if(blocks$code==""){
    message(response)
    stop("no code returned")

  }

  # Extract and install packages if needed
  extractInstallPkg(blocks$code)


  # List of messages to the bot
  msgs<- list(
    list(
      "role" = "user",
      "content" = paste(context,"\n",prompt)
    ),
    list(
      "role"="assistant",
      "content"=initial.response
    )
  )




  # Define the prompt template to inject the error message
  promptTemplate <- "The previous code returned the following errors and/or warnings,\n <error> \n return fixed code in one block, delimited in triple backticks"

  # Set up the on of the final variables that will be returned in the end
  codeWorks=FALSE

  # Execute the code up to "attempts" times
  for(i in 1:attempts){

    # See if the code runs without errors
    res<-executeCode(blocks$code, output = "html",output.file = output.file )

    # If there are errors
    if(is.list(res) & ("error" %in% names(res) )){

      # Get error messages

      # Collapse the character vectors within the list elements
      # This is good if we have multiple errors in the list per element
      collapsed_list <- lapply(res, function(x) paste(x, collapse = "\n"))

      # Get error/warning text
      errs<-  paste(paste0(names(collapsed_list ), ": ", collapsed_list ), collapse = "\n ")

      # Use sub() to substitute the replacement string for the wildcard string
      promptAddon <- sub("<error>", errs, promptTemplate)

      # Get an updated prompt
      #new.prompt<-paste(response,promptAddon)
      new.prompt<-promptAddon


      # Send prompt
      msgs<-append(msgs,list(list("role" = "user","content" = new.prompt)))
      response <- sendPrompt(agent=agent, prompt=paste(response,promptAddon), return.type = "text",messages=msgs)
      msgs<-append(msgs,list(list("role" = "assistant","content" = response)))

      # Clean code from wrong backticks
      response<-clean_code_blocks(response)

      # Parse the code
      blocks<- extractCode(text=response,delimiter="```")

      # Extract and install libs needed
      extractInstallPkg(blocks$code)


    }else{
      # Break the loop if the code works without errors
      codeWorks=TRUE
      break

    }

  }


  # Return the latest code, initial prompt, and everything else
  return(list(init.response=initial.response,
              init.blocks=initial.blocks,
              final.response=response,
              final.blocks=blocks,
              code.works=codeWorks,
              exec.result=res,
              tried.attempts=i))
}
