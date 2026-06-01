import streamlit as st

from utils.helpers import percentual


def neon_progress(valor, texto=""):
    st.progress(valor)
    st.caption(texto or percentual(valor))
