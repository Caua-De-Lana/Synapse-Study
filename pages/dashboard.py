from datetime import date, timedelta
import sys
from pathlib import Path

import streamlit as st

sys.path.append(str(Path(__file__).resolve().parents[1]))

from database.database import (
    STATUS_CONCLUIDO,
    atualizar_meta_diaria,
    atualizar_tarefa_diaria,
    calcular_dias_seguidos,
    criar_tarefa_diaria,
    current_user_id,
    estudo_ultimos_7_dias,
    excluir_tarefa_diaria,
    fetch_all,
    fetch_one,
    listar_tarefas_diarias,
    obter_user_profile,
    ultima_sessao_estudo,
)
from utils.helpers import carregar_css, minutos_para_texto


TEMPO_TOPICO_MIN = 32
DIAS_SEMANA = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]

carregar_css()


def dias_restantes(data_evento):
    return (date.fromisoformat(str(data_evento)) - date.today()).days if data_evento else None


def proxima_prova():
    return fetch_one(
        """
        SELECT e.*, m.nome AS materia
        FROM eventos_calendario e
        LEFT JOIN materias m ON m.id = e.materia_id AND m.user_id = e.user_id
        WHERE e.user_id = ? AND e.tipo = 'Prova' AND e.data_evento >= ?
        ORDER BY e.data_evento, e.horario
        LIMIT 1
        """,
        (current_user_id(), date.today().isoformat()),
    )


def proximo_topico():
    return fetch_one(
        """
        SELECT t.*, m.nome AS materia
        FROM topicos t
        JOIN materias m ON m.id = t.materia_id AND m.user_id = t.user_id
        WHERE t.user_id = ? AND t.status != ?
        ORDER BY m.nome, t.ordem, t.id
        LIMIT 1
        """,
        (current_user_id(), STATUS_CONCLUIDO),
    )


def tempo_total():
    sessoes = fetch_one(
        "SELECT COALESCE(SUM(duracao_minutos), 0) AS total FROM sessoes_estudo WHERE user_id = ?",
        (current_user_id(),),
    )["total"]
    diario = fetch_one(
        "SELECT COALESCE(SUM(tempo_minutos), 0) AS total FROM estudos_diarios WHERE user_id = ?",
        (current_user_id(),),
    )["total"]
    return sessoes + diario


def tempo_hoje():
    hoje = date.today().isoformat()
    sessoes = fetch_one(
        "SELECT COALESCE(SUM(duracao_minutos), 0) AS total FROM sessoes_estudo WHERE user_id = ? AND DATE(inicio) = ?",
        (current_user_id(), hoje),
    )["total"]
    diario = fetch_one(
        "SELECT COALESCE(SUM(tempo_minutos), 0) AS total FROM estudos_diarios WHERE user_id = ? AND data_estudo = ?",
        (current_user_id(), hoje),
    )["total"]
    return sessoes + diario


def resumo_por_materia():
    materias = fetch_all(
        """
        SELECT m.id, m.nome, COUNT(t.id) AS total_topicos,
               SUM(CASE WHEN t.status = ? THEN 1 ELSE 0 END) AS concluidos
        FROM materias m
        LEFT JOIN topicos t ON t.materia_id = m.id AND t.user_id = m.user_id
        WHERE m.user_id = ?
        GROUP BY m.id, m.nome
        ORDER BY m.nome
        """,
        (STATUS_CONCLUIDO, current_user_id()),
    )
    cards = []
    for materia in materias:
        total = materia["total_topicos"] or 0
        concluidos = materia["concluidos"] or 0
        restantes = max(total - concluidos, 0)
        ultimo = fetch_one(
            """
            SELECT t.titulo
            FROM sessoes_estudo s
            LEFT JOIN topicos t ON t.id = s.topico_id AND t.user_id = s.user_id
            WHERE s.user_id = ? AND s.materia_id = ?
            ORDER BY s.fim DESC, s.inicio DESC
            LIMIT 1
            """,
            (current_user_id(), materia["id"]),
        )
        cards.append({
            **materia,
            "restantes": restantes,
            "tempo_restante": restantes * TEMPO_TOPICO_MIN,
            "progresso": concluidos / total if total else 0,
            "ultimo_topico": ultimo["titulo"] if ultimo and ultimo["titulo"] else "Ainda não iniciado",
        })
    return cards


st.title("O que fazer agora?")
st.caption("O Synapse mostra o próximo passo. Sem ruído.")

prova = proxima_prova()
topico = proximo_topico()
ultima = ultima_sessao_estudo()
profile = obter_user_profile() or {}
meta = int(profile.get("meta_diaria_minutos") or 45)
hoje_min = tempo_hoje()

col1, col2 = st.columns(2)
with col1:
    if prova:
        restantes = dias_restantes(prova["data_evento"])
        st.markdown(
            f"""
            <div class="sf-card sf-focus-card">
                <span>Próxima prova</span>
                <h2>{prova['materia'] or prova['titulo']}</h2>
                <p>{restantes} dias restantes</p>
            </div>
            """,
            unsafe_allow_html=True,
        )
    else:
        st.markdown('<div class="sf-card sf-focus-card"><span>Próxima prova</span><h2>Nenhuma prova</h2><p>Cadastre uma prova no Plano ou Calendário.</p></div>', unsafe_allow_html=True)

