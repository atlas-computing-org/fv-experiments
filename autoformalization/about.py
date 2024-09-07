import streamlit as st

# app title
st.title("🖌️ About")

st.markdown("Read more about our [Toolchain](https://atlascomputing.org/ai-assisted-fv-toolchain.pdf)!")
st.markdown("These demos are brought to you by")

st.write(f'<a href="https://atlascomputing.org/"><img src="./app/static/atlas.png" width="300"></a>',unsafe_allow_html=True)
st.write(f'<a href="https://topos.institute/"><img src="./app/static/topos.png" width="300"></a>',unsafe_allow_html=True)
