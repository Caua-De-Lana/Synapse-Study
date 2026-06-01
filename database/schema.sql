create table if not exists materias (
    id bigserial primary key,
    user_id text not null,
    pasta_id bigint,
    nome text not null,
    descricao text,
    criado_em timestamptz not null default now()
);

create table if not exists pastas (
    id bigserial primary key,
    user_id text not null,
    nome text not null,
    descricao text,
    criado_em timestamptz not null default now()
);

create table if not exists user_profile (
    id bigserial primary key,
    user_id text not null unique,
    nome text,
    curso text default '',
    foto_url text default '',
    pontos_total integer not null default 0,
    nivel_atual text not null default 'Vestibulando',
    meta_diaria_minutos integer not null default 45,
    areas_estudo text default '',
    objetivo_estudo text default '',
    onboarding_concluido boolean not null default false,
    criado_em timestamptz not null default now()
);

create table if not exists pontos_historico (
    id bigserial primary key,
    user_id text not null,
    acao text not null,
    pontos integer not null,
    criado_em timestamptz not null default now(),
    unique(user_id, acao)
);

create table if not exists tarefas_diarias (
    id bigserial primary key,
    user_id text not null,
    titulo text not null,
    data_tarefa date not null,
    concluida boolean not null default false,
    criado_em timestamptz not null default now()
);

alter table user_profile add column if not exists curso text default '';
alter table user_profile add column if not exists foto_url text default '';
alter table user_profile add column if not exists pontos_total integer not null default 0;
alter table user_profile add column if not exists nivel_atual text not null default 'Vestibulando';
alter table user_profile add column if not exists meta_diaria_minutos integer not null default 45;

