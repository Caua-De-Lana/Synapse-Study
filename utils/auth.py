import base64
import os

import streamlit as st

from database.database import obter_user_profile, progresso_academico, salvar_user_profile


CURSOS = [
    "Engenharia da Computação",
    "Engenharia Elétrica",
    "Ciência da Computação",
    "ADS",
    "Medicina",
    "Direito",
    "Outro",
]


def _secret(name, default=None):
    try:
        return st.secrets.get(name, default)
    except Exception:
        return os.getenv(name, default)


def foto_para_data_url(uploaded_file):
    if not uploaded_file:
        return ""
    encoded = base64.b64encode(uploaded_file.getvalue()).decode("utf-8")
    return f"data:{uploaded_file.type};base64,{encoded}"


def supabase_auth_configured():
    return bool(_secret("SUPABASE_URL") and _secret("SUPABASE_ANON_KEY"))


def get_supabase_client():
    from supabase import create_client

    return create_client(_secret("SUPABASE_URL"), _secret("SUPABASE_ANON_KEY"))


def ensure_auth():
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
    if "user_id" not in st.session_state:
        st.session_state.user_id = None
    if "user_email" not in st.session_state:
        st.session_state.user_email = None

    if st.session_state.authenticated and st.session_state.user_id:
        return True

    if not supabase_auth_configured():
        st.session_state.authenticated = True
        st.session_state.user_id = "local-user"
        st.session_state.user_email = "demo@synapse.local"
        st.info("Modo local demo: configure SUPABASE_URL e SUPABASE_ANON_KEY em st.secrets para autenticação real.")
        return True

    st.title("Synapse")
    st.caption("Entre para acessar seu segundo cérebro de estudos.")

    tab_login, tab_signup = st.tabs(["Entrar", "Cadastrar"])
    supabase = get_supabase_client()

    with tab_login:
        email = st.text_input("E-mail", key="login_email")
        senha = st.text_input("Senha", type="password", key="login_password")
        if st.button("Entrar", type="primary", use_container_width=True):
            try:
                response = supabase.auth.sign_in_with_password({"email": email, "password": senha})
                st.session_state.authenticated = True
                st.session_state.user_id = response.user.id
                st.session_state.user_email = response.user.email
                st.rerun()
            except Exception as exc:
                st.error(f"Não foi possível entrar: {exc}")

    with tab_signup:
        nome = st.text_input("Nome", key="signup_name")
        email = st.text_input("E-mail", key="signup_email")
        senha = st.text_input("Senha", type="password", key="signup_password")
        curso = st.selectbox("Curso", CURSOS, key="signup_course")
        foto = st.file_uploader("Foto de perfil (opcional)", type=["png", "jpg", "jpeg"], key="signup_photo")
        if st.button("Criar conta", use_container_width=True, disabled=not nome.strip()):
            try:
                foto_url = foto_para_data_url(foto)
                response = supabase.auth.sign_up(
                    {
                        "email": email,
                        "password": senha,
                        "options": {"data": {"name": nome, "course": curso, "photo_url": foto_url}},
                    }
                )
                st.success("Conta criada. Confirme seu e-mail se o Supabase solicitar.")
                if response.user:
                    st.session_state.authenticated = True
                    st.session_state.user_id = response.user.id
                    st.session_state.user_email = response.user.email
                    st.session_state.user_name = nome
                    st.session_state.user_course = curso
                    st.session_state.user_photo_url = foto_url
                    salvar_user_profile(nome, [], "", concluido=False, curso=curso, foto_url=foto_url)
                    st.rerun()
            except Exception as exc:
                st.error(f"Não foi possível cadastrar: {exc}")

    st.stop()


def render_user_box():
    progresso = progresso_academico()
    profile = progresso["profile"] or obter_user_profile() or {}
    nome = profile.get("nome") or st.session_state.get("user_name") or "Estudante"
    curso = profile.get("curso") or "Curso não informado"
    foto_url = profile.get("foto_url") or ""
    inicial = nome.strip()[:1].upper() if nome.strip() else "S"
    nivel = progresso["nivel"]
    pontos = progresso["pontos"]

    if foto_url:
        avatar = f'<img class="sf-profile-img" src="{foto_url}" alt="{nome}">'
    else:
        avatar = f'<div class="sf-profile-avatar" style="border-color:{nivel["cor"]}; color:{nivel["cor"]};">{inicial}</div>'

    col_spacer, col_profile, col_exit = st.columns([4.7, 1.8, .55])
    with col_profile:
        pontos_formatados = f"{pontos:,}".replace(",", ".")
        st.markdown(
            f"""
            <div class="sf-profile-card">
                {avatar}
                <div>
                    <strong>{nome}</strong>
                    <span style="color:{nivel['cor']}">{nivel['nome']}</span>
                    <small>{curso}</small>
                    <small>{pontos_formatados} pts</small>
                </div>
            </div>
            """,
            unsafe_allow_html=True,
        )
    with col_exit:
        if st.button("Sair", use_container_width=True):
            for key in ["authenticated", "user_id", "user_email"]:
                st.session_state.pop(key, None)
            st.rerun()
