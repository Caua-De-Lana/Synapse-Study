import streamlit as st


def metric_card(titulo, valor, legenda=""):
    st.markdown(
        f"""
        <div class="sf-card metric-card">
            <span>{titulo}</span>
            <strong>{valor}</strong>
            <small>{legenda}</small>
        </div>
        """,
        unsafe_allow_html=True,
    )


def section_card(titulo, texto):
    st.markdown(
        f"""
        <div class="sf-card">
            <h3>{titulo}</h3>
            <p>{texto}</p>
        </div>
        """,
        unsafe_allow_html=True,
    )
