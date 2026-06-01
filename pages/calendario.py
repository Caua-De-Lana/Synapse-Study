from datetime import date, timedelta
import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import criar_evento, excluir_evento, listar_eventos, listar_materias
from utils.helpers import carregar_css


carregar_css()
st.title("Calendário")
st.caption("Organize provas, trabalhos, revisões e metas.")

materias = listar_materias()
with st.form("novo_evento", clear_on_submit=True):
    titulo = st.text_input("Título")
    tipo = st.selectbox("Tipo", ["Prova", "Trabalho", "Revisão", "Estudo", "Entrega"])
    data_evento = st.date_input("Data", value=date.today())
    horario = st.text_input("Horário opcional", placeholder="19:30")
    materia = st.selectbox("Matéria", ["Nenhuma"] + [m["nome"] for m in materias])
    descricao = st.text_area("Descrição")
    if st.form_submit_button("Adicionar evento") and titulo:
        materia_id = next((m["id"] for m in materias if m["nome"] == materia), None)
        criar_evento(materia_id, titulo, descricao, data_evento.isoformat(), horario, tipo)
        st.rerun()

eventos = listar_eventos()
hoje = date.today()
semana_fim = hoje + timedelta(days=7)

for titulo, filtro in [
    ("Hoje", lambda e: str(e["data_evento"]) == hoje.isoformat()),
    ("Semana", lambda e: hoje.isoformat() <= str(e["data_evento"]) <= semana_fim.isoformat()),
    ("Todos os eventos", lambda e: True),
]:
    st.subheader(titulo)
    dados = [e for e in eventos if filtro(e)]
    if not dados:
        st.info("Sem eventos.")
    for evento in dados:
        with st.container(border=True):
            st.write(f"**{evento['titulo']}**")
            st.caption(f"{evento['tipo']} | {evento['data_evento']} {evento.get('horario') or ''} | {evento.get('materia') or 'Sem matéria'}")
            st.write(evento.get("descricao") or "")
            if st.button("Excluir", key=f"del_evento_{evento['id']}"):
                excluir_evento(evento["id"])
                st.rerun()
