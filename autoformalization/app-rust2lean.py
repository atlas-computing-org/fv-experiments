import os
import dotenv
import tempfile
import streamlit as st
from subprocess import Popen, PIPE
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

dirpath = tempfile.mkdtemp()
codepath_charon = dirpath+"/code.rs"
codepath_aeneas = dirpath+"/code.llbc"
codepath_lean = dirpath+"/Code.lean"

# app title
st.title("🦀 Rust2Lean Demo")

st.markdown("Powered by [Aeneas](https://github.com/AeneasVerif/aeneas)")

st.header("Rust Code")
st.text_area(
    "Source language statement",
    label_visibility="collapsed",
    placeholder="Statement that you want translated",
    key="query"
)

st.header("Charon Output")
outbox_charon = st.text("")
errbox_charon = st.text("")

st.header("Aeneas Output")
outbox_aeneas = st.text("")
errbox_aeneas = st.text("")

st.header("Lean Code")
resultbox = st.text("")

st.header("Lean Output")
outbox_lean = st.text("")
errbox_lean = st.text("")

if st.session_state.query:
    resultbox.text("Translating...")
    
    # Charon
    with open(codepath_charon,"w") as codefile: 
       codefile.write(st.session_state.query)
    process_charon = Popen(["charon","--no-cargo","--input",codepath_charon,"--dest",dirpath], stdout=PIPE, stderr=PIPE)
    outstd_charon, errstd_charon = process_charon.communicate()
    outmsg_charon = outstd_charon.decode("utf-8").strip().replace(codepath_charon+":","")
    errmsg_charon = errstd_charon.decode("utf-8").strip()
    outbox_charon.text(outmsg_charon if outmsg_charon else "[None]")
    errbox_charon.text(errmsg_charon if errmsg_charon else "[None]")
        
    # Aeneas
    process_aeneas = Popen(["aeneas","-backend","lean",codepath_aeneas,"-dest",dirpath], stdout=PIPE, stderr=PIPE)
    outstd_aeneas, errstd_aeneas = process_aeneas.communicate()
    outmsg_aeneas = outstd_aeneas.decode("utf-8").strip().replace(codepath_aeneas+":","")
    errmsg_aeneas = errstd_aeneas.decode("utf-8").strip()
    outbox_aeneas.text(outmsg_aeneas if outmsg_aeneas else "[None]")
    errbox_aeneas.text(errmsg_aeneas if errmsg_aeneas else "[None]")
    with open(codepath_lean,"r") as codefile: 
       resultbox.text(codefile.read())

    # Lean
    process = Popen(["lean",codepath_lean], stdout=PIPE, stderr=PIPE)
    outstd_lean, errstd_lean= process.communicate()
    outmsg_lean = outstd_lean.decode("utf-8").strip().replace(codepath_lean+":","")
    errmsg_lean = errstd_lean.decode("utf-8").strip()
    outbox_lean.text(outmsg_lean if outmsg_lean else "[None]")
    errbox_lean.text(errmsg_lean if errmsg_lean else "[None]")
