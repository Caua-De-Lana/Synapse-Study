import pandas as pd
import plotly.express as px
import streamlit as st
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import estatisticas_estudo, estudo_por_semana
from utils.helpers import carregar_css


carregar_css()

st.title("Estatísticas")
st.caption("Acompanhe tempo, evolução, quizzes e dificuldade.")

dados = estatisticas_estudo()

col1, col2 = st.columns(2)
with col1:
    st.subheader("Horas por matéria")
    horas = pd.DataFrame(dados["horas_por_materia"])
    if not horas.empty:
        st.plotly_chart(px.bar(horas, x="materia", y="horas", color="horas"), use_container_width=True)

with col2:
    st.subheader("Tópicos concluídos por matéria")
    concluidos = pd.DataFrame(dados["concluidos_por_materia"])
    if not concluidos.empty:
        st.plotly_chart(px.bar(concluidos, x="materia", y="concluidos", color="concluidos"), use_container_width=True)

st.subheader("Evolução semanal")
semana = pd.DataFrame(estudo_por_semana())
if not semana.empty:
    st.plotly_chart(px.line(semana, x="dia", y="minutos", markers=True), use_container_width=True)
else:
    st.info("Ainda não há sessões finalizadas.")

quiz = dados["quizzes"]
col3, col4, col5 = st.columns(3)
col3.metric("Quizzes feitos", quiz["total"])
col4.metric("Taxa média de acerto", f"{quiz['taxa'] * 100:.0f}%")
topico_dificil = dados["topico_dificil"]
col5.metric("Tópico com dificuldade", topico_dificil["titulo"] if topico_dificil else "Nenhum")
