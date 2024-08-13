from langchain_community.chat_models import ChatOllama
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser


model = ChatOllama(model="llama3", temperature=0)

system_template = "Translate the following into {language}:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)

parser = StrOutputParser()

chain = prompt | model | parser

print(chain.invoke({"language": "italian", "text": "hi"}))