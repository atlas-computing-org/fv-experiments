import dotenv
import os
import streamlit as st
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# load language model
dotenv.load_dotenv()
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")
model = ChatAnthropic(model="claude-3-5-sonnet-20240620")

# set up prompt and parser
system_template = "You are an expert in the {language} programming language. You will be given a theorem that is stated in natural langauge. Please translate it into a formal {language} theorem. Return only the formal code. Do not provide any explanations:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)
parser = StrOutputParser()
chain = prompt | model | parser

# app title
# st.set_page_config(page_title="Autoformalization Demo", page_icon="🤖")
st.title("🤖 Autoformalization Demo")

st.header("Target Language")
st.selectbox(
    "Target formal language",
    ("Dafny", "Frama-C", "Lean", "Coq", "Agda", "F-star", "Why3"),
    label_visibility="collapsed",
    key="language"
)

col1, col2 = st.columns(2, gap="large")

with col1:
    st.header("Natural")
    st.text_area(
        "Natural language statement",
        label_visibility="collapsed",
        placeholder="Statement that you want translated",
        key="natural"
    )

with col2:
    if st.session_state.language:
        st.header(st.session_state.language)
    if st.session_state.natural and st.session_state.language:
        italian = st.markdown("Translating...")
        italian.markdown(chain.invoke({"language": st.session_state.language, "text": st.session_state.natural}))
