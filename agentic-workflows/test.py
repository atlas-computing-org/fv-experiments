import dotenv
import os

from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

dotenv.load_dotenv()
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")

model = ChatAnthropic(model="claude-3-5-sonnet-20240620")

system_template = "Translate the following into {language}:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)

parser = StrOutputParser()

chain = prompt | model | parser

print(chain.invoke({"language": "italian", "text": "hi"}))