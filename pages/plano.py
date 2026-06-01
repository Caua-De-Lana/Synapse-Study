from datetime import date, timedelta
import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import (
    STATUS_CONCLUIDO,
    criar_evento,
    current_user_id,
    fetch_all,
    listar_materias,
    listar_topicos,
)
from utils.helpers import carregar_css, minutos_para_texto


TEMPO_TOPICO_MIN = 32
DIAS_LABEL = ["Hoje", "Amanhã", "Dia seguinte"]

carregar_css()


def provas_futuras():
    return fetch_all(
        """
        SELECT e.*, m.nome AS materia
        FROM eventos_calendario e
        LEFT JOIN materias m ON m.id = e.materia_id AND m.user_id = e.user_id
        WHERE e.user_id = ? AND e.tipo = 'Prova' AND e.data_evento >= ?
        ORDER BY e.data_evento, e.horario
        """,
        (current_user_id(), date.today().isoformat()),
    )


def pendentes_materia(materia_id):
    return [
        topico
        for topico in listar_topicos(materia_id)
        if topico["status"] != STATUS_CONCLUIDO
    ]


def criar_cronograma(topicos, dias_restantes):
    dias_uteis = max(dias_restantes, 1)
    cronograma = []
    for index, topico in enumerate(topicos):
        dia_offset = min(index, dias_uteis - 1)
        data_estudo = date.today() + timedelta(days=dia_offset)
        cronograma.append({"data": data_estudo, "topico": topico})
    return cronograma


st.title("O que estudar até a prova?")
st.caption("Um plano curto, visual e direto.")

materias = listar_materias()
if not materias:
    st.info("Cadastre uma matéria antes de criar um plano.")
    st.stop()

with st.expander("Cadastrar prova"):
    with st.form("nova_prova"):
        materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
        nome = st.text_input("Nome da prova", value=materia["nome"])
        data_prova = st.date_input("Data da prova", value=date.today() + timedelta(days=7))
        if st.form_submit_button("Criar plano", type="primary"):
            criar_evento(materia["id"], nome, "Prova cadastrada pelo Plano.", data_prova.isoformat(), "", "Prova")
            st.rerun()

provas = provas_futuras()
if not provas:
    st.markdown('<div class="sf-card"><h3>Nenhuma prova cadastrada</h3><p>Cadastre uma prova acima para o Synapse montar o plano.</p></div>', unsafe_allow_html=True)
    st.stop()

prova = st.selectbox(
    "Prova",
    provas,
    format_func=lambda item: f"{item['titulo']} · {item['data_evento']}",
)

dias = max((date.fromisoformat(str(prova["data_evento"])) - date.today()).days, 0)
topicos = pendentes_materia(prova["materia_id"]) if prova.get("materia_id") else []
tempo_estimado = len(topicos) * TEMPO_TOPICO_MIN

st.markdown(
    f"""
    <div class="sf-card sf-focus-card">
        <span>Plano para prova</span>
        <h2>{prova['materia'] or prova['titulo']}</h2>
        <p>Faltam: <strong>{dias} dias</strong></p>
        <p>Tópicos pendentes: <strong>{len(topicos)}</strong></p>
        <p>Tempo estimado: <strong>{minutos_para_texto(tempo_estimado)}</strong></p>
    </div>
    """,
    unsafe_allow_html=True,
)

if not topicos:
    st.success("Todos os tópicos desta matéria estão concluídos.")
    st.stop()

cronograma = criar_cronograma(topicos, dias)
for index, item in enumerate(cronograma[: max(dias, 3)]):
    data_estudo = item["data"]
    if index < len(DIAS_LABEL):
        label = DIAS_LABEL[index]
    else:
        label = data_estudo.strftime("%d/%m")
    with st.container(border=True):
        concluido = st.checkbox(item["topico"]["titulo"], key=f"plano_{item['topico']['id']}")
        st.caption(label)
        if concluido:
            st.session_state.current_page = "estudar"
            st.session_state.dashboard_materia_id = item["topico"]["materia_id"]
            st.session_state.dashboard_topico_id = item["topico"]["id"]
            st.rerun()
