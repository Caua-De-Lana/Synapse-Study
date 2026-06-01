import streamlit as st
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))

from components.cards import section_card
from components.progress import neon_progress
from components.timer import study_timer
from database.database import (
    STATUS_CONCLUIDO,
    atualizar_entendimento,
    concluir_topico,
    listar_flashcards,
    listar_materias,
    listar_topicos,
    obter_progresso_materia,
    registrar_flashcard_resposta,
)
from utils.helpers import carregar_css


carregar_css()

st.title("O que preciso aprender?")
st.caption("Um tópico por vez.")

materias = listar_materias()
if not materias:
    st.warning("Nenhuma matéria cadastrada.")
    st.stop()

materia_inicial = 0
if st.session_state.get("dashboard_materia_id"):
    materia_inicial = next(
        (i for i, item in enumerate(materias) if item["id"] == st.session_state.dashboard_materia_id),
        0,
    )
    st.session_state.pop("dashboard_materia_id", None)

materia = st.selectbox("Matéria", materias, index=materia_inicial, format_func=lambda item: item["nome"])
topicos = listar_topicos(materia["id"])
if not topicos:
    st.info("Esta matéria ainda não possui tópicos.")
    st.stop()

if "indice_topico" not in st.session_state:
    st.session_state.indice_topico = {}

indice = st.session_state.indice_topico.get(materia["id"])
if indice is None:
    indice = next((i for i, item in enumerate(topicos) if item["status"] != STATUS_CONCLUIDO), 0)
if st.session_state.get("dashboard_topico_id"):
    indice = next((i for i, item in enumerate(topicos) if item["id"] == st.session_state.dashboard_topico_id), indice)
    st.session_state.pop("dashboard_topico_id", None)
indice = max(0, min(indice, len(topicos) - 1))
st.session_state.indice_topico[materia["id"]] = indice
topico = topicos[indice]

progresso = obter_progresso_materia(materia["id"])
neon_progress(
    progresso["percentual"],
    f"{progresso['concluidos']} de {progresso['total']} tópicos concluídos",
)

st.subheader(f"{topico['ordem']}. {topico['titulo']}")
st.caption(f"Status: {topico['status']} | Entendimento: {topico['nivel_entendimento']}")

study_timer(materia["id"], topico["id"])

section_card("Resumo rápido", topico.get("resumo_rapido") or topico["explicacao"][:140])

with st.expander("Mostrar explicação completa"):
    section_card("Explicação completa", topico["explicacao"])
    section_card("Fórmula principal", topico["formula"] or "Sem fórmula principal cadastrada.")
    section_card("Analogia", topico["analogia"])
    section_card("Dica de prova", topico["dica_prova"])
    section_card("Aplicação prática", topico["aplicacao_pratica"])

section_card("Exemplo", topico["exemplo"])
section_card("Exercício rápido", topico["exercicio"])

st.subheader("Flashcards")
flashcards = listar_flashcards(topico["id"])
if flashcards:
    card = flashcards[0]
    with st.container(border=True):
        st.write(f"**{card['frente']}**")
        if st.toggle("Virar card", key=f"study_fc_{card['id']}"):
            st.info(card["verso"] or "Resposta não cadastrada.")
        col_a, col_b = st.columns(2)
        if col_a.button("Acertei", key=f"study_ok_{card['id']}"):
            registrar_flashcard_resposta(card["id"], True)
            st.success("Registrado.")
        if col_b.button("Errei", key=f"study_err_{card['id']}"):
            registrar_flashcard_resposta(card["id"], False)
            st.warning("Registrado.")
else:
    st.caption("Nenhum flashcard para este tópico ainda.")

if st.button("Fazer quiz deste conteúdo", use_container_width=True):
    st.session_state.current_page = "quiz"
    st.rerun()

if st.button("Não entendi", use_container_width=True):
    atualizar_entendimento(topico["id"], "Não entendi")
    st.info(topico["explicacao_extra"] or "Vamos simplificar: volte para a ideia principal e refaça o exemplo com números pequenos.")
    st.write(topico["outro_exemplo"] or "Tente resolver um caso menor antes de avançar.")

nivel = st.segmented_control(
    "Como foi seu estudo?",
    ["😵 Não entendi", "😐 Entendi parcialmente", "😎 Entendi bem"],
    default="😎 Entendi bem",
)

col1, col2, col3 = st.columns(3)
with col1:
    if st.button("Tópico anterior", use_container_width=True, disabled=indice == 0):
        st.session_state.indice_topico[materia["id"]] = indice - 1
        st.rerun()
with col2:
    if st.button("✓ Concluir tópico", type="primary", use_container_width=True):
        nivel_limpo = nivel.replace("😵 ", "").replace("😐 ", "").replace("😎 ", "")
        concluir_topico(topico["id"], nivel_limpo)
        st.success("Parabéns. Tópico concluído e revisões programadas.")
        st.session_state.indice_topico[materia["id"]] = min(indice + 1, len(topicos) - 1)
        st.rerun()
with col3:
    if st.button("Próximo tópico", use_container_width=True, disabled=indice == len(topicos) - 1):
        st.session_state.indice_topico[materia["id"]] = indice + 1
        st.rerun()

st.subheader("Tópicos concluídos")
concluidos = [item for item in topicos if item["status"] == STATUS_CONCLUIDO]
if concluidos:
    for item in concluidos:
        st.caption(f"{item['ordem']}. {item['titulo']}")
else:
    st.caption("Nenhum tópico concluído ainda.")
