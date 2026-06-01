import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import (
    listar_pdfs,
    obter_user_profile,
    obter_ou_criar_materia,
    obter_ou_criar_topico,
    resetar_onboarding,
    salvar_user_profile,
    salvar_pdf,
)
from utils.auth import CURSOS, foto_para_data_url
from utils.helpers import carregar_css, resumo_simples, sugerir_topicos_pdf
from utils.pdf_reader import extrair_texto_pdf


carregar_css()

st.title("Configurações")
st.caption("Ajustes do plano, upload de PDF e preparação para futuras integrações com IA.")

profile = obter_user_profile() or {}

st.subheader("Perfil acadêmico")
with st.form("perfil_academico"):
    nome = st.text_input("Nome", value=profile.get("nome") or "")
    curso_atual = profile.get("curso") or CURSOS[0]
    curso_index = CURSOS.index(curso_atual) if curso_atual in CURSOS else 0
    curso = st.selectbox("Curso", CURSOS, index=curso_index)
    foto = st.file_uploader("Foto de perfil (opcional)", type=["png", "jpg", "jpeg"])
    if st.form_submit_button("Salvar perfil", type="primary", disabled=not nome.strip()):
        foto_url = foto_para_data_url(foto) if foto else profile.get("foto_url", "")
        salvar_user_profile(
            nome,
            profile.get("areas_estudo", ""),
            profile.get("objetivo_estudo", ""),
            concluido=bool(profile.get("onboarding_concluido")),
            curso=curso,
            foto_url=foto_url,
        )
        st.success("Perfil atualizado.")
        st.rerun()

st.subheader("Plano de estudos")
if st.button("Refazer onboarding", type="primary"):
    resetar_onboarding()
    st.session_state.onboarding_step = 1
    st.success("Onboarding liberado. Você será redirecionado para a configuração inicial.")
    st.rerun()

with st.form("nova_materia"):
    st.write("Adicionar nova matéria")
    materia_nome = st.text_input("Matéria")
    topicos_texto = st.text_area("Tópicos iniciais", placeholder="Um tópico por linha")
    submitted = st.form_submit_button("Adicionar")

if submitted:
    if not materia_nome.strip():
        st.warning("Informe o nome da matéria.")
    else:
        materia_id = obter_ou_criar_materia(materia_nome.strip(), "Criada manualmente.")
        for ordem, titulo in enumerate([linha.strip() for linha in topicos_texto.splitlines() if linha.strip()], start=1):
            obter_ou_criar_topico(materia_id, titulo, ordem)
        st.success("Matéria adicionada.")

st.subheader("Upload de PDF")
arquivo = st.file_uploader("Enviar PDF da faculdade", type=["pdf"])
if arquivo:
    with st.spinner("Extraindo texto..."):
        texto = extrair_texto_pdf(arquivo)
        resumo = resumo_simples(texto)
        salvar_pdf(arquivo.name, texto, resumo)
    st.success("PDF salvo.")
    st.write("**Resumo simples**")
    st.write(resumo)
    st.write("**Tópicos sugeridos**")
    st.write(", ".join(sugerir_topicos_pdf(texto)))
    st.write("**Perguntas de revisão sugeridas**")
    for topico in sugerir_topicos_pdf(texto)[:3]:
        st.write(f"- Explique o conceito de {topico} com um exemplo prático.")

st.subheader("PDFs enviados")
pdfs = listar_pdfs()
if pdfs:
    for pdf in pdfs[:5]:
        with st.container(border=True):
            st.write(f"**{pdf['nome_arquivo']}**")
            st.caption(pdf["enviado_em"])
            st.write(pdf["resumo"] or "Sem resumo.")
else:
    st.info("Nenhum PDF enviado ainda.")

st.subheader("Integração futura")
st.info("O código já separa resumo, tópicos sugeridos e perguntas para facilitar uma futura integração com OpenAI/ChatGPT.")
