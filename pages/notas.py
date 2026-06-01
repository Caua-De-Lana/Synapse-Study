import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import listar_materias, listar_resumos_anexados, listar_topicos, salvar_resumo_anexado
from utils.helpers import carregar_css


carregar_css()

st.title("Notas")
st.caption("Guarde anotações rápidas vinculadas às suas matérias.")

materias = listar_materias()
if not materias:
    st.warning("Cadastre uma matéria antes de criar notas.")
    st.stop()

with st.form("nova_nota", clear_on_submit=True):
    materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
    topicos = listar_topicos(materia["id"])
    opcoes_topico = [{"id": None, "titulo": "Sem tópico específico"}] + topicos
    topico = st.selectbox("Tópico", opcoes_topico, format_func=lambda item: item["titulo"])
    titulo = st.text_input("Título")
    conteudo = st.text_area("Nota", height=180)
    if st.form_submit_button("Salvar nota") and titulo.strip() and conteudo.strip():
        salvar_resumo_anexado(materia["id"], topico["id"], titulo, "Texto", conteudo_texto=conteudo)
        st.success("Nota salva.")

st.subheader("Notas salvas")
notas = [item for item in listar_resumos_anexados() if item["tipo"] == "Texto" and item.get("conteudo_texto")]
if not notas:
    st.info("Nenhuma nota salva ainda.")
else:
    for nota in notas:
        with st.container(border=True):
            st.caption(f"{nota['materia']} > {nota.get('topico') or 'Sem tópico'}")
            st.markdown(f"**{nota['titulo']}**")
            st.write(nota["conteudo_texto"])
