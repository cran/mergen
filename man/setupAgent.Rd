% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setupAgent.R
\name{setupAgent}
\alias{setupAgent}
\title{set up an online LLM API for subsequent tasks}
\usage{
setupAgent(
  name = c("openai", "replicate"),
  type = NULL,
  model = NULL,
  ai_api_key = Sys.getenv("AI_API_KEY")
)
}
\arguments{
\item{name}{Name of the API you want to use. Currently supported APIs are "openai" and "replicate"}

\item{type}{Specify type of model (chat or completion). This parameter only needs to be specified when using 'openai}

\item{model}{LLM model you wish to use.
For openAI chat model examples are:
\itemize{
\item 'gtp-3-5-turbo'
\item 'gtp-4'}
For openAI completion models examples are:
\itemize{
\item 'text-curie-001'
\item 'text-davinci-002'}
For replicate models examples are:\itemize{
 \item llama-2-70b-chat ( as '02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3')
 \item llama-2-13b-chat ( as 'f4e2de70d66816a838a89eeeb621910adffb0dd0baba3976c96980970978018d')}
 For a full list of openAI models
 \href{https://platform.openai.com/docs/models/overview}{click here}. For a full list of Replicate models,
 \href{https://replicate.com/collections/language-models}{click here}.}

\item{ai_api_key}{personal API key for accessing LLM}
}
\value{
A list holding agent information.
}
\description{
This function sets up an large language model API for tasks.
}
\examples{
{
myAgent <- setupAgent(name="openai",type="chat",model="gpt-4",ai_api_key="my_key")

myAgent <- setupAgent(name="replicate",type=NULL,
                     model="02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
                     ai_api_key="my_key")
}
}
