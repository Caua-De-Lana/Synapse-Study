import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import obter_user_profile, salvar_user_profile
from utils.auth import CURSOS, foto_para_data_url
from utils.helpers import carregar_css
from utils.onboarding_rules import gerar_plano_estudos


AREAS = [
    "Faculdade",
    "Ensino Médio",
    "Curso Técnico",
    "Concurso Público",
    "Vestibular / ENEM",
    "Programação",
    "Dados / Business Intelligence",
    "Engenharia",
    "Eletrônica",
    "Matemática",
    "Física",
    "Inglês",
    "Certificações",
    "Trabalho / Carreira",
    "Projetos pessoais",
    "Outro",
]


def render():
    carregar_css()
    profile = obter_user_profile() or {}

    st.title("Vamos configurar seus estudos")
    st.caption("Em poucos passos, o Synapse monta um plano inicial para você começar agora.")

    etapa = st.session_state.get("onboarding_step", 1)
    st.progress(etapa / 3)

    if etapa == 1:
        st.subheader("Etapa 1 — Escolher áreas de estudo")
        st.write("Selecione uma ou mais áreas.")

        selecionadas = set(st.session_state.get("onboarding_areas", []))
        cols = st.columns(4)
        for index, area in enumerate(AREAS):
            with cols[index % 4]:
                if st.checkbox(area, value=area in selecionadas, key=f"area_{area}"):
                    selecionadas.add(area)
                else:
                    selecionadas.discard(area)

        st.session_state.onboarding_areas = list(selecionadas)
        if st.button("Continuar", type="primary", disabled=not selecionadas):
            st.session_state.onboarding_step = 2
            st.rerun()

    elif etapa == 2:
        st.subheader("Etapa 2 — Informar o que precisa estudar")
        objetivo = st.text_area(
            "O que você precisa estudar para suas provas ou objetivos?",
            value=st.session_state.get("onboarding_objetivo", profile.get("objetivo_estudo", "")),
            placeholder=(
                "Exemplo:\n"
                "Tenho prova de Eletrônica Analógica em duas semanas e preciso estudar Lei de Ohm, "
                "Kirchhoff, Diodos e Transistores BJT.\n"
                "Também quero melhorar em SQL, principalmente JOIN, GROUP BY e Window Functions."
            ),
            height=220,
        )
        st.session_state.onboarding_objetivo = objetivo

        col1, col2 = st.columns(2)
        with col1:
            if st.button("Voltar"):
                st.session_state.onboarding_step = 1
                st.rerun()
        with col2:
            if st.button("Continuar", type="primary", disabled=not objetivo.strip()):
                st.session_state.onboarding_step = 3
                st.rerun()

    else:
        st.subheader("Etapa 3 — Gerar plano inicial")
        nome_padrao = profile.get("nome") or st.session_state.get("user_name") or ""
        nome = st.text_input("Nome", value=nome_padrao, placeholder="Seu nome")
        curso_atual = profile.get("curso") or st.session_state.get("user_course") or CURSOS[0]
        curso_index = CURSOS.index(curso_atual) if curso_atual in CURSOS else 0
        curso = st.selectbox("Curso", CURSOS, index=curso_index)
        foto = st.file_uploader("Foto de perfil (opcional)", type=["png", "jpg", "jpeg"])
        areas = st.session_state.get("onboarding_areas", [])
        objetivo = st.session_state.get("onboarding_objetivo", "")

        st.write("**Áreas selecionadas:** " + ", ".join(areas))
        st.write("**Objetivo:**")
        st.info(objetivo)

        col1, col2 = st.columns(2)
        with col1:
            if st.button("Voltar"):
                st.session_state.onboarding_step = 2
                st.rerun()
        with col2:
            if st.button("Finalizar configuração", type="primary", disabled=not nome.strip()):
                plano = gerar_plano_estudos(areas, objetivo)
                foto_url = foto_para_data_url(foto) if foto else profile.get("foto_url", "")
                salvar_user_profile(nome, areas, objetivo, concluido=True, curso=curso, foto_url=foto_url)
                st.session_state.onboarding_step = 1
                st.session_state.onboarding_areas = []
                st.session_state.onboarding_objetivo = ""
                st.success("Seu plano inicial de estudos foi criado.")
                for item in plano:
                    st.write(f"**{item['materia']}**: {', '.join(item['topicos'])}")
                st.balloons()
                st.button("Ir para o dashboard", on_click=st.rerun)
