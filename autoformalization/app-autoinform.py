import os
import dotenv
import tempfile
import streamlit as st
from subprocess import Popen, PIPE
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

codepath = tempfile.mkdtemp()+"/code.txt"

# load language model
dotenv.load_dotenv()
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")
model = ChatAnthropic(model="claude-3-5-sonnet-20240620")

# set up prompt and parser
system_template = "You are an expert in the {language} programming language. You will be given a formal theorem that is stated in the {language} programming language. Please summarize and describe what the theorem is about in natural language. After that, please explain what each line of code is doing, also in natural language:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)
parser = StrOutputParser()
chain = prompt | model | parser

# app title
st.title("✏️ Autoinformalization Demo")

st.header("Source Language")
st.selectbox(
    "Source language",
    ("Lean", "Frama-C", "Dafny", "Coq", "Agda", "F-star", "Why3"),
    label_visibility="collapsed",
    key="language"
)
st.text_area(
    "Source language statement",
    label_visibility="collapsed",
    placeholder="Statement that you want translated",
    key="formal"
)

st.header("Natural Language")
resultbox = st.markdown("")

if st.session_state.formal and st.session_state.language:
    resultbox.markdown("Translating...")
    result = chain.invoke({"language": st.session_state.language, "text": st.session_state.formal})
    resultbox.markdown(result)
