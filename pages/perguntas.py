import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import listar_materias, listar_perguntas, listar_topicos, registrar_resposta_pergunta
from utils.helpers import carregar_css


carregar_css()


def normalizar(texto):
    return (texto or "").strip().lower()


def corrigir(pergunta, resposta):
    correta = normalizar(pergunta["resposta_correta"])
    resposta_usuario = normalizar(resposta)
    if pergunta["tipo"] == "resposta_curta":
        return bool(resposta_usuario) and (
            resposta_usuario == correta
            or correta in resposta_usuario
            or resposta_usuario in correta
        )
    return resposta_usuario == correta or resposta_usuario.startswith(correta[:1])


st.title("Perguntas")
st.caption("Escolha uma matéria e um tópico para responder perguntas existentes.")

materias = listar_materias()
if not materias:
    st.warning("Nenhuma matéria cadastrada.")
    st.stop()

col_materia, col_topico = st.columns(2)
with col_materia:
    materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])

topicos = listar_topicos(materia["id"])
if not topicos:
    st.info("Esta matéria ainda não tem tópicos.")
    st.stop()

with col_topico:
    topico = st.selectbox("Tópico", topicos, format_func=lambda item: item["titulo"])

perguntas = listar_perguntas(topico["id"])
if not perguntas:
    st.info("Ainda não há perguntas cadastradas para este tópico.")
    st.stop()

st.subheader(f"{topico['titulo']}")

for index, pergunta in enumerate(perguntas, start=1):
    with st.container(border=True):
        st.caption(f"Pergunta {index} | {pergunta['tipo']}")
        st.write(f"**{pergunta['enunciado']}**")

        opcoes = [
            valor
            for valor in [
                pergunta.get("alternativa_a"),
                pergunta.get("alternativa_b"),
                pergunta.get("alternativa_c"),
                pergunta.get("alternativa_d"),
            ]
            if valor
        ]
        key_resposta = f"resp_p_{pergunta['id']}"
        if pergunta["tipo"] == "resposta_curta":
            resposta = st.text_input("Resposta", key=key_resposta)
        elif pergunta["tipo"] == "verdadeiro_falso" and not opcoes:
            resposta = st.radio("Resposta", ["Verdadeiro", "Falso"], key=key_resposta, horizontal=True)
        else:
            resposta = st.radio("Resposta", opcoes or ["Verdadeiro", "Falso"], key=key_resposta)

        if st.button("Responder", key=f"btn_p_{pergunta['id']}"):
            acertou = corrigir(pergunta, resposta)
            registrar_resposta_pergunta(pergunta["id"], resposta, acertou)
            st.session_state[f"resultado_p_{pergunta['id']}"] = {
                "acertou": acertou,
                "resposta": resposta,
            }

        resultado = st.session_state.get(f"resultado_p_{pergunta['id']}")
        if resultado:
            if resultado["acertou"]:
                st.success("Acertou!")
            else:
                st.error(f"Errou. Resposta correta: {pergunta['resposta_correta']}")
            if pergunta.get("explicacao"):
                st.info(pergunta["explicacao"])
