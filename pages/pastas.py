import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import criar_pasta, excluir_pasta, listar_materias_com_pasta, listar_pastas
from utils.helpers import carregar_css


carregar_css()
st.title("Pastas")
st.caption("Organize suas matérias por contexto.")

with st.form("nova_pasta", clear_on_submit=True):
    nome = st.text_input("Nome da pasta", placeholder="Faculdade, Provas, Programação...")
    descricao = st.text_area("Descrição", height=80)
    submitted = st.form_submit_button("Criar pasta")

if submitted and nome.strip():
    criar_pasta(nome.strip(), descricao)
    st.success("Pasta criada.")
    st.rerun()

pastas = listar_pastas()
materias = listar_materias_com_pasta()

if not pastas:
    st.info("Nenhuma pasta criada ainda.")
else:
    for pasta in pastas:
        with st.container(border=True):
            st.subheader(pasta["nome"])
            st.caption(pasta.get("descricao") or "Sem descrição.")
            vinculadas = [m["nome"] for m in materias if m.get("pasta_id") == pasta["id"]]
            st.write(", ".join(vinculadas) if vinculadas else "Sem matérias nesta pasta.")
            if st.button("Excluir", key=f"del_pasta_{pasta['id']}"):
                excluir_pasta(pasta["id"])
                st.rerun()
