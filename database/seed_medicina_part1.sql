-- ============================================================
-- SYNAPSE - SEED MEDICINA
-- Função: seed_medicina()
-- Evita duplicação via INSERT OR IGNORE / NOT EXISTS
-- ============================================================

-- ============================================================
-- PASTA MEDICINA
-- ============================================================
INSERT OR IGNORE INTO pastas (nome, descricao, icone, cor, criado_em)
VALUES ('Medicina', 'Conteúdo completo de Medicina Básica para revisão e estudo.', 'stethoscope', '#E53E3E', datetime('now'));

-- ============================================================
-- MATÉRIAS
-- ============================================================
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Anatomia Humana', 'Estudo morfológico dos sistemas do corpo humano.', id, 1, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Fisiologia', 'Funcionamento normal dos sistemas do organismo humano.', id, 2, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Bioquímica', 'Reações químicas e vias metabólicas do organismo.', id, 3, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Histologia', 'Estudo microscópico dos tecidos do corpo humano.', id, 4, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Embriologia', 'Desenvolvimento do embrião e do feto humano.', id, 5, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Farmacologia', 'Estudo dos fármacos e seus efeitos no organismo.', id, 6, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Patologia', 'Mecanismos das doenças e respostas celulares.', id, 7, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Microbiologia', 'Estudo dos microrganismos e sua relação com o hospedeiro.', id, 8, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Imunologia', 'Mecanismos de defesa do organismo humano.', id, 9, datetime('now') FROM pastas WHERE nome = 'Medicina';
INSERT OR IGNORE INTO materias (nome, descricao, pasta_id, ordem, criado_em)
SELECT 'Semiologia', 'Metodologia de coleta de dados clínicos e raciocínio diagnóstico.', id, 10, datetime('now') FROM pastas WHERE nome = 'Medicina';

-- ============================================================
-- TÓPICOS - ANATOMIA HUMANA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Esquelético', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Muscular', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Nervoso', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Cardiovascular', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Respiratório', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Digestório', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Urinário', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Reprodutor', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Anatomia Humana';

-- ============================================================
-- TÓPICOS - FISIOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Homeostase', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Potencial de Ação', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Contração Muscular', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Ciclo Cardíaco', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Ventilação Pulmonar', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Filtração Glomerular', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sistema Endócrino', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Regulação da Pressão Arterial', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';

-- FISIOLOGIA RESPIRATÓRIA - DETALHADA
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Anatomia Funcional do Sistema Respiratório', id, 9, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Mecânica da Ventilação e Pressões Pulmonares', id, 10, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Complacência Pulmonar e Surfactante', id, 11, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Difusão dos Gases e Transporte de O2', id, 12, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Transporte de CO2 e Curva de Dissociação da Hb', id, 13, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Relação Ventilação/Perfusão e Espaço Morto', id, 14, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Controle Neural da Respiração e Quimiorreceptores', id, 15, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Distúrbios Ácido-Base Respiratórios', id, 16, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';

-- FISIOLOGIA RENAL - DETALHADA
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Anatomia Funcional do Néfron', id, 17, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Filtração Glomerular e TFG', id, 18, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Reabsorção e Secreção Tubular', id, 19, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Mecanismo de Contracorrente e Concentração da Urina', id, 20, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'ADH e Sistema Renina-Angiotensina-Aldosterona', id, 21, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Equilíbrio Eletrolítico: Sódio, Potássio e Cálcio', id, 22, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Equilíbrio Ácido-Base Renal', id, 23, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Fisiologia da Micção', id, 24, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Fisiologia';

-- ============================================================
-- TÓPICOS - BIOQUÍMICA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Água e pH', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Aminoácidos e Proteínas', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Enzimas', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Introdução ao Metabolismo Energético e ATP', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Glicólise', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Destino do Piruvato: Aeróbio e Anaeróbio', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Ciclo de Krebs', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Cadeia Transportadora de Elétrons e Fosforilação Oxidativa', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Glicogênese e Glicogenólise', id, 9, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Gliconeogênese', id, 10, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Via das Pentoses Fosfato', id, 11, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Metabolismo da Frutose e Galactose', id, 12, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Regulação pela Insulina e Glucagon', id, 13, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Diabetes e Metabolismo da Glicose', id, 14, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Lipídios e Metabolismo Lipídico', id, 15, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Bioquímica';

-- ============================================================
-- TÓPICOS - HISTOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Tecido Epitelial', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Tecido Conjuntivo', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Tecido Muscular', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Tecido Nervoso', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sangue', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Cartilagem', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Osso', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Pele', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Histologia';

-- ============================================================
-- TÓPICOS - EMBRIOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Gametogênese', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Fertilização', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Clivagem', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Gastrulação', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Neurulação', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Organogênese', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Placenta', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Desenvolvimento Fetal', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Embriologia';

-- ============================================================
-- TÓPICOS - FARMACOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Farmacocinética', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Farmacodinâmica', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Absorção', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Distribuição', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Metabolização', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Excreção', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Agonistas e Antagonistas', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Efeitos Adversos', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Farmacologia';

-- ============================================================
-- TÓPICOS - PATOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Inflamação Aguda', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Inflamação Crônica', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Necrose', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Apoptose', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Adaptação Celular', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Neoplasias', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Trombose', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Choque', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Patologia';

-- ============================================================
-- TÓPICOS - MICROBIOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Bactérias', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Vírus', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Fungos', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Parasitas', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Gram Positivo', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Gram Negativo', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Antibiograma', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Resistência Bacteriana', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Microbiologia';

-- ============================================================
-- TÓPICOS - IMUNOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Imunidade Inata', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Imunidade Adaptativa', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Linfócitos T', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Linfócitos B', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Anticorpos', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Inflamação Imunológica', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Hipersensibilidade', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Vacinas', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Imunologia';

-- ============================================================
-- TÓPICOS - SEMIOLOGIA
-- ============================================================
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Anamnese', id, 1, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Exame Físico Geral', id, 2, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Sinais Vitais', id, 3, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Inspeção', id, 4, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Palpação', id, 5, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Percussão', id, 6, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Ausculta', id, 7, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
INSERT OR IGNORE INTO topicos (titulo, materia_id, ordem, status, criado_em)
SELECT 'Raciocínio Clínico', id, 8, 'nao_iniciado', datetime('now') FROM materias WHERE nome = 'Semiologia';
