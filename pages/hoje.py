from datetime import date
import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import listar_estudos_diarios, listar_materias, listar_topicos, registrar_estudo_diario
from utils.helpers import carregar_css


carregar_css()
st.title("Hoje")
st.caption("Registre o que você estudou hoje.")

materias = listar_materias()
if not materias:
    st.info("Cadastre uma matéria primeiro.")
    st.stop()

materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
topicos = listar_topicos(materia["id"])
topico = st.selectbox("Tópico", [{"id": None, "titulo": "Sem tópico específico"}] + topicos, format_func=lambda item: item["titulo"])
tempo = st.number_input("Tempo estudado em minutos", min_value=0, value=30)
obs = st.text_area("Observação rápida")
if st.button("Marcar como estudado hoje", type="primary"):
    registrar_estudo_diario(materia["id"], topico["id"], date.today().isoformat(), tempo, obs)
    st.success("Estudo registrado.")
    st.rerun()

st.subheader(f"Registros de {date.today().strftime('%d/%m/%Y')}")
total = 0
for item in listar_estudos_diarios():
    total += item["tempo_minutos"]
    with st.container(border=True):
        st.write(f"**{item['materia']}** - {item.get('topico') or 'Sem tópico'}")
        st.caption(f"{item['tempo_minutos']} min")
        st.write(item.get("observacao") or "")
st.metric("Tempo estudado hoje", f"{total:.0f} min")
