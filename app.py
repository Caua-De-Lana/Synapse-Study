from pathlib import Path
import runpy

import streamlit as st

from database.database import init_db, onboarding_concluido
from utils.auth import ensure_auth, render_user_box
from utils.helpers import carregar_css


st.set_page_config(
    page_title="Synapse",
    page_icon="✦",
    layout="wide",
    initial_sidebar_state="collapsed",
)


ROOT = Path(__file__).resolve().parent

PAGES = {
    "dashboard": ("Dashboard", "pages/dashboard.py"),
    "plano": ("Plano", "pages/plano.py"),
    "quiz": ("Quiz", "pages/quiz.py"),
    "biblioteca": ("Biblioteca", "pages/resumos.py"),
    "calendario": ("Calendário", "pages/calendario.py"),
    "pastas": ("Pastas", "pages/pastas.py"),
    "estudar": ("Estudar", "pages/estudar.py"),
    "checklist": ("Checklist", "pages/checklist.py"),
    "flashcards": ("Flashcards", "pages/flashcards.py"),
    "perguntas": ("Perguntas", "pages/perguntas.py"),
    "hoje": ("Hoje", "pages/hoje.py"),
    "revisoes": ("Revisões", "pages/revisoes.py"),
    "notas": ("Notas", "pages/notas.py"),
    "configuracoes": ("Configurações", "pages/configuracoes.py"),
}

MAIN_NAV = ["dashboard", "plano", "quiz", "biblioteca", "calendario", "pastas"]
MORE_NAV = [
    "estudar",
    "checklist",
    "flashcards",
    "perguntas",
    "revisoes",
    "notas",
    "configuracoes",
]


def _select_page(page_key):
    st.session_state.current_page = page_key
    st.rerun()


def render_top_nav():
    if "current_page" not in st.session_state:
        st.session_state.current_page = "dashboard"

    st.markdown('<div class="sf-top-shell">', unsafe_allow_html=True)
    brand_col, *nav_cols, more_col = st.columns([1.25, .9, .9, .9, 1, .9, .9, .8])
    with brand_col:
        st.markdown(
            '<div class="sf-brand"><span>✦</span><div><strong>Synapse</strong><small>Segundo cérebro de estudos</small></div></div>',
            unsafe_allow_html=True,
        )

    for col, page_key in zip(nav_cols, MAIN_NAV):
        label, _ = PAGES[page_key]
        active = st.session_state.current_page == page_key
        with col:
            if st.button(label, key=f"nav_{page_key}", type="primary" if active else "secondary", use_container_width=True):
                _select_page(page_key)

    with more_col:
        menu_context = st.popover("Mais ▼", use_container_width=True) if hasattr(st, "popover") else st.expander("Mais")
        with menu_context:
            for page_key in MORE_NAV:
                label, _ = PAGES[page_key]
                active_marker = "• " if st.session_state.current_page == page_key else ""
                if st.button(f"{active_marker}{label}", key=f"nav_more_{page_key}", use_container_width=True):
                    _select_page(page_key)
    st.markdown("</div>", unsafe_allow_html=True)


def run_current_page():
    page_key = st.session_state.get("current_page", "dashboard")
    if page_key not in PAGES:
        page_key = "dashboard"
        st.session_state.current_page = page_key
    _, path = PAGES[page_key]
    runpy.run_path(str(ROOT / path), run_name="__main__")


init_db()
ensure_auth()
carregar_css()

if not onboarding_concluido():
    from pages.onboarding import render

    render()
    st.stop()

render_top_nav()
render_user_box()
run_current_page()
