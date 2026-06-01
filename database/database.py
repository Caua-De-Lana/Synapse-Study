import os
import sqlite3
from contextlib import contextmanager
from datetime import date, datetime, timedelta
from pathlib import Path


try:
    import streamlit as st
except Exception:  # pragma: no cover - fallback for scripts/tests
    st = None


STATUS_PENDENTE = "Não iniciado"
STATUS_CONCLUIDO = "Concluído"
REVISAO_PENDENTE = "Pendente"
REVISAO_CONCLUIDA = "Concluída"

DB_PATH = Path(__file__).resolve().parent / "studyflow.db"

NIVEIS_ACADEMICOS = [
    {"nome": "Vestibulando", "min": 0, "max": 999, "cor": "#94A3B8"},
    {"nome": "Universitário", "min": 1000, "max": 4999, "cor": "#4DA3FF"},
    {"nome": "Tecnólogo", "min": 5000, "max": 14999, "cor": "#00D4FF"},
    {"nome": "Bacharel", "min": 15000, "max": 34999, "cor": "#00FF9D"},
    {"nome": "MBA", "min": 35000, "max": 69999, "cor": "#FFB800"},
    {"nome": "Mestre", "min": 70000, "max": 119999, "cor": "#C084FC"},
    {"nome": "Doutor", "min": 120000, "max": 199999, "cor": "#FF5C7A"},
    {"nome": "Pós-Doutor", "min": 200000, "max": None, "cor": "#F8FAFC"},
]

PONTOS_ACOES = {
    "concluir_topico": 100,
    "revisar_topico": 40,
    "responder_quiz": 20,
    "acertar_pergunta": 30,
    "sessao_estudo": 50,
    "anexar_resumo": 25,
    "criar_nota": 15,
    "criar_flashcard": 15,
}


def _secret(name, default=None):
    if st is not None:
        try:
            return st.secrets.get(name, default)
        except Exception:
            pass
    return os.getenv(name, default)


def using_postgres():
    return bool(_secret("SUPABASE_DB_URL"))


def current_user_id():
    if st is not None:
        return st.session_state.get("user_id", "local-user")
    return "local-user"


@contextmanager
def get_connection():
    if using_postgres():
        import psycopg
        from psycopg.rows import dict_row

        conn = psycopg.connect(_secret("SUPABASE_DB_URL"), row_factory=dict_row)
        try:
            yield conn
            conn.commit()
        finally:
            conn.close()
    else:
        conn = sqlite3.connect(DB_PATH)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA foreign_keys = ON")
        try:
            yield conn
            conn.commit()
        finally:
            conn.close()


def _sql(query):
    return query.replace("?", "%s") if using_postgres() else query


def _rows(rows):
    return [dict(row) for row in rows]


def fetch_all(query, params=()):
    with get_connection() as conn:
        return _rows(conn.execute(_sql(query), params).fetchall())


def fetch_one(query, params=()):
    with get_connection() as conn:
        row = conn.execute(_sql(query), params).fetchone()
        return dict(row) if row else None


def execute(query, params=()):
    with get_connection() as conn:
        sql = _sql(query)
        cursor = conn.execute(sql, params)
        if using_postgres():
            if sql.lstrip().upper().startswith("INSERT") and "RETURNING" in sql.upper():
                row = cursor.fetchone()
                return row["id"] if row and "id" in row else None
            return None
        return cursor.lastrowid


def insert_returning_id(query, params=()):
    if using_postgres() and "RETURNING" not in query.upper():
        query = query.rstrip().rstrip(";") + " RETURNING id"
    return execute(query, params)


def init_db():
    if using_postgres():
        _init_postgres()
    else:
        _init_sqlite()


