from pathlib import Path

import streamlit as st


def carregar_css():
    css_path = Path("assets/style.css")
    if css_path.exists():
        st.markdown(f"<style>{css_path.read_text(encoding='utf-8')}</style>", unsafe_allow_html=True)


def percentual(valor):
    return f"{valor * 100:.0f}%"


def minutos_para_texto(minutos):
    horas = int(minutos // 60)
    resto = int(minutos % 60)
    if horas:
        return f"{horas}h {resto}min"
    return f"{resto}min"


def resumo_simples(texto, limite=700):
    texto = " ".join((texto or "").split())
    if len(texto) <= limite:
        return texto
    return texto[:limite].rsplit(" ", 1)[0] + "..."


def sugerir_topicos_pdf(texto):
    palavras = [
        "resistor",
        "capacitor",
        "diodo",
        "transistor",
        "amplificador",
        "corrente",
        "tensão",
        "potência",
        "sensor",
        "fonte",
    ]
    texto_lower = (texto or "").lower()
    encontrados = [palavra.title() for palavra in palavras if palavra in texto_lower]
    return encontrados[:6] or ["Conceitos principais", "Fórmulas importantes", "Exercícios de revisão"]
