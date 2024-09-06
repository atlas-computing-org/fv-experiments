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
system_template = "You are an expert in the {language} programming language. You will be given a theorem that is stated in natural langauge. Please translate it into a formal {language} theorem. Return only the formal code. Do not provide any explanations:"
prompt = ChatPromptTemplate.from_messages(
    [("system", system_template), ("user", "{text}")]
)
parser = StrOutputParser()
chain = prompt | model | parser

# app title
# st.set_page_config(page_title="Autoformalization Demo", page_icon="🤖")
st.title("🤖 Autoformalization Demo")

st.header("Natural Language")
st.text_area(
    "Natural language statement",
    label_visibility="collapsed",
    placeholder="Statement that you want translated",
    key="natural"
)

st.header("Target Language")
st.selectbox(
    "Target formal language",
    ("Lean", "Frama-C", "Dafny", "Coq", "Agda", "F-star", "Why3"),
    label_visibility="collapsed",
    key="language"
)
resultbox = st.markdown("")

if st.session_state.language == "Lean":
    st.header("Compiler Output")
    outbox = st.text("")

    st.header("Compiler Failures")
    errbox = st.text("")

if st.session_state.natural and st.session_state.language:
    resultbox.markdown("Translating...")
    result = chain.invoke({"language": st.session_state.language, "text": st.session_state.natural})
    
    if st.session_state.language == "Lean":
        with open(codepath,"w") as codefile: 
            codefile.write(result)
        resultbox.markdown(result)
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
