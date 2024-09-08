import streamlit as st

st.set_page_config(page_title="Demos", page_icon="🤖")

autoform = st.Page("autoform.py", title="Autoformalization", icon="🔨")
autoinform = st.Page("autoinform.py", title="Autoinformalization", icon="✏️")
interframe = st.Page("interframe.py", title="InterFramework", icon="🤝")
chatbot = st.Page("chatbot.py", title="Chatbot", icon="💬")
about = st.Page("about.py", title="About", icon="👉")

pg = st.navigation([autoform, autoinform, interframe, chatbot, about])
pg.run()
