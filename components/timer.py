from datetime import datetime

import streamlit as st

from database.database import registrar_sessao


def study_timer(materia_id, topico_id):
    if "study_started_at" not in st.session_state:
        st.session_state.study_started_at = None

    col1, col2, col3 = st.columns(3)
    with col1:
        if st.button("Iniciar estudo", use_container_width=True):
            st.session_state.study_started_at = datetime.now()
            st.success("Sessão iniciada.")
    with col2:
        if st.button("Pausar", use_container_width=True):
            st.info("Sessão pausada. Finalize para registrar o tempo.")
    with col3:
        if st.button("Finalizar sessão", use_container_width=True):
            if st.session_state.study_started_at:
                duracao = registrar_sessao(
                    materia_id,
                    topico_id,
                    st.session_state.study_started_at,
                    datetime.now(),
                )
                st.session_state.study_started_at = None
                st.success(f"Sessão salva: {duracao:.1f} minutos.")
            else:
                st.warning("Inicie uma sessão antes de finalizar.")

    if st.session_state.study_started_at:
        st.caption(f"Estudo iniciado às {st.session_state.study_started_at.strftime('%H:%M:%S')}")