with col2:
    if topico:
        st.markdown(
            f"""
            <div class="sf-card sf-focus-card">
                <span>Próximo tópico</span>
                <h2>{topico['titulo']}</h2>
                <p>{topico['materia']} · {TEMPO_TOPICO_MIN} min estimados</p>
            </div>
            """,
            unsafe_allow_html=True,
        )
        if st.button("Continuar estudando", type="primary", use_container_width=True):
            st.session_state.current_page = "estudar"
            st.session_state.dashboard_materia_id = topico["materia_id"]
            st.session_state.dashboard_topico_id = topico["id"]
            st.rerun()

col3, col4 = st.columns(2)
with col3:
    st.markdown('<div class="sf-card"><h3>Última sessão</h3>', unsafe_allow_html=True)
    if ultima:
        st.write(f"**{ultima['materia']}**")
        st.write(ultima["topico"] or "Sem tópico específico")
        st.caption("Você parou aqui.")
        if st.button("Voltar para este ponto", use_container_width=True):
            st.session_state.current_page = "estudar"
            st.session_state.dashboard_materia_id = ultima["materia_id"]
            if ultima["topico_id"]:
                st.session_state.dashboard_topico_id = ultima["topico_id"]
            st.rerun()
    else:
        st.caption("Nenhuma sessão registrada ainda.")
    st.markdown("</div>", unsafe_allow_html=True)

with col4:
    st.markdown('<div class="sf-card"><h3>Meta diária</h3>', unsafe_allow_html=True)
    st.write(f"**{meta} minutos**")
    st.write(f"{minutos_para_texto(hoje_min)} / {minutos_para_texto(meta)}")
    st.progress(min(hoje_min / meta, 1) if meta else 0)
    st.caption(f"Faltam {minutos_para_texto(max(meta - hoje_min, 0))}.")
    with st.expander("Ajustar meta"):
        nova_meta = st.number_input("Minutos por dia", min_value=5, max_value=300, value=meta, step=5)
        if st.button("Salvar meta"):
            atualizar_meta_diaria(nova_meta)
            st.rerun()
    st.markdown("</div>", unsafe_allow_html=True)

st.markdown('<div class="sf-card"><h3>Hoje</h3>', unsafe_allow_html=True)
tarefas = listar_tarefas_diarias()
if not tarefas and topico:
    criar_tarefa_diaria(f"Estudar {topico['titulo']}")
    tarefas = listar_tarefas_diarias()
for tarefa in tarefas:
    cols = st.columns([.12, .76, .12])
    with cols[0]:
        concluida = st.checkbox(
            f"Concluir {tarefa['titulo']}",
            value=bool(tarefa["concluida"]),
            key=f"task_{tarefa['id']}",
            label_visibility="collapsed",
        )
        if concluida != bool(tarefa["concluida"]):
            atualizar_tarefa_diaria(tarefa["id"], concluida)
            st.rerun()
    with cols[1]:
        st.write(tarefa["titulo"])
    with cols[2]:
        if st.button("Remover", key=f"del_task_{tarefa['id']}"):
            excluir_tarefa_diaria(tarefa["id"])
            st.rerun()
with st.expander("Adicionar tarefa"):
    nova = st.text_input("Tarefa")
    if st.button("Adicionar", disabled=not nova.strip()):
        criar_tarefa_diaria(nova.strip())
        st.rerun()
st.caption(f"{len(tarefas)} tarefa(s)")
st.markdown("</div>", unsafe_allow_html=True)

col5, col6 = st.columns(2)
with col5:
    st.markdown(f'<div class="sf-card"><h3>Horas estudadas</h3><h2>{minutos_para_texto(tempo_total())}</h2></div>', unsafe_allow_html=True)
with col6:
    st.markdown(f'<div class="sf-card"><h3>Dias seguidos</h3><h2>{calcular_dias_seguidos()}</h2></div>', unsafe_allow_html=True)

st.subheader("Tempo restante da matéria")
for materia in resumo_por_materia():
    with st.container(border=True):
        st.markdown(f"### {materia['nome']}")
        st.progress(materia["progresso"])
        st.caption(f"{materia['progresso'] * 100:.0f}% · {materia['restantes']} tópicos restantes")
        st.write(f"Tempo estimado: **{minutos_para_texto(materia['tempo_restante'])}**")
        st.write(f"Último tópico: **{materia['ultimo_topico']}**")

with st.expander("Últimos 7 dias"):
    total = 0
    for item in estudo_ultimos_7_dias():
        dia = date.fromisoformat(item["dia"])
        total += item["minutos"]
        st.write(f"**{DIAS_SEMANA[dia.weekday()]}:** {minutos_para_texto(item['minutos'])}")
    st.write(f"**Total:** {minutos_para_texto(total)}")
