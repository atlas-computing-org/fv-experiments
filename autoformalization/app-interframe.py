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
system_template = "You are an expert in the {source} and the {target} programming languages. You will be given code in {source} programming language. Translate the code to the {target} programming langauge. Give only the translated code. Do not give any explanations:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)
parser = StrOutputParser()
chain = prompt | model | parser

# app title
st.title("🤝 InterFramework Demo")

st.header("Source Language")
st.selectbox(
    "Source language",
    ("Lean", "Frama-C", "Dafny", "Coq", "Agda", "F-star", "Why3"),
    label_visibility="collapsed",
    key="source"
)
st.text_area(
    "Source language statement",
    label_visibility="collapsed",
    placeholder="Statement that you want translated",
    key="query"
)

st.header("Target Language")
st.selectbox(
    "Target language",
    ("Lean", "Frama-C", "Dafny", "Coq", "Agda", "F-star", "Why3"),
    label_visibility="collapsed",
    key="target"
)
resultbox = st.markdown("")

if st.session_state.target == "Lean":
    st.header("Compiler Output")
    outbox = st.text("")

    st.header("Compiler Failures")
    errbox = st.text("")

if st.session_state.query and st.session_state.source and st.session_state.target:
    resultbox.markdown("Translating...")
    result = chain.invoke({"source": st.session_state.source, "target": st.session_state.target, "text": st.session_state.query})
    resultbox.markdown(result)
    
    if st.session_state.target == "Lean":
        with open(codepath,"w") as codefile: 
            codefile.write(result)
        process = Popen(["lean",codepath], stdout=PIPE, stderr=PIPE)
        stdout, stderr = process.communicate()
        outmsg = stdout.decode("utf-8").strip().replace(codepath+":","")
        errmsg = stderr.decode("utf-8").strip()
        if outmsg:
            outbox.text(outmsg)
        else:
            outbox.text("[None]")      
        if errmsg:
            errbox.text(errmsg)
        else:
            errbox.text("[None]")