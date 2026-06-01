import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import atualizar_status_topico, listar_materias, listar_topicos
from utils.helpers import carregar_css


carregar_css()
st.title("Checklist")
st.caption("Acompanhe tópico por tópico.")

materias = listar_materias()
if not materias:
    st.info("Nenhuma matéria cadastrada.")
    st.stop()

materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
for topico in listar_topicos(materia["id"]):
    with st.container(border=True):
        col1, col2, col3 = st.columns([4, 2, 2])
        col1.write(f"**{topico['ordem']}. {topico['titulo']}**")
        col1.caption(f"Concluído em: {topico.get('concluido_em') or '-'}")
        status = col2.selectbox(
            "Status",
            ["Não iniciado", "Em andamento", "Concluído"],
            index=["Não iniciado", "Em andamento", "Concluído"].index(topico["status"]) if topico["status"] in ["Não iniciado", "Em andamento", "Concluído"] else 0,
            key=f"status_{topico['id']}",
        )
        if col3.button("Atualizar", key=f"up_{topico['id']}"):
            atualizar_status_topico(topico["id"], status)
            st.rerun()