def _init_sqlite():
    with get_connection() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS materias (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                pasta_id INTEGER,
                nome TEXT NOT NULL,
                descricao TEXT,
                criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (pasta_id) REFERENCES pastas(id) ON DELETE SET NULL
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS pastas (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                nome TEXT NOT NULL,
                descricao TEXT,
                criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS user_profile (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL UNIQUE,
                nome TEXT,
                curso TEXT DEFAULT '',
                foto_url TEXT DEFAULT '',
                pontos_total INTEGER NOT NULL DEFAULT 0,
                nivel_atual TEXT NOT NULL DEFAULT 'Vestibulando',
                meta_diaria_minutos INTEGER NOT NULL DEFAULT 45,
                areas_estudo TEXT DEFAULT '',
                objetivo_estudo TEXT DEFAULT '',
                onboarding_concluido INTEGER NOT NULL DEFAULT 0,
                criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS pontos_historico (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                acao TEXT NOT NULL,
                pontos INTEGER NOT NULL,
                criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(user_id, acao)
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS tarefas_diarias (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                titulo TEXT NOT NULL,
                data_tarefa TEXT NOT NULL,
                concluida INTEGER NOT NULL DEFAULT 0,
                criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS topicos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                materia_id INTEGER NOT NULL,
                ordem INTEGER NOT NULL DEFAULT 0,
                titulo TEXT NOT NULL,
                resumo_rapido TEXT DEFAULT '',
                formula TEXT DEFAULT '',
                explicacao TEXT DEFAULT '',
                analogia TEXT DEFAULT '',
                exemplo TEXT DEFAULT '',
                exercicio TEXT DEFAULT '',
                dica_prova TEXT DEFAULT '',
                aplicacao_pratica TEXT DEFAULT '',
                explicacao_extra TEXT DEFAULT '',
                outro_exemplo TEXT DEFAULT '',
                status TEXT NOT NULL DEFAULT 'Pendente',
                nivel_entendimento TEXT DEFAULT 'Não avaliado',
                concluido_em TEXT,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE CASCADE
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS revisoes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                topico_id INTEGER NOT NULL,
                data_revisao TEXT NOT NULL,
                status TEXT NOT NULL DEFAULT 'Pendente',
                tipo_revisao TEXT NOT NULL DEFAULT 'Revisão',
                revisado_em TEXT,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE CASCADE
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS sessoes_estudo (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                materia_id INTEGER NOT NULL,
                topico_id INTEGER,
                inicio TEXT NOT NULL,
                fim TEXT,
                duracao_minutos REAL NOT NULL DEFAULT 0,
                FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE CASCADE,
                FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE SET NULL
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS quiz (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                topico_id INTEGER NOT NULL,
                pergunta TEXT NOT NULL,
                alternativa_a TEXT NOT NULL,
                alternativa_b TEXT NOT NULL,
                alternativa_c TEXT NOT NULL,
                alternativa_d TEXT NOT NULL,
                resposta_correta TEXT NOT NULL,
                explicacao TEXT NOT NULL,
                FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE CASCADE
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS respostas_quiz (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                quiz_id INTEGER NOT NULL,
                resposta_usuario TEXT NOT NULL,
                acertou INTEGER NOT NULL,
                respondido_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (quiz_id) REFERENCES quiz(id) ON DELETE CASCADE
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS pdfs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL DEFAULT 'local-user',
                nome_arquivo TEXT NOT NULL,
                texto_extraido TEXT,
                resumo TEXT,
                enviado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        _criar_tabelas_universitarias_sqlite(conn)
        _migrar_sqlite(conn)


def _migrar_sqlite(conn):
    tabelas = [
        "materias", "topicos", "revisoes", "sessoes_estudo", "quiz",
        "respostas_quiz", "pdfs", "pastas", "flashcards",
        "flashcard_respostas", "perguntas", "respostas_perguntas",
        "eventos_calendario", "estudos_diarios", "resumos_anexados",
        "pontos_historico", "tarefas_diarias",
    ]
    for tabela in tabelas:
        colunas = [row["name"] for row in conn.execute(f"PRAGMA table_info({tabela})").fetchall()]
        if "user_id" not in colunas:
            conn.execute(f"ALTER TABLE {tabela} ADD COLUMN user_id TEXT")
            conn.execute(f"UPDATE {tabela} SET user_id = 'local-user' WHERE user_id IS NULL")

    topicos = [row["name"] for row in conn.execute("PRAGMA table_info(topicos)").fetchall()]
    for coluna, definicao in {
        "resumo_rapido": "TEXT DEFAULT ''",
        "formula": "TEXT DEFAULT ''",
        "explicacao_extra": "TEXT DEFAULT ''",
        "outro_exemplo": "TEXT DEFAULT ''",
        "dica_prova": "TEXT DEFAULT ''",
        "aplicacao_pratica": "TEXT DEFAULT ''",
        "nivel_entendimento": "TEXT DEFAULT 'Não avaliado'",
        "concluido_em": "TEXT",
    }.items():
        if coluna not in topicos:
            conn.execute(f"ALTER TABLE topicos ADD COLUMN {coluna} {definicao}")
    materias = [row["name"] for row in conn.execute("PRAGMA table_info(materias)").fetchall()]
    if "pasta_id" not in materias:
        conn.execute("ALTER TABLE materias ADD COLUMN pasta_id INTEGER")

    profile = [row["name"] for row in conn.execute("PRAGMA table_info(user_profile)").fetchall()]
    for coluna, definicao in {
        "curso": "TEXT DEFAULT ''",
        "foto_url": "TEXT DEFAULT ''",
        "pontos_total": "INTEGER NOT NULL DEFAULT 0",
        "nivel_atual": "TEXT NOT NULL DEFAULT 'Vestibulando'",
        "meta_diaria_minutos": "INTEGER NOT NULL DEFAULT 45",
    }.items():
        if coluna not in profile:
            conn.execute(f"ALTER TABLE user_profile ADD COLUMN {coluna} {definicao}")


def _criar_tabelas_universitarias_sqlite(conn):
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS flashcards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            topico_id INTEGER NOT NULL,
            frente TEXT NOT NULL,
            verso TEXT NOT NULL,
            criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE CASCADE
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS flashcard_respostas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            flashcard_id INTEGER NOT NULL,
            acertou INTEGER NOT NULL,
            respondido_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (flashcard_id) REFERENCES flashcards(id) ON DELETE CASCADE
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS perguntas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            topico_id INTEGER NOT NULL,
            tipo TEXT NOT NULL,
            enunciado TEXT NOT NULL,
            alternativa_a TEXT,
            alternativa_b TEXT,
            alternativa_c TEXT,
            alternativa_d TEXT,
            resposta_correta TEXT NOT NULL,
            explicacao TEXT,
            criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE CASCADE
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS respostas_perguntas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            pergunta_id INTEGER NOT NULL,
            resposta_usuario TEXT NOT NULL,
            acertou INTEGER NOT NULL,
            respondido_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (pergunta_id) REFERENCES perguntas(id) ON DELETE CASCADE
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS eventos_calendario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            materia_id INTEGER,
            titulo TEXT NOT NULL,
            descricao TEXT,
            data_evento TEXT NOT NULL,
            horario TEXT,
            tipo TEXT NOT NULL,
            criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE SET NULL
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS estudos_diarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            materia_id INTEGER NOT NULL,
            topico_id INTEGER,
            data_estudo TEXT NOT NULL,
            tempo_minutos REAL NOT NULL DEFAULT 0,
            observacao TEXT,
            criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE CASCADE,
            FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE SET NULL
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS resumos_anexados (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL DEFAULT 'local-user',
            materia_id INTEGER NOT NULL,
            topico_id INTEGER,
            titulo TEXT NOT NULL,
            tipo TEXT NOT NULL,
            caminho_arquivo TEXT,
            conteudo_texto TEXT,
            criado_em TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (materia_id) REFERENCES materias(id) ON DELETE CASCADE,
            FOREIGN KEY (topico_id) REFERENCES topicos(id) ON DELETE SET NULL
        )
        """
    )


def _init_postgres():
    with get_connection() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS materias (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                pasta_id BIGINT,
                nome TEXT NOT NULL,
                descricao TEXT,
                criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS pastas (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                nome TEXT NOT NULL,
                descricao TEXT,
                criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS user_profile (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL UNIQUE,
                nome TEXT,
                curso TEXT DEFAULT '',
                foto_url TEXT DEFAULT '',
                pontos_total INTEGER NOT NULL DEFAULT 0,
                nivel_atual TEXT NOT NULL DEFAULT 'Vestibulando',
                meta_diaria_minutos INTEGER NOT NULL DEFAULT 45,
                areas_estudo TEXT DEFAULT '',
                objetivo_estudo TEXT DEFAULT '',
                onboarding_concluido BOOLEAN NOT NULL DEFAULT false,
                criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS topicos (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                materia_id BIGINT NOT NULL REFERENCES materias(id) ON DELETE CASCADE,
                ordem INTEGER NOT NULL DEFAULT 0,
                titulo TEXT NOT NULL,
                resumo_rapido TEXT DEFAULT '',
                formula TEXT DEFAULT '',
                explicacao TEXT DEFAULT '',
                analogia TEXT DEFAULT '',
                exemplo TEXT DEFAULT '',
                exercicio TEXT DEFAULT '',
                dica_prova TEXT DEFAULT '',
                aplicacao_pratica TEXT DEFAULT '',
                explicacao_extra TEXT DEFAULT '',
                outro_exemplo TEXT DEFAULT '',
                status TEXT NOT NULL DEFAULT 'Pendente',
                nivel_entendimento TEXT DEFAULT 'Não avaliado',
                concluido_em TIMESTAMPTZ,
                created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS revisoes (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                topico_id BIGINT NOT NULL REFERENCES topicos(id) ON DELETE CASCADE,
                data_revisao DATE NOT NULL,
                status TEXT NOT NULL DEFAULT 'Pendente',
                tipo_revisao TEXT NOT NULL DEFAULT 'Revisão',
                revisado_em TIMESTAMPTZ,
                created_at TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS sessoes_estudo (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                materia_id BIGINT NOT NULL REFERENCES materias(id) ON DELETE CASCADE,
                topico_id BIGINT REFERENCES topicos(id) ON DELETE SET NULL,
                inicio TIMESTAMPTZ NOT NULL,
                fim TIMESTAMPTZ,
                duracao_minutos DOUBLE PRECISION NOT NULL DEFAULT 0
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS quiz (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                topico_id BIGINT NOT NULL REFERENCES topicos(id) ON DELETE CASCADE,
                pergunta TEXT NOT NULL,
                alternativa_a TEXT NOT NULL,
                alternativa_b TEXT NOT NULL,
                alternativa_c TEXT NOT NULL,
                alternativa_d TEXT NOT NULL,
                resposta_correta TEXT NOT NULL,
                explicacao TEXT NOT NULL
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS respostas_quiz (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                quiz_id BIGINT NOT NULL REFERENCES quiz(id) ON DELETE CASCADE,
                resposta_usuario TEXT NOT NULL,
                acertou BOOLEAN NOT NULL,
                respondido_em TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS pdfs (
                id BIGSERIAL PRIMARY KEY,
                user_id TEXT NOT NULL,
                nome_arquivo TEXT NOT NULL,
                texto_extraido TEXT,
                resumo TEXT,
                enviado_em TIMESTAMPTZ NOT NULL DEFAULT now()
            )
            """
        )
        for ddl in _postgres_extra_tables():
            conn.execute(ddl)
        for coluna, definicao in {
            "curso": "TEXT DEFAULT ''",
            "foto_url": "TEXT DEFAULT ''",
            "pontos_total": "INTEGER NOT NULL DEFAULT 0",
            "nivel_atual": "TEXT NOT NULL DEFAULT 'Vestibulando'",
            "meta_diaria_minutos": "INTEGER NOT NULL DEFAULT 45",
        }.items():
            conn.execute(f"ALTER TABLE user_profile ADD COLUMN IF NOT EXISTS {coluna} {definicao}")
        for tabela in [
            "materias", "topicos", "revisoes", "sessoes_estudo", "quiz",
            "respostas_quiz", "pdfs", "user_profile", "pastas",
            "flashcards", "flashcard_respostas", "perguntas",
            "respostas_perguntas", "eventos_calendario", "estudos_diarios",
            "resumos_anexados", "pontos_historico",
            "tarefas_diarias",
        ]:
            conn.execute(f"CREATE INDEX IF NOT EXISTS idx_{tabela}_user_id ON {tabela}(user_id)")


def _postgres_extra_tables():
    return [
        """
        CREATE TABLE IF NOT EXISTS flashcards (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            topico_id BIGINT NOT NULL REFERENCES topicos(id) ON DELETE CASCADE,
            frente TEXT NOT NULL,
            verso TEXT NOT NULL,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS flashcard_respostas (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            flashcard_id BIGINT NOT NULL REFERENCES flashcards(id) ON DELETE CASCADE,
            acertou BOOLEAN NOT NULL,
            respondido_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS perguntas (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            topico_id BIGINT NOT NULL REFERENCES topicos(id) ON DELETE CASCADE,
            tipo TEXT NOT NULL,
            enunciado TEXT NOT NULL,
            alternativa_a TEXT,
            alternativa_b TEXT,
            alternativa_c TEXT,
            alternativa_d TEXT,
            resposta_correta TEXT NOT NULL,
            explicacao TEXT,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS respostas_perguntas (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            pergunta_id BIGINT NOT NULL REFERENCES perguntas(id) ON DELETE CASCADE,
            resposta_usuario TEXT NOT NULL,
            acertou BOOLEAN NOT NULL,
            respondido_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS eventos_calendario (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            materia_id BIGINT REFERENCES materias(id) ON DELETE SET NULL,
            titulo TEXT NOT NULL,
            descricao TEXT,
            data_evento DATE NOT NULL,
            horario TEXT,
            tipo TEXT NOT NULL,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS estudos_diarios (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            materia_id BIGINT NOT NULL REFERENCES materias(id) ON DELETE CASCADE,
            topico_id BIGINT REFERENCES topicos(id) ON DELETE SET NULL,
            data_estudo DATE NOT NULL,
            tempo_minutos DOUBLE PRECISION NOT NULL DEFAULT 0,
            observacao TEXT,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS resumos_anexados (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            materia_id BIGINT NOT NULL REFERENCES materias(id) ON DELETE CASCADE,
            topico_id BIGINT REFERENCES topicos(id) ON DELETE SET NULL,
            titulo TEXT NOT NULL,
            tipo TEXT NOT NULL,
            caminho_arquivo TEXT,
            conteudo_texto TEXT,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS pontos_historico (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            acao TEXT NOT NULL,
            pontos INTEGER NOT NULL,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
            UNIQUE(user_id, acao)
        )
        """,
        """
        CREATE TABLE IF NOT EXISTS tarefas_diarias (
            id BIGSERIAL PRIMARY KEY,
            user_id TEXT NOT NULL,
            titulo TEXT NOT NULL,
            data_tarefa DATE NOT NULL,
            concluida BOOLEAN NOT NULL DEFAULT false,
            criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
        )
        """,
    ]


def obter_user_profile():
    profile = fetch_one(
        "SELECT * FROM user_profile WHERE user_id = ?",
        (current_user_id(),),
    )
    if profile:
        return profile
    user_email = ""
    if st is not None:
        user_email = st.session_state.get("user_email", "")
    nome = user_email.split("@")[0] if user_email else "Estudante"
    insert_returning_id(
        """
        INSERT INTO user_profile (user_id, nome, curso, pontos_total, nivel_atual, onboarding_concluido)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (current_user_id(), nome, "", 0, "Vestibulando", False),
    )
    return fetch_one("SELECT * FROM user_profile WHERE user_id = ?", (current_user_id(),))


def onboarding_concluido():
    profile = obter_user_profile()
    if not profile:
        return False
    return bool(profile.get("onboarding_concluido"))


def nivel_por_pontos(pontos):
    for nivel in NIVEIS_ACADEMICOS:
        if pontos >= nivel["min"] and (nivel["max"] is None or pontos <= nivel["max"]):
            return nivel
    return NIVEIS_ACADEMICOS[0]


def proximo_nivel(pontos):
    atual = nivel_por_pontos(pontos)
    indice = NIVEIS_ACADEMICOS.index(atual)
    if indice >= len(NIVEIS_ACADEMICOS) - 1:
        return None
    return NIVEIS_ACADEMICOS[indice + 1]


def progresso_academico():
    profile = obter_user_profile() or {}
    pontos = int(profile.get("pontos_total") or 0)
    atual = nivel_por_pontos(pontos)
    proximo = proximo_nivel(pontos)
    if proximo:
        base = atual["min"]
        alvo = proximo["min"]
        percentual = (pontos - base) / max(alvo - base, 1)
        faltam = max(alvo - pontos, 0)
    else:
        alvo = pontos
        percentual = 1
        faltam = 0
    return {
        "profile": profile,
        "pontos": pontos,
        "nivel": atual,
        "proximo": proximo,
        "alvo": alvo,
        "percentual": max(0, min(percentual, 1)),
        "faltam": faltam,
    }


def registrar_pontos(tipo_acao, referencia, pontos=None):
    user_id = current_user_id()
    pontos = pontos if pontos is not None else PONTOS_ACOES.get(tipo_acao, 0)
    if not pontos:
        return False
    acao = f"{tipo_acao}:{referencia}"
    existente = fetch_one(
        "SELECT id FROM pontos_historico WHERE user_id = ? AND acao = ?",
        (user_id, acao),
    )
    if existente:
        return False
    insert_returning_id(
        "INSERT INTO pontos_historico (user_id, acao, pontos) VALUES (?, ?, ?)",
        (user_id, acao, pontos),
    )
    total = fetch_one(
        "SELECT COALESCE(SUM(pontos), 0) AS total FROM pontos_historico WHERE user_id = ?",
        (user_id,),
    )["total"]
    nivel = nivel_por_pontos(int(total))["nome"]
    obter_user_profile()
    execute(
        "UPDATE user_profile SET pontos_total = ?, nivel_atual = ? WHERE user_id = ?",
        (int(total), nivel, user_id),
    )
    return True


def salvar_user_profile(nome, areas_estudo, objetivo_estudo, concluido=True, curso="", foto_url=""):
    user_id = current_user_id()
    areas = ", ".join(areas_estudo) if isinstance(areas_estudo, list) else (areas_estudo or "")
    existente = obter_user_profile()
    if existente:
        execute(
            """
            UPDATE user_profile
            SET nome = ?, curso = ?, foto_url = ?, areas_estudo = ?, objetivo_estudo = ?, onboarding_concluido = ?
            WHERE user_id = ?
            """,
            (
                nome,
                curso or existente.get("curso") or "",
                foto_url or existente.get("foto_url") or "",
                areas,
                objetivo_estudo,
                bool(concluido),
                user_id,
            ),
        )
        return existente["id"]
    return insert_returning_id(
        """
        INSERT INTO user_profile (user_id, nome, curso, foto_url, areas_estudo, objetivo_estudo, onboarding_concluido)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (user_id, nome, curso, foto_url, areas, objetivo_estudo, bool(concluido)),
    )


def resetar_onboarding():
    profile = obter_user_profile()
    if profile:
        execute(
            "UPDATE user_profile SET onboarding_concluido = ? WHERE user_id = ?",
            (False, current_user_id()),
        )


def atualizar_meta_diaria(minutos):
    execute(
        "UPDATE user_profile SET meta_diaria_minutos = ? WHERE user_id = ?",
        (int(minutos), current_user_id()),
    )


def criar_tarefa_diaria(titulo, data_tarefa=None):
    data_tarefa = data_tarefa or date.today().isoformat()
    return insert_returning_id(
        "INSERT INTO tarefas_diarias (user_id, titulo, data_tarefa) VALUES (?, ?, ?)",
        (current_user_id(), titulo, data_tarefa),
    )


def listar_tarefas_diarias(data_tarefa=None):
    data_tarefa = data_tarefa or date.today().isoformat()
    return fetch_all(
        """
        SELECT *
        FROM tarefas_diarias
        WHERE user_id = ? AND data_tarefa = ?
        ORDER BY concluida, criado_em
        """,
        (current_user_id(), data_tarefa),
    )


def atualizar_tarefa_diaria(tarefa_id, concluida):
    execute(
        "UPDATE tarefas_diarias SET concluida = ? WHERE user_id = ? AND id = ?",
        (bool(concluida), current_user_id(), tarefa_id),
    )


def excluir_tarefa_diaria(tarefa_id):
    execute("DELETE FROM tarefas_diarias WHERE user_id = ? AND id = ?", (current_user_id(), tarefa_id))


def ultima_sessao_estudo():
    return fetch_one(
        """
        SELECT s.*, m.nome AS materia, t.titulo AS topico
        FROM sessoes_estudo s
        JOIN materias m ON m.id = s.materia_id AND m.user_id = s.user_id
        LEFT JOIN topicos t ON t.id = s.topico_id AND t.user_id = s.user_id
        WHERE s.user_id = ?
        ORDER BY s.fim DESC, s.inicio DESC
        LIMIT 1
        """,
        (current_user_id(),),
    )


def estudo_ultimos_7_dias():
    inicio = date.today() - timedelta(days=6)
    rows = fetch_all(
        """
        SELECT dia, SUM(minutos) AS minutos
        FROM (
            SELECT DATE(inicio) AS dia, COALESCE(SUM(duracao_minutos), 0) AS minutos
            FROM sessoes_estudo
            WHERE user_id = ? AND DATE(inicio) >= ?
            GROUP BY DATE(inicio)
            UNION ALL
            SELECT data_estudo AS dia, COALESCE(SUM(tempo_minutos), 0) AS minutos
            FROM estudos_diarios
            WHERE user_id = ? AND data_estudo >= ?
            GROUP BY data_estudo
        )
        GROUP BY dia
        ORDER BY dia
        """,
        (current_user_id(), inicio.isoformat(), current_user_id(), inicio.isoformat()),
    )
    por_dia = {str(row["dia"]): row["minutos"] for row in rows}
    dias = []
    for i in range(7):
        dia = inicio + timedelta(days=i)
        dias.append({"dia": dia.isoformat(), "minutos": por_dia.get(dia.isoformat(), 0)})
    return dias


def obter_ou_criar_materia(nome, descricao=""):
    user_id = current_user_id()
    materia = fetch_one(
        "SELECT * FROM materias WHERE user_id = ? AND lower(nome) = lower(?)",
        (user_id, nome),
    )
    if materia:
        return materia["id"]
    return insert_returning_id(
        "INSERT INTO materias (user_id, nome, descricao) VALUES (?, ?, ?)",
        (user_id, nome, descricao),
    )


def obter_ou_criar_topico(materia_id, titulo, ordem, conteudo=None):
    user_id = current_user_id()
    topico = fetch_one(
        "SELECT * FROM topicos WHERE user_id = ? AND materia_id = ? AND lower(titulo) = lower(?)",
        (user_id, materia_id, titulo),
    )
    if topico:
        return topico["id"]
    conteudo = conteudo or {}
    return insert_returning_id(
        """
        INSERT INTO topicos (
            user_id, materia_id, ordem, titulo, formula, explicacao, analogia,
            resumo_rapido, exemplo, exercicio, dica_prova, aplicacao_pratica,
            explicacao_extra, outro_exemplo, status
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            user_id,
            materia_id,
            ordem,
            titulo,
            conteudo.get("formula", ""),
            conteudo.get("explicacao", f"Estude os conceitos principais de {titulo}."),
            conteudo.get("analogia", "Pense neste tópico como uma peça do seu mapa de estudos."),
            conteudo.get("resumo_rapido", f"Resumo direto de {titulo}: revise o conceito e pratique um exemplo."),
            conteudo.get("exemplo", "Resolva um exemplo pequeno antes de avançar."),
            conteudo.get("exercicio", f"Explique {titulo} com suas palavras."),
            conteudo.get("dica_prova", "Revise definição, fórmula e uma aplicação prática."),
            conteudo.get("aplicacao_pratica", "Use este tópico em exercícios e projetos reais."),
            conteudo.get("explicacao_extra", "Volte ao conceito básico e refaça o exemplo passo a passo."),
            conteudo.get("outro_exemplo", "Crie um exemplo com números simples."),
            STATUS_PENDENTE,
        ),
    )


def listar_materias():
    return fetch_all("SELECT * FROM materias WHERE user_id = ? ORDER BY nome", (current_user_id(),))


def listar_topicos(materia_id):
    return fetch_all(
        """
        SELECT *
        FROM topicos
        WHERE user_id = ? AND materia_id = ?
        ORDER BY ordem, id
        """,
        (current_user_id(), materia_id),
    )


def obter_progresso_materia(materia_id):
    user_id = current_user_id()
    total = fetch_one(
        "SELECT COUNT(*) AS total FROM topicos WHERE user_id = ? AND materia_id = ?",
        (user_id, materia_id),
    )["total"]
    concluidos = fetch_one(
        """
        SELECT COUNT(*) AS total
        FROM topicos
        WHERE user_id = ? AND materia_id = ? AND status = ?
        """,
        (user_id, materia_id, STATUS_CONCLUIDO),
    )["total"]
    return {
        "total": total,
        "concluidos": concluidos,
        "pendentes": max(total - concluidos, 0),
        "percentual": concluidos / total if total else 0,
    }


def obter_metricas_dashboard():
    user_id = current_user_id()
    materias = fetch_one("SELECT COUNT(*) AS total FROM materias WHERE user_id = ?", (user_id,))["total"]
    total_topicos = fetch_one("SELECT COUNT(*) AS total FROM topicos WHERE user_id = ?", (user_id,))["total"]
    concluidos = fetch_one(
        "SELECT COUNT(*) AS total FROM topicos WHERE user_id = ? AND status = ?",
        (user_id, STATUS_CONCLUIDO),
    )["total"]
    total_minutos = fetch_one(
        "SELECT COALESCE(SUM(duracao_minutos), 0) AS total FROM sessoes_estudo WHERE user_id = ?",
        (user_id,),
    )["total"]
    return {
        "materias": materias,
        "concluidos": concluidos,
        "pendentes": max(total_topicos - concluidos, 0),
        "progresso": concluidos / total_topicos if total_topicos else 0,
        "dias_seguidos": calcular_dias_seguidos(),
        "tempo_total": total_minutos,
    }


def progresso_por_materia():
    return fetch_all(
        """
        SELECT
            m.nome AS materia,
            COUNT(t.id) AS total,
            SUM(CASE WHEN t.status = ? THEN 1 ELSE 0 END) AS concluidos
        FROM materias m
        LEFT JOIN topicos t ON t.materia_id = m.id AND t.user_id = m.user_id
        WHERE m.user_id = ?
        GROUP BY m.id, m.nome
        ORDER BY m.nome
        """,
        (STATUS_CONCLUIDO, current_user_id()),
    )


def estudo_por_semana():
    if using_postgres():
        return fetch_all(
            """
            SELECT DATE(inicio) AS dia, COALESCE(SUM(duracao_minutos), 0) AS minutos
            FROM sessoes_estudo
            WHERE user_id = ? AND inicio >= now() - interval '7 days'
            GROUP BY DATE(inicio)
            ORDER BY dia
            """,
            (current_user_id(),),
        )
    return fetch_all(
        """
        SELECT substr(inicio, 1, 10) AS dia, COALESCE(SUM(duracao_minutos), 0) AS minutos
        FROM sessoes_estudo
        WHERE user_id = ? AND inicio >= date('now', '-7 days')
        GROUP BY substr(inicio, 1, 10)
        ORDER BY dia
        """,
        (current_user_id(),),
    )


def estatisticas_estudo():
    user_id = current_user_id()
    return {
        "horas_por_materia": fetch_all(
            """
            SELECT m.nome AS materia, COALESCE(SUM(s.duracao_minutos), 0) / 60.0 AS horas
            FROM materias m
            LEFT JOIN sessoes_estudo s ON s.materia_id = m.id AND s.user_id = m.user_id
            WHERE m.user_id = ?
            GROUP BY m.id, m.nome
            ORDER BY horas DESC
            """,
            (user_id,),
        ),
        "concluidos_por_materia": progresso_por_materia(),
        "quizzes": fetch_one(
            """
            SELECT COUNT(*) AS total, COALESCE(AVG(CASE WHEN acertou THEN 1.0 ELSE 0.0 END), 0) AS taxa
            FROM respostas_quiz
            WHERE user_id = ?
            """,
            (user_id,),
        ),
        "topico_dificil": fetch_one(
            """
            SELECT titulo, nivel_entendimento
            FROM topicos
            WHERE user_id = ? AND nivel_entendimento = 'Não entendi'
            ORDER BY updated_at DESC
            LIMIT 1
            """,
            (user_id,),
        ),
    }


def calcular_dias_seguidos():
    dias = [str(row["dia"]) for row in estudo_por_semana()]
    if not dias:
        return 0
    conjunto = set(dias)
    atual = date.today()
    total = 0
    while atual.isoformat() in conjunto:
        total += 1
        atual -= timedelta(days=1)
    return total


def concluir_topico(topico_id, nivel_entendimento="Dominei"):
    user_id = current_user_id()
    topico_atual = fetch_one("SELECT status FROM topicos WHERE id = ? AND user_id = ?", (topico_id, user_id))
    agora = datetime.now().isoformat(timespec="seconds")
    execute(
        """
        UPDATE topicos
        SET status = ?, nivel_entendimento = ?, concluido_em = ?, updated_at = CURRENT_TIMESTAMP
        WHERE id = ? AND user_id = ?
        """,
        (STATUS_CONCLUIDO, nivel_entendimento, agora, topico_id, user_id),
    )
    criar_revisoes(topico_id, nivel_entendimento)
    if not topico_atual or topico_atual.get("status") != STATUS_CONCLUIDO:
        registrar_pontos("concluir_topico", topico_id)


def atualizar_entendimento(topico_id, nivel_entendimento):
    user_id = current_user_id()
    execute(
        """
        UPDATE topicos
        SET nivel_entendimento = ?, updated_at = CURRENT_TIMESTAMP
        WHERE id = ? AND user_id = ?
        """,
        (nivel_entendimento, topico_id, user_id),
    )
    criar_revisoes(topico_id, nivel_entendimento)


def criar_revisoes(topico_id, nivel_entendimento):
    user_id = current_user_id()
    execute(
        "DELETE FROM revisoes WHERE topico_id = ? AND status = ? AND user_id = ?",
        (topico_id, REVISAO_PENDENTE, user_id),
    )
    if nivel_entendimento == "Não entendi":
        dias = [1]
    elif nivel_entendimento == "Entendi parcialmente":
        dias = [3, 10]
    else:
        dias = [14, 45]
    for dias_para_revisar in dias:
        insert_returning_id(
            """
            INSERT INTO revisoes (user_id, topico_id, data_revisao, status, tipo_revisao)
            VALUES (?, ?, ?, ?, ?)
            """,
            (
                user_id,
                topico_id,
                (date.today() + timedelta(days=dias_para_revisar)).isoformat(),
                REVISAO_PENDENTE,
                f"{dias_para_revisar} dia(s)",
            ),
        )


def listar_revisoes():
    return fetch_all(
        """
        SELECT r.*, t.titulo, t.nivel_entendimento, m.nome AS materia
        FROM revisoes r
        JOIN topicos t ON t.id = r.topico_id AND t.user_id = r.user_id
        JOIN materias m ON m.id = t.materia_id AND m.user_id = t.user_id
        WHERE r.user_id = ? AND r.status = ?
        ORDER BY r.data_revisao, m.nome, t.ordem
        """,
        (current_user_id(), REVISAO_PENDENTE),
    )


def marcar_revisado(revisao_id):
    execute(
        """
        UPDATE revisoes
        SET status = ?, revisado_em = ?
        WHERE id = ? AND user_id = ?
        """,
        (REVISAO_CONCLUIDA, datetime.now().isoformat(timespec="seconds"), revisao_id, current_user_id()),
    )
    registrar_pontos("revisar_topico", revisao_id)


def registrar_sessao(materia_id, topico_id, inicio, fim):
    duracao = max((fim - inicio).total_seconds() / 60, 0)
    sessao_id = insert_returning_id(
        """
        INSERT INTO sessoes_estudo (user_id, materia_id, topico_id, inicio, fim, duracao_minutos)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (
            current_user_id(),
            materia_id,
            topico_id,
            inicio.isoformat(timespec="seconds"),
            fim.isoformat(timespec="seconds"),
            duracao,
        ),
    )
    registrar_pontos("sessao_estudo", sessao_id)
    return duracao


def listar_quiz(topico_id):
    return fetch_all(
        "SELECT * FROM quiz WHERE user_id = ? AND topico_id = ? ORDER BY id",
        (current_user_id(), topico_id),
    )


def listar_quiz_materia(materia_id):
    return fetch_all(
        """
        SELECT q.*, t.titulo AS topico
        FROM quiz q
        JOIN topicos t ON t.id = q.topico_id AND t.user_id = q.user_id
        WHERE q.user_id = ? AND t.materia_id = ?
        ORDER BY t.ordem, q.id
        """,
        (current_user_id(), materia_id),
    )


def registrar_resposta_quiz(quiz_id, resposta_usuario, acertou):
    resposta_id = insert_returning_id(
        """
        INSERT INTO respostas_quiz (user_id, quiz_id, resposta_usuario, acertou)
        VALUES (?, ?, ?, ?)
        """,
        (current_user_id(), quiz_id, resposta_usuario, bool(acertou)),
    )
    registrar_pontos("responder_quiz", quiz_id)
    if acertou:
        registrar_pontos("acertar_pergunta", f"quiz:{quiz_id}")
    return resposta_id


def salvar_pdf(nome_arquivo, texto_extraido, resumo):
    return insert_returning_id(
        """
        INSERT INTO pdfs (user_id, nome_arquivo, texto_extraido, resumo)
        VALUES (?, ?, ?, ?)
        """,
        (current_user_id(), nome_arquivo, texto_extraido, resumo),
    )


def listar_pdfs():
    return fetch_all(
        "SELECT * FROM pdfs WHERE user_id = ? ORDER BY enviado_em DESC",
        (current_user_id(),),
    )


def criar_pasta(nome, descricao=""):
    return insert_returning_id(
        "INSERT INTO pastas (user_id, nome, descricao) VALUES (?, ?, ?)",
        (current_user_id(), nome, descricao),
    )


def listar_pastas():
    return fetch_all(
        "SELECT * FROM pastas WHERE user_id = ? ORDER BY nome",
        (current_user_id(),),
    )


def excluir_pasta(pasta_id):
    execute("UPDATE materias SET pasta_id = NULL WHERE user_id = ? AND pasta_id = ?", (current_user_id(), pasta_id))
    execute("DELETE FROM pastas WHERE user_id = ? AND id = ?", (current_user_id(), pasta_id))


def atualizar_materia_pasta(materia_id, pasta_id):
    execute(
        "UPDATE materias SET pasta_id = ? WHERE user_id = ? AND id = ?",
        (pasta_id, current_user_id(), materia_id),
    )


def listar_materias_com_pasta():
    return fetch_all(
        """
        SELECT m.*, p.nome AS pasta
        FROM materias m
        LEFT JOIN pastas p ON p.id = m.pasta_id AND p.user_id = m.user_id
        WHERE m.user_id = ?
        ORDER BY COALESCE(p.nome, 'Sem pasta'), m.nome
        """,
        (current_user_id(),),
    )


def atualizar_status_topico(topico_id, status):
    topico_atual = fetch_one("SELECT status FROM topicos WHERE user_id = ? AND id = ?", (current_user_id(), topico_id))
    concluido_em = datetime.now().isoformat(timespec="seconds") if status == STATUS_CONCLUIDO else None
    execute(
        """
        UPDATE topicos
        SET status = ?, concluido_em = ?, updated_at = CURRENT_TIMESTAMP
        WHERE user_id = ? AND id = ?
        """,
        (status, concluido_em, current_user_id(), topico_id),
    )
    if status == STATUS_CONCLUIDO and (not topico_atual or topico_atual.get("status") != STATUS_CONCLUIDO):
        registrar_pontos("concluir_topico", topico_id)


def listar_flashcards(topico_id=None):
    if topico_id:
        return fetch_all(
            "SELECT * FROM flashcards WHERE user_id = ? AND topico_id = ? ORDER BY id",
            (current_user_id(), topico_id),
        )
    return fetch_all(
        """
        SELECT f.*, t.titulo AS topico, m.nome AS materia
        FROM flashcards f
        JOIN topicos t ON t.id = f.topico_id AND t.user_id = f.user_id
        JOIN materias m ON m.id = t.materia_id AND m.user_id = t.user_id
        WHERE f.user_id = ?
        ORDER BY m.nome, t.ordem, f.id
        """,
        (current_user_id(),),
    )


def salvar_flashcard(topico_id, frente, verso, pontuar=True):
    flashcard_id = insert_returning_id(
        "INSERT INTO flashcards (user_id, topico_id, frente, verso) VALUES (?, ?, ?, ?)",
        (current_user_id(), topico_id, frente, verso),
    )
    if pontuar:
        registrar_pontos("criar_flashcard", flashcard_id)
    return flashcard_id


def registrar_flashcard_resposta(flashcard_id, acertou):
    return insert_returning_id(
        "INSERT INTO flashcard_respostas (user_id, flashcard_id, acertou) VALUES (?, ?, ?)",
        (current_user_id(), flashcard_id, bool(acertou)),
    )


def listar_perguntas(topico_id=None):
    if topico_id:
        return fetch_all(
            "SELECT * FROM perguntas WHERE user_id = ? AND topico_id = ? ORDER BY id",
            (current_user_id(), topico_id),
        )
    return fetch_all(
        """
        SELECT p.*, t.titulo AS topico, m.nome AS materia
        FROM perguntas p
        JOIN topicos t ON t.id = p.topico_id AND t.user_id = p.user_id
        JOIN materias m ON m.id = t.materia_id AND m.user_id = t.user_id
        WHERE p.user_id = ?
        ORDER BY m.nome, t.ordem, p.id
        """,
        (current_user_id(),),
    )


def salvar_pergunta(topico_id, tipo, enunciado, resposta_correta, explicacao="", alternativas=None):
    alternativas = alternativas or {}
    return insert_returning_id(
        """
        INSERT INTO perguntas (
            user_id, topico_id, tipo, enunciado, alternativa_a, alternativa_b,
            alternativa_c, alternativa_d, resposta_correta, explicacao
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            current_user_id(),
            topico_id,
            tipo,
            enunciado,
            alternativas.get("A"),
            alternativas.get("B"),
            alternativas.get("C"),
            alternativas.get("D"),
            resposta_correta,
            explicacao,
        ),
    )


def registrar_resposta_pergunta(pergunta_id, resposta_usuario, acertou):
    resposta_id = insert_returning_id(
        "INSERT INTO respostas_perguntas (user_id, pergunta_id, resposta_usuario, acertou) VALUES (?, ?, ?, ?)",
        (current_user_id(), pergunta_id, resposta_usuario, bool(acertou)),
    )
    if acertou:
        registrar_pontos("acertar_pergunta", f"pergunta:{pergunta_id}")
    return resposta_id


def criar_evento(materia_id, titulo, descricao, data_evento, horario, tipo):
    return insert_returning_id(
        """
        INSERT INTO eventos_calendario (user_id, materia_id, titulo, descricao, data_evento, horario, tipo)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (current_user_id(), materia_id, titulo, descricao, data_evento, horario, tipo),
    )


def listar_eventos():
    return fetch_all(
        """
        SELECT e.*, m.nome AS materia
        FROM eventos_calendario e
        LEFT JOIN materias m ON m.id = e.materia_id AND m.user_id = e.user_id
        WHERE e.user_id = ?
        ORDER BY e.data_evento, e.horario
        """,
        (current_user_id(),),
    )


def excluir_evento(evento_id):
    execute("DELETE FROM eventos_calendario WHERE user_id = ? AND id = ?", (current_user_id(), evento_id))


def registrar_estudo_diario(materia_id, topico_id, data_estudo, tempo_minutos, observacao):
    return insert_returning_id(
        """
        INSERT INTO estudos_diarios (user_id, materia_id, topico_id, data_estudo, tempo_minutos, observacao)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (current_user_id(), materia_id, topico_id, data_estudo, tempo_minutos, observacao),
    )


def listar_estudos_diarios(data_estudo=None):
    data_estudo = data_estudo or date.today().isoformat()
    return fetch_all(
        """
        SELECT ed.*, m.nome AS materia, t.titulo AS topico
        FROM estudos_diarios ed
        JOIN materias m ON m.id = ed.materia_id AND m.user_id = ed.user_id
        LEFT JOIN topicos t ON t.id = ed.topico_id AND t.user_id = ed.user_id
        WHERE ed.user_id = ? AND ed.data_estudo = ?
        ORDER BY ed.criado_em DESC
        """,
        (current_user_id(), data_estudo),
    )


def salvar_resumo_anexado(materia_id, topico_id, titulo, tipo, caminho_arquivo=None, conteudo_texto=None):
    resumo_id = insert_returning_id(
        """
        INSERT INTO resumos_anexados (
            user_id, materia_id, topico_id, titulo, tipo, caminho_arquivo, conteudo_texto
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (current_user_id(), materia_id, topico_id, titulo, tipo, caminho_arquivo, conteudo_texto),
    )
    tipo_normalizado = (tipo or "").lower()
    if "nota" in tipo_normalizado or tipo_normalizado == "texto":
        registrar_pontos("criar_nota", resumo_id)
    else:
        registrar_pontos("anexar_resumo", resumo_id)
    return resumo_id


def listar_resumos_anexados():
    return fetch_all(
        """
        SELECT r.*, m.nome AS materia, t.titulo AS topico
        FROM resumos_anexados r
        JOIN materias m ON m.id = r.materia_id AND m.user_id = r.user_id
        LEFT JOIN topicos t ON t.id = r.topico_id AND t.user_id = r.user_id
        WHERE r.user_id = ?
        ORDER BY r.criado_em DESC
        """,
        (current_user_id(),),
    )


def excluir_resumo_anexado(resumo_id):
    execute("DELETE FROM resumos_anexados WHERE user_id = ? AND id = ?", (current_user_id(), resumo_id))


def metricas_universitarias():
    user_id = current_user_id()
    hoje = date.today().isoformat()
    estudado_hoje = fetch_one(
        "SELECT COALESCE(SUM(tempo_minutos), 0) AS total FROM estudos_diarios WHERE user_id = ? AND data_estudo = ?",
        (user_id, hoje),
    )["total"]
    flashcards = fetch_one("SELECT COUNT(*) AS total FROM flashcards WHERE user_id = ?", (user_id,))["total"]
    respostas = fetch_one(
        "SELECT COUNT(*) AS total, COALESCE(SUM(CASE WHEN acertou THEN 1 ELSE 0 END), 0) AS acertos FROM respostas_perguntas WHERE user_id = ?",
        (user_id,),
    )
    semana = fetch_one(
        "SELECT COALESCE(SUM(tempo_minutos), 0) AS total FROM estudos_diarios WHERE user_id = ? AND data_estudo >= ?",
        (user_id, (date.today() - timedelta(days=7)).isoformat()),
    )["total"]
    proxima_prova = fetch_one(
        "SELECT titulo, data_evento FROM eventos_calendario WHERE user_id = ? AND tipo = 'Prova' AND data_evento >= ? ORDER BY data_evento LIMIT 1",
        (user_id, hoje),
    )
    proxima_revisao = fetch_one(
        "SELECT data_revisao FROM revisoes WHERE user_id = ? AND status = ? AND data_revisao >= ? ORDER BY data_revisao LIMIT 1",
        (user_id, REVISAO_PENDENTE, hoje),
    )
    return {
        "estudado_hoje": estudado_hoje,
        "total_flashcards": flashcards,
        "acertos_perguntas": f"{respostas['acertos']}/{respostas['total']}",
        "tempo_semana": semana,
        "proxima_prova": proxima_prova,
        "proxima_revisao": proxima_revisao,
    }
