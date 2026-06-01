import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import (
    current_user_id,
    excluir_resumo_anexado,
    fetch_all,
    listar_materias,
    listar_resumos_anexados,
    listar_topicos,
    salvar_resumo_anexado,
)
from utils.file_storage import salvar_upload
from utils.helpers import carregar_css


carregar_css()
st.title("Biblioteca")
st.caption("Seu material de estudo em um só lugar.")

busca = st.text_input("Pesquisar na biblioteca", placeholder="Lei de Ohm")
if busca.strip():
    termo = f"%{busca.strip()}%"
    resultados = []
    resultados.extend(
        {
            "tipo": row["tipo"],
            "titulo": row["titulo"],
            "origem": row["materia"],
            "texto": row.get("conteudo_texto") or row.get("caminho_arquivo") or "",
        }
        for row in fetch_all(
            """
            SELECT r.*, m.nome AS materia
            FROM resumos_anexados r
            JOIN materias m ON m.id = r.materia_id AND m.user_id = r.user_id
            WHERE r.user_id = ? AND (
                r.titulo LIKE ? OR COALESCE(r.conteudo_texto, '') LIKE ? OR COALESCE(r.tipo, '') LIKE ?
            )
            ORDER BY r.criado_em DESC
            """,
            (current_user_id(), termo, termo, termo),
        )
    )
    resultados.extend(
        {
            "tipo": "PDF",
            "titulo": row["nome_arquivo"],
            "origem": "PDF enviado",
            "texto": row.get("resumo") or "",
        }
        for row in fetch_all(
            """
            SELECT *
            FROM pdfs
            WHERE user_id = ? AND (nome_arquivo LIKE ? OR COALESCE(texto_extraido, '') LIKE ? OR COALESCE(resumo, '') LIKE ?)
            ORDER BY enviado_em DESC
            """,
            (current_user_id(), termo, termo, termo),
        )
    )
    resultados.extend(
        {
            "tipo": "Flashcard",
            "titulo": row["frente"],
            "origem": f"{row['materia']} > {row['topico']}",
            "texto": row["verso"],
        }
        for row in fetch_all(
            """
            SELECT f.*, t.titulo AS topico, m.nome AS materia
            FROM flashcards f
            JOIN topicos t ON t.id = f.topico_id AND t.user_id = f.user_id
            JOIN materias m ON m.id = t.materia_id AND m.user_id = t.user_id
            WHERE f.user_id = ? AND (f.frente LIKE ? OR f.verso LIKE ?)
            ORDER BY m.nome, t.ordem
            """,
            (current_user_id(), termo, termo),
        )
    )

    st.subheader("Resultados")
    if resultados:
        for item in resultados[:12]:
            with st.container(border=True):
                st.caption(f"{item['tipo']} · {item['origem']}")
                st.write(f"**{item['titulo']}**")
                if item["texto"]:
                    st.caption(str(item["texto"])[:220])
    else:
        st.info("Nada encontrado.")

materias = listar_materias()
if not materias:
    st.info("Cadastre uma matéria primeiro.")
    st.stop()

materia = st.selectbox("Matéria", materias, format_func=lambda item: item["nome"])
topicos = listar_topicos(materia["id"])
topico = st.selectbox("Tópico opcional", [{"id": None, "titulo": "Sem tópico"}] + topicos, format_func=lambda item: item["titulo"])
tipo_material = st.selectbox("Tipo de material", ["PDF", "Resumo", "Fórmula", "Nota", "Arquivo"])
titulo = st.text_input("Título")
arquivo = st.file_uploader("Arquivo", type=["pdf", "txt", "md", "png", "jpg", "jpeg"])
texto = st.text_area("Ou cole seu texto aqui", height=160)
if st.button("Salvar na biblioteca", type="primary") and titulo:
    caminho = salvar_upload(arquivo) if arquivo else None
    tipo = tipo_material if not caminho else f"{tipo_material} · {Path(caminho).suffix.replace('.', '').upper()}"
    salvar_resumo_anexado(materia["id"], topico["id"], titulo, tipo, caminho, texto)
    st.success("Material salvo.")
    st.rerun()

st.subheader("Materiais")
for resumo in listar_resumos_anexados():
    with st.container(border=True):
        st.write(f"**{resumo['titulo']}**")
        st.caption(f"{resumo['materia']} > {resumo.get('topico') or 'Sem tópico'} | {resumo['tipo']}")
        if resumo.get("conteudo_texto"):
            with st.expander("Visualizar texto"):
                st.write(resumo["conteudo_texto"])
        if resumo.get("caminho_arquivo"):
            st.caption(f"Arquivo: {resumo['caminho_arquivo']}")
        if st.button("Excluir", key=f"del_resumo_{resumo['id']}"):
            excluir_resumo_anexado(resumo["id"])
            st.rerun()
