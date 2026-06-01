import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import atualizar_materia_pasta, listar_materias_com_pasta, listar_pastas, obter_ou_criar_materia
from utils.helpers import carregar_css


carregar_css()
st.title("Matérias")
st.caption("Gerencie suas matérias e vincule-as a pastas.")

pastas = listar_pastas()
with st.form("nova_materia", clear_on_submit=True):
    nome = st.text_input("Nome da matéria")
    descricao = st.text_area("Descrição", height=80)
    pasta_nome = st.selectbox("Pasta", ["Sem pasta"] + [p["nome"] for p in pastas])
    submitted = st.form_submit_button("Adicionar matéria")

if submitted and nome.strip():
    materia_id = obter_ou_criar_materia(nome.strip(), descricao)
    pasta_id = next((p["id"] for p in pastas if p["nome"] == pasta_nome), None)
    atualizar_materia_pasta(materia_id, pasta_id)
    st.success("Matéria salva.")
    st.rerun()

for materia in listar_materias_com_pasta():
    with st.container(border=True):
        st.write(f"**{materia['nome']}**")
        st.caption(f"Pasta: {materia.get('pasta') or 'Sem pasta'}")
        nova_pasta = st.selectbox(
            "Alterar pasta",
            ["Sem pasta"] + [p["nome"] for p in pastas],
            key=f"pasta_mat_{materia['id']}",
        )
        if st.button("Salvar pasta", key=f"salvar_pasta_{materia['id']}"):
            pasta_id = next((p["id"] for p in pastas if p["nome"] == nova_pasta), None)
            atualizar_materia_pasta(materia["id"], pasta_id)
            st.rerun()
