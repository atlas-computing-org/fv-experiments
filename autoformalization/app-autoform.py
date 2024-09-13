import os
import yaml
import time
import dotenv
import tempfile
import streamlit as st
from subprocess import Popen, PIPE
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# set up language model
dotenv.load_dotenv()
os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY")
model = ChatAnthropic(model="claude-3-5-sonnet-20240620")

# set up prompt and parser
system_template = "You are an expert in the {language} programming language. You will be given a theorem that is stated in natural langauge. Please translate it into a formal {language} theorem. Return only the formal code. Do not provide any explanations:"
prompt = ChatPromptTemplate.from_messages([("system", system_template), ("user", "{text}")])
parser = StrOutputParser()
chain = prompt | model | parser

# set up language options
language_options = ["Lean", "Frama-C", "Dafny", "Coq", "Agda", "F-star", "Why3"]

# set up demo samples
samples = {"(Load Example)": {"input": "", "language": language_options[0]}}
with open("./examples/ex-autoinform.yaml") as stream:
    try:
        samples.update(yaml.safe_load(stream))
    except yaml.YAMLError as exc:
        print(exc)
sample_options = list(samples.keys())
print(samples)
print(sample_options)


if "codepath" not in st.session_state:
    st.session_state.codepath = tempfile.mkdtemp()+"/code.txt"

if "sample" not in st.session_state:
    st.session_state.sample = sample_options[0]

if "natural" not in st.session_state:
    st.session_state.natural = ""

if "language" not in st.session_state:
    st.session_state.language = language_options[0]

if "result" not in st.session_state:
    st.session_state.result = ""

if "outbox" not in st.session_state:
    st.session_state.outbox = ""

if "errbox" not in st.session_state:
    st.session_state.errbox = ""

# callbacks
def translate():
    with st.spinner("Translating..."):
        result = chain.invoke({"language": st.session_state.language, "text": st.session_state.natural})
    st.session_state.result = result
    
    if st.session_state.language == "Lean":
        with open(st.session_state.codepath,"w") as codefile: 
            codefile.write(result)
        process = Popen(["lean",st.session_state.codepath], stdout=PIPE, stderr=PIPE)
        stdout, stderr = process.communicate()
        outmsg = stdout.decode("utf-8").strip().replace(st.session_state.codepath+":","")
        errmsg = stderr.decode("utf-8").strip()
        if outmsg:
            st.session_state.outbox = outmsg
        else:
            st.session_state.outbox = "[None]"
        if errmsg:
            st.session_state.errbox = errmsg

def update_sample():
    st.session_state.natural = samples[st.session_state.sample]["input"]
    st.session_state.language = samples[st.session_state.sample]["language"]

# app title
st.title("🔨 Autoformalization Demo")

st.header("Natural Specification")

st.text_area(
    "Statement",
    placeholder="What do you want to formalize?",
    key="natural"
)

st.selectbox(
    "Target Language",
    language_options,
    key="language"
)

st.button(
    "Translate",
    on_click=translate
)

st.header("Formal Specification")
st.markdown(st.session_state.result)

if st.session_state.language == "Lean":
    st.header("Compiler Messages")
    st.text(st.session_state.outbox)
    st.text(st.session_state.errbox)

st.markdown("#")

st.selectbox(
    "(Load example)",
    sample_options,
    label_visibility="collapsed",
    key="sample",
    on_change=update_sample
)
