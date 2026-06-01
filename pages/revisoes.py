from datetime import date

import streamlit as st
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import listar_revisoes, marcar_revisado
from utils.helpers import carregar_css


carregar_css()

st.title("Revisões")
st.caption("Revise o que está vencendo hoje, atrasado ou programado para depois.")

hoje = date.today().isoformat()
revisoes = listar_revisoes()

atrasadas = [item for item in revisoes if item["data_revisao"] < hoje]
hoje_lista = [item for item in revisoes if item["data_revisao"] == hoje]
futuras = [item for item in revisoes if item["data_revisao"] > hoje]


def render_lista(titulo, dados):
    st.subheader(titulo)
    if not dados:
        st.info("Nada por aqui.")
        return
    for revisao in dados:
        with st.container(border=True):
            st.write(f"**{revisao['titulo']}**")
            st.caption(
                f"{revisao['materia']} | {revisao['data_revisao']} | "
                f"{revisao['nivel_entendimento']} | {revisao['tipo_revisao']}"
            )
            if st.button("Revisado", key=f"rev_{revisao['id']}"):
                marcar_revisado(revisao["id"])
                st.success("Revisão registrada.")
                st.rerun()


render_lista("Atrasadas", atrasadas)
render_lista("Para hoje", hoje_lista)
render_lista("Próximas revisões", futuras[:10])
