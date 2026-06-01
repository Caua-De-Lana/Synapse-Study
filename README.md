# Synapse

Seu segundo cérebro para provas e aprendizado.

Synapse é uma plataforma de estudos em Streamlit com foco em clareza: ao abrir o app, o estudante deve entender rapidamente o que precisa estudar agora.

## Princípios

- Menos gráficos, mais direção.
- Menos métricas, mais próximo passo.
- Uma tela, um objetivo principal.
- Visual premium, minimalista e acadêmico.

## Recursos

- Login e cadastro de usuários.
- Onboarding para criar um plano inicial.
- Matérias, tópicos, progresso e revisões.
- Dashboard focado em próxima prova, próximo tópico e tarefas de hoje.
- Quiz, perguntas, flashcards e checklist.
- Biblioteca para PDFs, resumos, fórmulas, notas e arquivos.
- Calendário para provas, entregas, revisões e estudos.
- Banco local SQLite para desenvolvimento e Supabase/PostgreSQL para deploy.

## Rodar localmente

```bash
pip install -r requirements.txt
streamlit run app.py
```

Sem credenciais do Supabase, o app roda em modo demo local usando SQLite.

## Configurar Supabase

Crie `.streamlit/secrets.toml` baseado em `.streamlit/secrets.toml.example`:

```toml
SUPABASE_URL = "https://SEU-PROJETO.supabase.co"
SUPABASE_ANON_KEY = "SUA_CHAVE_ANON_PUBLICA"
SUPABASE_DB_URL = "postgresql://postgres.PROJECT_REF:SENHA@HOST:6543/postgres"
```

O app cria as tabelas automaticamente quando `SUPABASE_DB_URL` está configurado. O arquivo [database/schema.sql](database/schema.sql) também pode ser executado manualmente no SQL Editor do Supabase.