create table if not exists topicos (
    id bigserial primary key,
    user_id text not null,
    materia_id bigint not null references materias(id) on delete cascade,
    ordem integer not null default 0,
    titulo text not null,
    resumo_rapido text default '',
    formula text default '',
    explicacao text default '',
    analogia text default '',
    exemplo text default '',
    exercicio text default '',
    dica_prova text default '',
    aplicacao_pratica text default '',
    explicacao_extra text default '',
    outro_exemplo text default '',
    status text not null default 'Pendente',
    nivel_entendimento text default 'Não avaliado',
    concluido_em timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists revisoes (
    id bigserial primary key,
    user_id text not null,
    topico_id bigint not null references topicos(id) on delete cascade,
    data_revisao date not null,
    status text not null default 'Pendente',
    tipo_revisao text not null default 'Revisão',
    revisado_em timestamptz,
    created_at timestamptz not null default now()
);

create table if not exists sessoes_estudo (
    id bigserial primary key,
    user_id text not null,
    materia_id bigint not null references materias(id) on delete cascade,
    topico_id bigint references topicos(id) on delete set null,
    inicio timestamptz not null,
    fim timestamptz,
    duracao_minutos double precision not null default 0
);

create table if not exists quiz (
    id bigserial primary key,
    user_id text not null,
    topico_id bigint not null references topicos(id) on delete cascade,
    pergunta text not null,
    alternativa_a text not null,
    alternativa_b text not null,
    alternativa_c text not null,
    alternativa_d text not null,
    resposta_correta text not null,
    explicacao text not null
);

create table if not exists respostas_quiz (
    id bigserial primary key,
    user_id text not null,
    quiz_id bigint not null references quiz(id) on delete cascade,
    resposta_usuario text not null,
    acertou boolean not null,
    respondido_em timestamptz not null default now()
);

create table if not exists pdfs (
    id bigserial primary key,
    user_id text not null,
    nome_arquivo text not null,
    texto_extraido text,
    resumo text,
    enviado_em timestamptz not null default now()
);

create table if not exists flashcards (
    id bigserial primary key,
    user_id text not null,
    topico_id bigint not null references topicos(id) on delete cascade,
    frente text not null,
    verso text not null,
    criado_em timestamptz not null default now()
);

create table if not exists flashcard_respostas (
    id bigserial primary key,
    user_id text not null,
    flashcard_id bigint not null references flashcards(id) on delete cascade,
    acertou boolean not null,
    respondido_em timestamptz not null default now()
);

create table if not exists perguntas (
    id bigserial primary key,
    user_id text not null,
    topico_id bigint not null references topicos(id) on delete cascade,
    tipo text not null,
    enunciado text not null,
    alternativa_a text,
    alternativa_b text,
    alternativa_c text,
    alternativa_d text,
    resposta_correta text not null,
    explicacao text,
    criado_em timestamptz not null default now()
);

create table if not exists respostas_perguntas (
    id bigserial primary key,
    user_id text not null,
    pergunta_id bigint not null references perguntas(id) on delete cascade,
    resposta_usuario text not null,
    acertou boolean not null,
    respondido_em timestamptz not null default now()
);

create table if not exists eventos_calendario (
    id bigserial primary key,
    user_id text not null,
    materia_id bigint references materias(id) on delete set null,
    titulo text not null,
    descricao text,
    data_evento date not null,
    horario text,
    tipo text not null,
    criado_em timestamptz not null default now()
);

create table if not exists estudos_diarios (
    id bigserial primary key,
    user_id text not null,
    materia_id bigint not null references materias(id) on delete cascade,
    topico_id bigint references topicos(id) on delete set null,
    data_estudo date not null,
    tempo_minutos double precision not null default 0,
    observacao text,
    criado_em timestamptz not null default now()
);

create table if not exists resumos_anexados (
    id bigserial primary key,
    user_id text not null,
    materia_id bigint not null references materias(id) on delete cascade,
    topico_id bigint references topicos(id) on delete set null,
    titulo text not null,
    tipo text not null,
    caminho_arquivo text,
    conteudo_texto text,
    criado_em timestamptz not null default now()
);

create index if not exists idx_materias_user_id on materias(user_id);
create index if not exists idx_user_profile_user_id on user_profile(user_id);
create index if not exists idx_pontos_historico_user_id on pontos_historico(user_id);
create index if not exists idx_tarefas_diarias_user_id on tarefas_diarias(user_id);
create index if not exists idx_topicos_user_id on topicos(user_id);
create index if not exists idx_revisoes_user_id on revisoes(user_id);
create index if not exists idx_sessoes_estudo_user_id on sessoes_estudo(user_id);
create index if not exists idx_quiz_user_id on quiz(user_id);
create index if not exists idx_respostas_quiz_user_id on respostas_quiz(user_id);
create index if not exists idx_pdfs_user_id on pdfs(user_id);
create index if not exists idx_pastas_user_id on pastas(user_id);
create index if not exists idx_flashcards_user_id on flashcards(user_id);
create index if not exists idx_flashcard_respostas_user_id on flashcard_respostas(user_id);
create index if not exists idx_perguntas_user_id on perguntas(user_id);
create index if not exists idx_respostas_perguntas_user_id on respostas_perguntas(user_id);
create index if not exists idx_eventos_calendario_user_id on eventos_calendario(user_id);
create index if not exists idx_estudos_diarios_user_id on estudos_diarios(user_id);
create index if not exists idx_resumos_anexados_user_id on resumos_anexados(user_id);

alter table materias enable row level security;
alter table user_profile enable row level security;
alter table pontos_historico enable row level security;
alter table tarefas_diarias enable row level security;
alter table topicos enable row level security;
alter table revisoes enable row level security;
alter table sessoes_estudo enable row level security;
alter table quiz enable row level security;
alter table respostas_quiz enable row level security;
alter table pdfs enable row level security;
alter table pastas enable row level security;
alter table flashcards enable row level security;
alter table flashcard_respostas enable row level security;
alter table perguntas enable row level security;
alter table respostas_perguntas enable row level security;
alter table eventos_calendario enable row level security;
alter table estudos_diarios enable row level security;
alter table resumos_anexados enable row level security;

drop policy if exists materias_owner on materias;
create policy materias_owner on materias
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists user_profile_owner on user_profile;
create policy user_profile_owner on user_profile
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists pontos_historico_owner on pontos_historico;
create policy pontos_historico_owner on pontos_historico
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists tarefas_diarias_owner on tarefas_diarias;
create policy tarefas_diarias_owner on tarefas_diarias
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists topicos_owner on topicos;
create policy topicos_owner on topicos
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists revisoes_owner on revisoes;
create policy revisoes_owner on revisoes
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists sessoes_estudo_owner on sessoes_estudo;
create policy sessoes_estudo_owner on sessoes_estudo
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists quiz_owner on quiz;
create policy quiz_owner on quiz
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists respostas_quiz_owner on respostas_quiz;
create policy respostas_quiz_owner on respostas_quiz
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists pdfs_owner on pdfs;
create policy pdfs_owner on pdfs
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists pastas_owner on pastas;
create policy pastas_owner on pastas
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists flashcards_owner on flashcards;
create policy flashcards_owner on flashcards
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists flashcard_respostas_owner on flashcard_respostas;
create policy flashcard_respostas_owner on flashcard_respostas
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists perguntas_owner on perguntas;
create policy perguntas_owner on perguntas
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists respostas_perguntas_owner on respostas_perguntas;
create policy respostas_perguntas_owner on respostas_perguntas
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists eventos_calendario_owner on eventos_calendario;
create policy eventos_calendario_owner on eventos_calendario
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists estudos_diarios_owner on estudos_diarios;
create policy estudos_diarios_owner on estudos_diarios
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);

drop policy if exists resumos_anexados_owner on resumos_anexados;
create policy resumos_anexados_owner on resumos_anexados
    for all using (user_id = auth.uid()::text)
    with check (user_id = auth.uid()::text);
