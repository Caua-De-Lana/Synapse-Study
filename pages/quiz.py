import random
import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import (
    listar_materias,
    listar_quiz,
    listar_quiz_materia,
    listar_topicos,
    registrar_resposta_quiz,
)
from utils.helpers import carregar_css
from utils.quiz_generator import garantir_quiz_materia, garantir_quiz_topico


carregar_css()

st.title("Eu realmente aprendi?")
st.caption("Responda perguntas rápidas geradas a partir dos seus tópicos.")

materias = listar_materias()
if not materias:
    st.warning("Nenhuma matéria cadastrada.")
    st.stop()

materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
topicos = listar_topicos(materia["id"])
if not topicos:
    st.info("Esta matéria ainda não tem tópicos.")
    st.stop()

modo = st.radio("Modo", ["Quiz por tópico", "Simular prova"], horizontal=True)

if modo == "Quiz por tópico":
    topico = st.selectbox("Tópico", topicos, format_func=lambda item: item["titulo"])
    if not listar_quiz(topico["id"]):
        garantir_quiz_topico(topico)
    perguntas = listar_quiz(topico["id"])
else:
    garantir_quiz_materia(topicos)
    perguntas = listar_quiz_materia(materia["id"])
    random.seed(42)
    perguntas = random.sample(perguntas, min(10, len(perguntas)))

if not perguntas:
    st.info("Ainda não há perguntas para este conteúdo.")
    if st.button("Gerar perguntas agora", type="primary"):
        if modo == "Quiz por tópico":
            garantir_quiz_topico(topico)
        else:
            garantir_quiz_materia(topicos)
        st.rerun()
    st.stop()

st.caption(f"{len(perguntas)} pergunta(s) disponíveis.")

acertos = 0
respondidas = 0
topicos_revisar = set()

with st.form("quiz_form"):
    respostas = {}
    for index, pergunta in enumerate(perguntas, start=1):
        st.markdown(f"**{index}. {pergunta['pergunta']}**")
        respostas[pergunta["id"]] = st.radio(
            "Alternativas",
            ["A", "B", "C", "D"],
            format_func=lambda letra, p=pergunta: f"{letra}) {p[f'alternativa_{letra.lower()}']}",
            key=f"quiz_{pergunta['id']}",
        )
    enviado = st.form_submit_button("Responder", type="primary")

if enviado:
    st.subheader("Resultado")
    for pergunta in perguntas:
        resposta = respostas[pergunta["id"]]
        acertou = resposta == pergunta["resposta_correta"]
        registrar_resposta_quiz(pergunta["id"], resposta, acertou)
        respondidas += 1
        acertos += int(acertou)
        if not acertou:
            topicos_revisar.add(pergunta.get("topico", "Tópico selecionado"))
        st.write(f"**{pergunta['pergunta']}**")
        st.write("Acertou" if acertou else f"Errou. Correta: {pergunta['resposta_correta']}")
        st.caption(pergunta["explicacao"])

    st.success(f"Pontuação final: {acertos}/{respondidas}")
    if topicos_revisar:
        st.warning("Revise: " + ", ".join(sorted(topicos_revisar)))
