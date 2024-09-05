import streamlit as st

st.set_page_config(page_title="Demos", page_icon=":material/edit:")

create_page = st.Page("translate.py", title="Autoformalization", icon=":material/add_circle:")
delete_page = st.Page("chatbot.py", title="Chatbot", icon=":material/delete:")

pg = st.navigation([create_page, delete_page])
pg.run()
