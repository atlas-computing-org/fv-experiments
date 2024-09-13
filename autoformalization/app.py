import streamlit as st

st.set_page_config(page_title="Demos", page_icon="🤖")

home = st.Page("app-home.py", title="Home", icon="👉")
autoform = st.Page("app-autoform.py", title="Autoformalization", icon="🔨")
autoinform = st.Page("app-autoinform.py", title="Autoinformalization", icon="✏️")
interframe = st.Page("app-interframe.py", title="InterFramework", icon="🤝")
rust2lean = st.Page("app-rust2lean.py", title="Rust2Lean", icon="🦀")
chatbot = st.Page("app-chatbot.py", title="Chatbot", icon="💬")

pg = st.navigation([home, autoform, autoinform, interframe, rust2lean, chatbot])
pg.run()
