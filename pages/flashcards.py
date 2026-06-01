import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import listar_flashcards, listar_materias, listar_topicos, registrar_flashcard_resposta, salvar_flashcard
from utils.helpers import carregar_css


carregar_css()

st.title("Flashcards")
st.caption("Revise um card por vez e registre acertos ou erros.")

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

with st.expander("Criar flashcard"):
    with st.form("novo_flashcard", clear_on_submit=True):
        frente = st.text_input("Frente / pergunta")
        verso = st.text_area("Verso / resposta")
        if st.form_submit_button("Adicionar") and frente and verso:
            salvar_flashcard(topico["id"], frente, verso)
            st.rerun()

cards = listar_flashcards(topico["id"])
if not cards:
    st.info("Ainda não há flashcards para este tópico.")
    st.stop()

index_key = f"flashcard_index_{topico['id']}"
flip_key = f"flashcard_flip_{topico['id']}"
if index_key not in st.session_state:
    st.session_state[index_key] = 0
if flip_key not in st.session_state:
    st.session_state[flip_key] = False

st.session_state[index_key] = st.session_state[index_key] % len(cards)
card = cards[st.session_state[index_key]]

st.caption(f"Card {st.session_state[index_key] + 1} de {len(cards)}")
with st.container(border=True):
    if st.session_state[flip_key]:
        st.markdown("#### Verso")
        st.info(card["verso"] or "Este card ainda não tem resposta cadastrada.")
    else:
        st.markdown("#### Frente")
        st.markdown(f"### {card['frente']}")

col_flip, col_ok, col_err, col_next = st.columns(4)
with col_flip:
    if st.button("Virar card", use_container_width=True):
        st.session_state[flip_key] = not st.session_state[flip_key]
        st.rerun()
with col_ok:
    if st.button("Acertei", use_container_width=True):
        registrar_flashcard_resposta(card["id"], True)
        st.success("Acerto registrado.")
with col_err:
    if st.button("Errei", use_container_width=True):
        registrar_flashcard_resposta(card["id"], False)
        st.warning("Erro registrado para revisão.")
with col_next:
    if st.button("Próximo card", use_container_width=True):
        st.session_state[index_key] = (st.session_state[index_key] + 1) % len(cards)
        st.session_state[flip_key] = False
        st.rerun()
