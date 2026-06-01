-- ============================================================
-- CONTEÚDO: FISIOLOGIA RESPIRATÓRIA
-- ============================================================

-- ============================================================
-- TÓPICO: ANATOMIA FUNCIONAL DO SISTEMA RESPIRATÓRIO
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Anatomia Funcional do Sistema Respiratório',
  'O sistema respiratório divide-se em zona de condução (narinas até bronquíolos terminais) e zona respiratória (bronquíolos respiratórios, ductos e sacos alveolares). A traqueia se bifurca na carina (nível de T4/T5) em brônquios principais direito e esquerdo. O direito é mais verticalizado, tornando-o sítio preferencial de aspiração de corpos estranhos. A unidade funcional é o ácino pulmonar. Os alvéolos são revestidos por pneumócitos tipo I (troca gasosa) e tipo II (produção de surfactante). A superfície alveolar total é de aproximadamente 70 m² em adulto.',
  'O sistema respiratório tem como função principal a troca de gases entre o ambiente externo e o sangue. Divide-se anatomicamente em zona de condução e zona respiratória.

ZONA DE CONDUÇÃO: compreende fossas nasais, faringe, laringe, traqueia, brônquios principais, brônquios lobares, brônquios segmentares, bronquíolos e bronquíolos terminais. Essa zona NÃO realiza troca gasosa — apenas conduz, umidifica, filtra e aquece o ar. Corresponde ao espaço morto anatômico (~150 mL em adulto).

ZONA RESPIRATÓRIA: bronquíolos respiratórios, ductos alveolares e sacos alveolares. Aqui ocorre a hematose (troca O2/CO2). O adulto possui cerca de 300 milhões de alvéolos com área total de ~70 m².

BIFURCAÇÃO TRAQUEAL (CARINA): localiza-se no nível de T4-T5 (ângulo de Louis). O brônquio direito é mais curto, largo e verticalizado (ângulo ~25° com a vertical), explicando por que corpos estranhos preferem o pulmão direito. O brônquio esquerdo é mais longo e angulado (~45°).

PNEUMÓCITOS:
• Tipo I (95% da superfície alveolar): finos, sem organelas, especializados em troca gasosa. Altamente vulneráveis a toxinas.
• Tipo II (5% da superfície): cúbicos, com corpos lamelares, produzem surfactante. São as células-tronco do epitélio alveolar — regeneram os pneumócitos tipo I após lesão.
• Macrófagos alveolares: fagocitam partículas inaladas, bactérias e corpos estranhos.

PLEURA: membrana serosa que envolve os pulmões (pleura visceral) e reveste o interior do tórax (pleura parietal). Entre elas, o espaço pleural contém 5-15 mL de líquido, mantendo pressão negativa que "cola" o pulmão à parede torácica.

MÚSCULOS RESPIRATÓRIOS: o diafragma é o principal músculo inspiratório (responsável por 70-80% do volume corrente em repouso). Os intercostais externos auxiliam na inspiração; os internos, na expiração forçada. Em situações de esforço, recrutam-se esternocleidomastoideo, escalenos e trapézio.',
  'Paciente com engasgo e corpo estranho aspirado → raio-X evidencia opacidade no brônquio intermediário direito, confirmando a anatomia de maior verticalização do brônquio direito. Outro exemplo: pneumonia aspirativa em paciente acamado em posição supina → lobo inferior direito é o mais acometido.',
  datetime('now')
FROM topicos t
JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

-- FLASHCARDS - Anatomia Funcional
INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual brônquio principal recebe corpos estranhos com mais frequência e por quê?',
  'O brônquio DIREITO, porque é mais curto, largo e verticalizado (ângulo ~25° com a traqueia), enquanto o esquerdo tem ângulo ~45°. Por isso, aspirações acidentais e sondas mal posicionadas tendem a ir para a direita.',
  'anatomia, brônquios', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a função dos pneumócitos tipo II?',
  'Produzem SURFACTANTE (lecitina/dipalmitoilfosfatidilcolina), reduzindo a tensão superficial alveolar. Também são células-tronco do epitélio alveolar, regenerando pneumócitos tipo I após lesão.',
  'pneumócitos, surfactante', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'O que é a zona de condução e qual seu papel no espaço morto?',
  'Zona de condução = narinas ao bronquíolo terminal. NÃO realiza troca gasosa. Umidifica, aquece e filtra o ar. Corresponde ao espaço morto anatômico de ~150 mL (2 mL/kg peso corporal).',
  'zona de condução, espaço morto', 'facil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

-- QUESTÕES - Anatomia Funcional
INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Um paciente de 2 anos engole uma amendoim durante a refeição. A criança apresenta tossem súbita e estridor. Na radiografia de tórax, observa-se hiperinsuflação do pulmão direito. A causa mais provável é:',
  'Obstrução do brônquio esquerdo pela maior angulação',
  'Obstrução do brônquio direito pela sua maior verticalização e calibre',
  'Espasmo da glote por reflexo vagal',
  'Pneumotórax hipertensivo à esquerda',
  'B',
  'O brônquio principal direito é mais verticalizado (~25°) e de maior calibre que o esquerdo (~45°), sendo o destino preferencial de corpos estranhos aspirados. A hiperinsuflação ocorre por mecanismo valvular: o corpo estranho permite entrada de ar na inspiração mas bloqueia a saída na expiração (válvula unidirecional).',
  'Fisiologia Pulmonar - Guyton', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Os pneumócitos tipo II são importantes no contexto da síndrome do desconforto respiratório agudo (SDRA) porque:',
  'Realizam diretamente a troca gasosa, sendo destruídos na SDRA',
  'Produzem surfactante e regeneram o epitélio alveolar após lesão',
  'Fagocitam bactérias e detritos celulares no alvéolo',
  'Secretam IgA protegendo a mucosa respiratória',
  'B',
  'Pneumócitos tipo II produzem surfactante (reduz tensão superficial, impedindo colapso alveolar) e são as células progenitoras do epitélio alveolar. Na SDRA, a lesão extensa dos pneumócitos tipo I e II resulta em perda de surfactante (atelectasias) e incapacidade de regeneração epitelial, levando à hipoxemia grave.',
  'Fisiologia Pulmonar - Guyton', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A zona de condução do aparelho respiratório inclui TODAS as estruturas abaixo, EXCETO:',
  'Traqueia',
  'Bronquíolos terminais',
  'Bronquíolos respiratórios',
  'Brônquios lobares',
  'C',
  'Os bronquíolos respiratórios já pertencem à zona respiratória, pois apresentam alvéolos em suas paredes e participam da troca gasosa. A zona de condução vai das narinas até os bronquíolos terminais (exclusive a troca gasosa), funcionando como espaço morto anatômico.',
  'Fisiologia Pulmonar - West', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual o músculo mais importante para a inspiração em repouso e qual percentual do volume corrente ele é responsável?',
  'Intercostais externos — 50%',
  'Diafragma — 70 a 80%',
  'Esternocleidomastoideo — 60%',
  'Escalenos — 40%',
  'B',
  'O diafragma é o principal músculo inspiratório, responsável por 70-80% do volume corrente em repouso. Ao contrair, desloca-se caudalmente, aumentando o diâmetro longitudinal do tórax e criando pressão negativa intratorácica. Os demais músculos são acessórios e recrutados em esforço ou doença.',
  'Fisiologia Respiratória - West', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A carina traqueal, ponto de bifurcação da traqueia, localiza-se em que nível vertebral e qual sua importância clínica?',
  'C7 — usada para calcular intubação orotraqueal',
  'T4-T5 (ângulo de Louis) — referência para avaliação da sonda endotraqueal e mediastino',
  'T8 — nível do hiato esofágico',
  'T2 — palpável na incisura jugular do esterno',
  'B',
  'A carina localiza-se em T4-T5, nível correspondente ao ângulo de Louis (junção manúbrio-esternal). É referência radiológica importante: em radiografia de tórax, a sonda endotraqueal deve ficar 2-3 cm acima da carina. Alargamento da carina (ângulo >70°) sugere adenopatia mediastinal ou aumento do átrio esquerdo.',
  'Anatomia Clínica', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Anatomia Funcional do Sistema Respiratório' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: MECÂNICA DA VENTILAÇÃO E PRESSÕES PULMONARES
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Mecânica da Ventilação e Pressões Pulmonares',
  'A inspiração é ativa (contração do diafragma) e a expiração em repouso é passiva (retração elástica). A pressão intrapleural normal é de -5 cmH2O, tornando-se mais negativa (-8 cmH2O) na inspiração. A pressão transpulmonar (alveolar menos intrapleural) mantém os pulmões expandidos. O volume corrente em adulto é ~500 mL. Lei de Boyle explica o mecanismo: expansão do tórax reduz pressão alveolar abaixo da atmosférica, criando gradiente de pressão que puxa o ar para dentro.',
  'PRINCÍPIO FUNDAMENTAL: o fluxo de ar depende de gradiente de pressão entre atmosfera e alvéolo. Quando pressão alveolar < pressão atmosférica → inspiração. Quando pressão alveolar > pressão atmosférica → expiração.

PRESSÕES IMPORTANTES:
• Pressão atmosférica (Patm): 760 mmHg = 0 cmH2O (referência)
• Pressão alveolar (Palv): 0 cmH2O em repouso (sem fluxo)
• Pressão intrapleural (Pip): -5 cmH2O em repouso; -8 cmH2O na inspiração máxima
• Pressão transpulmonar (Pt): Palv - Pip = 0 - (-5) = +5 cmH2O (mantém pulmão aberto)
• Pressão transrespiratória: Patm - Pip = gradiente que move o ar

INSPIRAÇÃO (ativa):
1. Diafragma contrai → volume torácico aumenta
2. Pip cai para -8 cmH2O (mais negativa)
3. Pulmões expandem (seguem a parede torácica pela pressão negativa pleural)
4. Palv cai para -1 cmH2O
5. Gradiente Patm - Palv = +1 cmH2O → ar entra
6. Ao fim da inspiração, Palv volta a 0 → fluxo cessa

EXPIRAÇÃO PASSIVA (repouso):
1. Diafragma relaxa → recuo elástico pulmonar comprime os alvéolos
2. Palv sobe para +1 cmH2O
3. Gradiente Palv - Patm = +1 cmH2O → ar sai
4. Pip retorna a -5 cmH2O

EXPIRAÇÃO ATIVA (esforço): músculos abdominais e intercostais internos comprimem ativamente o tórax, elevando Palv acima de +1 cmH2O.

PNEUMOTÓRAX: entrada de ar no espaço pleural → Pip = Patm = 0 → perda da pressão transpulmonar → colapso pulmonar (atelectasia). No pneumotórax hipertensivo, o mecanismo valvular acumula ar progressivamente, causando desvio do mediastino e colapso cardiovascular.

VOLUMES PULMONARES:
• Volume corrente (VC): 500 mL
• Volume de reserva inspiratório (VRI): 3.000 mL
• Volume de reserva expiratório (VRE): 1.200 mL
• Volume residual (VR): 1.200 mL (não expelido — mantém alvéolos abertos)
• Capacidade pulmonar total (CPT): VC+VRI+VRE+VR = 5.900 mL
• Capacidade vital (CV): CPT - VR = 4.700 mL
• Capacidade residual funcional (CRF): VRE + VR = 2.400 mL',
  'Paciente com faca no tórax desenvolve pneumotórax aberto → equilíbrio entre Pip e Patm → colapso pulmonar ipsilateral. Tratamento: ocluir o ferimento (curativo de 3 pontas) e drenagem torácica. No pneumotórax hipertensivo → desvio de traqueia para o lado oposto ao pneumotórax (sinal clínico clássico).',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a pressão intrapleural normal em repouso e o que ocorre durante a inspiração?',
  'Em repouso: -5 cmH2O (negativa em relação à atmosfera). Durante inspiração: torna-se mais negativa (-8 cmH2O) pela contração do diafragma, expandindo os pulmões e reduzindo a pressão alveolar abaixo da atmosférica (-1 cmH2O), gerando o gradiente que puxa o ar.',
  'pressões pulmonares', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'O que é pressão transpulmonar e qual seu valor normal?',
  'Pressão transpulmonar = Pressão alveolar − Pressão intrapleural = 0 − (−5) = +5 cmH2O. É a pressão que mantém os pulmões expandidos contra seu próprio recuo elástico. Se for 0 (como no pneumotórax), os pulmões colapsam.',
  'pressão transpulmonar', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a diferença entre capacidade vital (CV) e capacidade pulmonar total (CPT)?',
  'CPT = VC + VRI + VRE + VR = ~5.900 mL. CV = CPT − VR = ~4.700 mL (volume máximo que pode ser expirado após inspiração máxima). O volume residual (VR ~1.200 mL) NÃO pode ser expirado voluntariamente e não é medido pela espirometria convencional.',
  'volumes pulmonares', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Durante a inspiração normal em repouso, a pressão alveolar torna-se:',
  'Igual à atmosférica, mantendo o gradiente de difusão',
  'Levemente negativa (-1 cmH2O), criando gradiente para entrada de ar',
  'Fortemente negativa (-20 cmH2O) pelo esforço muscular',
  'Positiva (+5 cmH2O) pela compressão torácica',
  'B',
  'A contração do diafragma expande o tórax, tornando a pressão intrapleural mais negativa (-8 cmH2O). Os pulmões se expandem passivamente (seguem a parede torácica), aumentando o volume alveolar e reduzindo a pressão alveolar para cerca de -1 cmH2O. Esse gradiente de 1 cmH2O entre atmosfera e alvéolo é suficiente para gerar o fluxo de ar inspiratório.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'No pneumotórax hipertensivo, qual mecanismo explica o colapso cardiovascular?',
  'O ar pleural comprime o coração, causando tamponamento',
  'A pressão intrapleural positiva colapsa a veia cava e reduz o retorno venoso, diminuindo o débito cardíaco',
  'A hipoxemia severa causa vasoconstrição coronariana e IAM',
  'O desvio mediastinal rompe os grandes vasos',
  'B',
  'No pneumotórax hipertensivo, o mecanismo valvular acumula ar no espaço pleural, elevando a pressão intrapleural acima da atmosférica. Isso colapsa estruturas de baixa pressão (veia cava superior e inferior), reduzindo dramaticamente o retorno venoso e, consequentemente, o débito cardíaco. O desvio mediastinal contralateral é o sinal radiológico, mas o mecanismo hemodinâmico é a compressão da veia cava.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual dos seguintes volumes pulmonares NÃO pode ser medido diretamente pela espirometria?',
  'Volume corrente',
  'Capacidade vital',
  'Volume residual',
  'Volume de reserva expiratório',
  'C',
  'O volume residual (VR ~1.200 mL) é o ar que permanece nos pulmões após expiração máxima forçada. Por definição, não pode ser expelido e, portanto, não é mensurado pela espirometria convencional. Sua medição requer técnicas especiais como pletismografia corporal ou diluição de hélio. Capacidades que incluem VR (CPT, CRF) também não são medidas pela espirometria simples.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A expiração em repouso é considerada passiva. Qual o mecanismo responsável pela saída do ar?',
  'Contração dos intercostais internos que comprimem o tórax',
  'Recuo elástico do tecido pulmonar e da parede torácica após relaxamento do diafragma',
  'Pressão positiva gerada pela musculatura abdominal',
  'Gradiente osmótico entre o ar alveolar e o ar atmosférico',
  'B',
  'Durante a expiração em repouso, o diafragma simplesmente relaxa. O recuo elástico do tecido pulmonar (fibras elásticas e tensão superficial alveolar) e da parede torácica comprime os alvéolos, elevando a pressão alveolar para +1 cmH2O acima da atmosférica, criando o gradiente de saída do ar. É um processo totalmente passivo. A expiração ativa (forçada) recruta intercostais internos e músculos abdominais.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A Capacidade Residual Funcional (CRF) representa o ponto de equilíbrio do sistema respiratório. O que isso significa fisiologicamente?',
  'É o volume no qual a pressão alveolar é máxima positiva',
  'É o volume no qual as forças de recuo elástico do pulmão para dentro se equilibram com as forças de recuo da parede torácica para fora',
  'É o volume mínimo que evita o colapso das pequenas vias aéreas em qualquer situação',
  'É o volume em que toda a musculatura respiratória está em contração máxima',
  'B',
  'A CRF (~2.400 mL = VRE + VR) é o volume pulmonar ao final de uma expiração passiva normal, representando o estado de equilíbrio do sistema tóraco-pulmonar. Nesse ponto, a tendência do pulmão de colabar (recuo elástico para dentro) é exatamente contrabalançada pela tendência da parede torácica de se expandir (recuo para fora). Em pacientes obesos ou com efusão pleural, a CRF reduz, favorecendo atelectasias.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Mecânica da Ventilação e Pressões Pulmonares' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: COMPLACÊNCIA PULMONAR E SURFACTANTE
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Complacência Pulmonar e Surfactante',
  'Complacência (C) = ΔVolume/ΔPressão, mede a distensibilidade pulmonar. Valor normal ~200 mL/cmH2O. Reduz na fibrose (pulmão rígido) e eleva no enfisema (pulmão "frouxo"). O surfactante é produzido pelos pneumócitos tipo II, sendo 70% dipalmitoilfosfatidilcolina (DPPC). Reduz a tensão superficial alveolar, estabiliza alvéolos de diferentes tamanhos (Lei de Laplace: P=2T/r) e previne o edema pulmonar. Sua deficiência causa a Doença da Membrana Hialina no RN prematuro.',
  'COMPLACÊNCIA PULMONAR:
Definição: variação de volume por variação de pressão: C = ΔV / ΔP
Valor normal: ~200 mL/cmH2O (pulmão isolado) ou ~100 mL/cmH2O (sistema tóraco-pulmonar)

TIPOS DE COMPLACÊNCIA:
• Estática: medida sem fluxo de ar, reflete propriedades elásticas do tecido
• Dinâmica: medida durante fluxo, inclui resistência das vias aéreas

DETERMINANTES DA COMPLACÊNCIA:
1. Tecido elástico pulmonar (fibras de elastina e colágeno)
2. Tensão superficial do líquido que reveste os alvéolos (responsável por ~2/3 da rigidez total)

DOENÇAS QUE ALTERAM COMPLACÊNCIA:
• Complacência REDUZIDA (pulmão rígido): fibrose pulmonar, edema pulmonar, pneumonia, SDRA, doença da membrana hialina. Exige maior pressão para ventilar.
• Complacência AUMENTADA (pulmão frouxo): enfisema (destruição das fibras elásticas). Ventilação fácil mas retenção de ar → aprisionamento aéreo.

SURFACTANTE:
Produzido: pneumócitos tipo II a partir de 24-26 semanas de gestação (quantidade suficiente ~35 semanas)
Composição: 70% dipalmitoilfosfatidilcolina (DPPC/lecitina), 10% esfingomielina, proteínas SP-A, SP-B, SP-C, SP-D

FUNÇÃO DO SURFACTANTE:
1. Reduz tensão superficial alveolar (de ~50 mN/m para ~5 mN/m em alvéolos pequenos)
2. Estabiliza alvéolos de tamanhos diferentes (lei de Laplace)
3. Previne atelectasias
4. Reduz o trabalho respiratório
5. Previne edema alveolar (tensão superficial alta "puxaria" líquido para o alvéolo)

LEI DE LAPLACE: P = 2T/r
• P = pressão dentro do alvéolo
• T = tensão superficial
• r = raio do alvéolo
Sem surfactante, alvéolos pequenos (r pequeno → P alta) esvaziariam nos grandes (P menor) → atelectasia. O surfactante reduz T nos alvéolos menores (sua concentração aumenta quando o alvéolo diminui), equalizando pressões.

ÍNDICE L/E (Lecitina/Esfingomielina):
• >2: pulmão maturo (surfactante suficiente)
• <1,5: alto risco de DMH
Medido no líquido amniótico para avaliar maturidade pulmonar fetal.

DOENÇA DA MEMBRANA HIALINA (DMH):
Causa: deficiência de surfactante em prematuros. Alvéolos colapsam progressivamente. Membrana hialina = proteínas e debris celulares revestindo os ductos alveolares. Tratamento: surfactante exógeno intranasal/endotraqueal, CPAP, corticóide pré-natal (induz produção de surfactante).',
  'Prematura de 28 semanas apresenta gemido, cianose e retração intercostal ao nascer → RX com padrão em vidro fosco bilateral, broncograma aéreo → DMH por deficiência de surfactante. Tratamento: surfactante exógeno (beractanto) intratraqueal + CPAP. Na SDRA do adulto: lesão dos pneumócitos tipo II → perda de surfactante → complacência reduzida → necessidade de PEEP elevada no ventilador para manter alvéolos abertos.',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'O que é complacência pulmonar e como ela se altera no enfisema vs. fibrose?',
  'Complacência = ΔV/ΔP (~200 mL/cmH2O normal). ENFISEMA: aumentada (destruição elástica → pulmão frouxo → fácil de encher, difícil de esvaziar → aprisionamento aéreo). FIBROSE: reduzida (tecido rígido → exige grande pressão para pequenovolume).',
  'complacência, enfisema, fibrose', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Explique a Lei de Laplace aplicada aos alvéolos e o papel do surfactante na estabilidade alveolar.',
  'P = 2T/r. Alvéolos menores têm maior pressão interna (r menor), e sem surfactante esvaziariam nos maiores (atelectasia). O surfactante REDUZ T proporcionalmente mais nos alvéolos pequenos (sua concentração aumenta com a redução do raio), equalizando pressões e estabilizando os alvéolos.',
  'Lei de Laplace, surfactante', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual o índice usado para avaliar maturidade pulmonar fetal e seus valores de referência?',
  'Índice Lecitina/Esfingomielina (L/E) no líquido amniótico. >2 = pulmão maturo, baixo risco DMH. <1,5 = pulmão imaturo, alto risco DMH. Surfactante aparece ~24-26 sem, suficiente ~35 semanas.',
  'surfactante, maturidade pulmonar, DMH', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Segundo a Lei de Laplace (P=2T/r), o que ocorre com alvéolos de raio reduzido na ausência de surfactante?',
  'Aumentam de tamanho por maior complacência local',
  'A pressão interna aumenta, fazendo-os se esvaziar nos alvéolos maiores — mecanismo da atelectasia',
  'A tensão superficial cai espontaneamente para compensar o raio menor',
  'O fluxo de ar aumenta por menor resistência em tubos finos',
  'B',
  'Pela Lei de Laplace, pressão (P) é inversamente proporcional ao raio (r): P = 2T/r. Alvéolos menores têm pressão interna maior. Sem surfactante, essa pressão maior faz o ar dos alvéolos pequenos fluir para os maiores, colapsando os pequenos (atelectasia progressiva). O surfactante resolve isso reduzindo T proporcionalmente mais nos alvéolos menores, equalizando as pressões.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Um prematuro de 29 semanas apresenta, ao nascimento, taquipneia, gemido expiratório e tiragem intercostal. A radiografia mostra opacificação bilateral em vidro fosco com broncograma aéreo. Qual é o diagnóstico e o mecanismo fisiopatológico?',
  'Pneumonia neonatal por Streptococcus agalactiae — infecção sistêmica do RN',
  'Síndrome de aspiração meconial — obstrução mecânica das vias aéreas',
  'Doença da Membrana Hialina — deficiência de surfactante com colapso alveolar progressivo',
  'Taquipneia transitória do RN — reabsorção lenta do líquido pulmonar fetal',
  'C',
  'A DMH (Síndrome do Desconforto Respiratório do RN) ocorre por deficiência de surfactante em prematuros (pulmão maturo ~35 semanas). Sem surfactante, a tensão superficial alveolar aumenta, colapsando os alvéolos na expiração (atelectasia progressiva). O RX em vidro fosco bilateral com broncograma aéreo é clássico. Tratamento: surfactante exógeno intratraqueal, CPAP e, se necessário, ventilação mecânica. Corticóide pré-natal (betametasona) acelera maturação pulmonar.',
  'Neonatologia clínica', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Na fibrose pulmonar, a espirometria mostra redução proporcional de CV e VEF1, com relação VEF1/CV normal ou aumentada. Isso indica padrão:',
  'Obstrutivo — obstrução das vias aéreas por fibrose peribrônquica',
  'Misto — fibrose alveolar associada a broncoespasmo',
  'Restritivo — redução da complacência pulmonar por tecido fibrótico rígido',
  'Normal — a fibrose não altera a espirometria convencional',
  'C',
  'A fibrose pulmonar reduz a complacência (pulmão rígido), diminuindo todos os volumes pulmonares proporcionalmente (padrão RESTRITIVO). CV e VEF1 reduzem juntos, mantendo a relação VEF1/CV normal ou até aumentada (diferente da DPOC, que tem padrão obstrutivo com VEF1/CV <70%). Na espirometria: CV < 80% do previsto sem obstrução ao fluxo. Confirma-se com CPT reduzida na pletismografia.',
  'Pneumologia - Harrison', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual das seguintes afirmativas sobre o surfactante é INCORRETA?',
  'É produzido pelos pneumócitos tipo II a partir de aproximadamente 24-26 semanas de gestação',
  'Sua composição principal é a dipalmitoilfosfatidilcolina (DPPC)',
  'Aumenta a tensão superficial alveolar para evitar o colapso dos alvéolos',
  'Sua deficiência no prematuro causa a Doença da Membrana Hialina',
  'C',
  'Esta alternativa está INCORRETA. O surfactante REDUZ (não aumenta) a tensão superficial alveolar. A tensão superficial alta — sem surfactante — é o que causaria o colapso alveolar. O surfactante reduz a tensão de ~50 mN/m para ~5 mN/m nos alvéolos menores, estabilizando-os e prevenindo atelectasias. As demais alternativas estão corretas.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Por que o surfactante também previne o edema pulmonar?',
  'Aumenta a pressão oncótica alveolar, retendo líquido nos capilares',
  'Reduz a permeabilidade capilar ao estimular a produção de proteínas de oclusão',
  'A alta tensão superficial sem surfactante geraria pressão negativa no interstício, puxando líquido do capilar para o alvéolo',
  'Estimula a produção de ADH, reduzindo a diurese e o edema sistêmico',
  'C',
  'Pela Lei de Laplace, a tensão superficial alta na interface ar-líquido alveolar gera pressão negativa no interstício pulmonar (tende a "puxar" o alvéolo para dentro). Essa pressão negativa intersticial favorece a transudação de líquido dos capilares para o espaço intersticial e alveolar. O surfactante, ao reduzir a tensão superficial, reduz essa pressão negativa intersticial, prevenindo o acúmulo de líquido — um dos mecanismos protetores contra o edema pulmonar.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Complacência Pulmonar e Surfactante' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: DIFUSÃO DOS GASES E TRANSPORTE DE O2
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Difusão dos Gases e Transporte de O2',
  'A difusão dos gases obedece à Lei de Fick: fluxo ∝ (área × diferença de pressão parcial) / (espessura da membrana). A membrana alvéolo-capilar tem ~0,5 μm. PO2 alveolar ~100 mmHg, PO2 venosa ~40 mmHg → gradiente de 60 mmHg. PCO2 venosa ~46 mmHg, PCO2 alveolar ~40 mmHg → gradiente de 6 mmHg. O2 é transportado 98,5% ligado à hemoglobina (1 Hb transporta 4 O2) e 1,5% dissolvido no plasma. Conteúdo arterial de O2 = (1,34 × Hb × SaO2) + (0,003 × PaO2).',
  'DIFUSÃO - LEI DE FICK:
Fluxo = (D × A × ΔP) / e
Onde: D = coeficiente de difusão do gás; A = área de troca; ΔP = diferença de pressão parcial; e = espessura da membrana

PROPRIEDADES DOS GASES:
• Solubilidade: CO2 é 20x mais solúvel que O2 → difunde muito mais facilmente, apesar do menor gradiente de pressão
• Peso molecular: gases mais leves difundem mais rápido
• CO2 difunde 20x mais rápido que O2 → hipercapnia é sinal mais tardio que hipoxemia em doenças de difusão

MEMBRANA ALVÉOLO-CAPILAR:
Composta por: fluido surfactante + pneumócito tipo I + membrana basal + endotélio capilar
Espessura normal: ~0,5 μm → permite equilíbrio completo em ~0,25 seg (eritrócito transita em 0,75 seg)
Em exercício intenso: trânsito reduz para ~0,25 seg — ainda suficiente para equilíbrio
Em fibrose, edema ou SDRA: espessura aumenta → déficit de difusão → hipoxemia, especialmente em exercício

PRESSÕES PARCIAIS (ar ambiente nível do mar):
• PO2 inspirado: 160 mmHg (21% × 760 mmHg)
• PO2 alveolar: ~100 mmHg (equação do gás alveolar: PAO2 = PiO2 − PaCO2/QR = 150 − 40/0,8 = 100 mmHg)
• PO2 venosa mista (sangue que chega ao pulmão): ~40 mmHg → gradiente alveolar-venoso = 60 mmHg
• PCO2 alveolar: ~40 mmHg; PCO2 venosa mista: ~46 mmHg → gradiente = 6 mmHg (suficiente pelo CO2 ser muito mais solúvel)

TRANSPORTE DE O2:
97% ligado à hemoglobina e 1,5-3% dissolvido no plasma

1. LIGADO À HEMOGLOBINA (oxiemoglobina):
• 1 g de Hb carrega 1,34 mL O2 (quando saturada 100%)
• Com Hb = 15 g/dL e SaO2 = 97%: 15 × 1,34 × 0,97 = 19,5 mL O2/100 mL sangue

2. DISSOLVIDO NO PLASMA:
• 0,003 mL O2 / mmHg PO2 / 100 mL sangue
• Com PaO2 = 100 mmHg: 0,003 × 100 = 0,3 mL O2/100 mL sangue

CONTEÚDO ARTERIAL DE O2 (CaO2):
CaO2 = (1,34 × Hb × SaO2) + (0,003 × PaO2)
Valor normal: ~20 mL O2/100 mL sangue

ENTREGA DE O2 AOS TECIDOS (DO2):
DO2 = Débito Cardíaco × CaO2
Normal: 5 L/min × 200 mL O2/L = 1.000 mL O2/min
Consumo tissular (VO2): ~250 mL O2/min
Fração de extração: ~25%',
  'Paciente com fibrose pulmonar: em repouso PaO2 normal (tempo suficiente para equilíbrio), mas em exercício o trânsito rápido do eritrócito não permite equilíbrio completo → hipoxemia de esforço. Anemia grave (Hb = 5 g/dL): CaO2 cai drasticamente mesmo com SaO2 normal (100% de saturação de pouca hemoglobina). PaO2 normal, mas O2 delivery comprometido. Tratamento: transfusão (aumenta Hb, não a PaO2).',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Por que o CO2 difunde mais facilmente que o O2 apesar de ter menor gradiente de pressão?',
  'O CO2 é ~20x mais SOLÚVEL nos fluidos biológicos que o O2 (coeficiente de difusão maior). Apesar do gradiente de apenas 6 mmHg (vs 60 mmHg do O2), o CO2 difunde rapidamente o suficiente. Por isso, hipercapnia geralmente indica hipoventilação alveolar (não falha de difusão), enquanto hipoxemia pode ocorrer por distúrbios de difusão.',
  'difusão, CO2, O2', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Como calcular o conteúdo arterial de O2 (CaO2)?',
  'CaO2 = (1,34 × Hb × SaO2) + (0,003 × PaO2). Exemplo: Hb=15, SaO2=97%, PaO2=100 → CaO2 = (1,34 × 15 × 0,97) + (0,003 × 100) = 19,5 + 0,3 = 19,8 mL/dL. A fração dissolvida é mínima; quase todo O2 está na Hb.',
  'CaO2, transporte de O2', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a diferença entre PaO2 e SaO2 como medidas de oxigenação?',
  'PaO2 = pressão parcial de O2 dissolvido no plasma (normal: 80-100 mmHg). SaO2 = % de hemoglobina saturada com O2 (normal: 95-99%). A SaO2 reflete a CARGA de O2 (quanto está sendo transportado), enquanto a PaO2 reflete o GRADIENTE de difusão. Na anemia, PaO2 e SaO2 podem ser normais, mas o conteúdo total de O2 é baixo (pouca Hb).',
  'PaO2, SaO2', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Paciente com fibrose pulmonar grave apresenta PaO2 = 90 mmHg em repouso, mas durante caminhada cai para 60 mmHg. Qual o mecanismo responsável?',
  'Broncoespasmo induzido pelo exercício comprimindo as vias aéreas',
  'Aumento do shunt intrapulmonar pelo esforço físico',
  'Espessamento da membrana alvéolo-capilar: em exercício, o trânsito do eritrócito é mais rápido, insuficiente para equilíbrio completo da difusão',
  'Hiperventilação de exercício que aumenta a PCO2 e desloca a hemoglobina',
  'C',
  'Em repouso, o eritrócito transita pelo capilar alveolar em ~0,75 seg. O equilíbrio de O2 ocorre nos primeiros 0,25 seg — há "reserva" de tempo. Em fibrose, a membrana espessada dificulta a difusão, mas em repouso o tempo ainda é suficiente. Em exercício, o débito cardíaco aumenta, o trânsito do eritrócito cai para ~0,25 seg, e a membrana espessa não permite equilíbrio completo → hipoxemia de esforço é o sinal precoce clássico da fibrose.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Uma paciente anêmica tem hemoglobina de 5 g/dL, PaO2 = 98 mmHg e SaO2 = 98%. Qual o conteúdo arterial de O2 e como isso difere de um indivíduo normal?',
  'CaO2 ≈ 6,8 mL/dL — menos de 1/3 do normal (20 mL/dL), apesar de PaO2 e SaO2 normais',
  'CaO2 ≈ 20 mL/dL — normal, pois PaO2 e SaO2 estão adequadas',
  'CaO2 ≈ 15 mL/dL — discretamente reduzido, compensado pelo maior débito cardíaco',
  'CaO2 não pode ser calculado sem a PCO2 arterial',
  'A',
  'CaO2 = (1,34 × 5 × 0,98) + (0,003 × 98) = 6,56 + 0,29 = 6,85 mL/dL. No normal: (1,34 × 15 × 0,97) + (0,003 × 100) = 19,5 mL/dL. A anemia grave reduz drasticamente o transporte de O2 mesmo com PaO2 e SaO2 normais, porque quase todo O2 é transportado pela Hb. A suplementação de O2 tem pouco benefício; a transfusão (que aumenta a Hb) é o tratamento correto.',
  'Fisiologia - Guyton', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual a PO2 alveolar (PAO2) estimada ao nível do mar com FiO2 = 0,21 e PaCO2 = 40 mmHg? (Use QR = 0,8; PH2O = 47 mmHg)',
  '100 mmHg',
  '150 mmHg',
  '120 mmHg',
  '80 mmHg',
  'A',
  'Equação do gás alveolar: PAO2 = FiO2 × (Patm − PH2O) − PaCO2/QR = 0,21 × (760 − 47) − 40/0,8 = 0,21 × 713 − 50 = 149,7 − 50 = 99,7 ≈ 100 mmHg. Esta equação é fundamental para calcular o gradiente alvéolo-arterial de O2 (P(A-a)O2 = PAO2 − PaO2, normal ≤ 15 mmHg). Gradiente aumentado sugere shunt ou distúrbio V/Q.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Em intoxicação por monóxido de carbono (CO), a PaO2 e a SaO2 medida pelo oxímetro de pulso podem ser normais, mas o paciente apresenta hipoxia tissular grave. Qual o mecanismo?',
  'O CO bloqueia o citocromo c oxidase mitocondrial, impedindo a utilização de O2',
  'O CO se liga à hemoglobina com afinidade 240x maior que o O2, formando carboxiemoglobina, que não transporta O2 mas não é detectada como desoxiemoglobina pelo oxímetro',
  'O CO causa vasoconstrição sistêmica severa, reduzindo o débito cardíaco',
  'O CO aumenta a afinidade da Hb pelo O2 (desvio à esquerda), impedindo a liberação nos tecidos',
  'B',
  'O CO tem afinidade pela hemoglobina 240x maior que o O2, formando carboxiemoglobina (HbCO). A HbCO é detectada como oxiemoglobina pelo oxímetro convencional (mesmo comprimento de onda de absorção), gerando falsa SaO2 normal. A PaO2 mede o O2 dissolvido no plasma — que realmente é normal. Mas a Hb está "bloqueada" pelo CO e não transporta O2. Diagnóstico: co-oximetria arterial (detecta HbCO). Tratamento: O2 a 100% (desloca CO da Hb), câmara hiperbárica em casos graves.',
  'Fisiopatologia - Harrison', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual componente da Lei de Fick é mais comprometido no edema pulmonar agudo (EPA)?',
  'Diferença de pressão parcial (ΔP) — o edema eleva a PO2 no espaço intersticial',
  'Espessura da membrana (e) — o edema aumenta a distância de difusão',
  'Área de troca (A) — o edema colapsa todos os alvéolos uniformemente',
  'Coeficiente de difusão (D) — o edema altera a composição gasosa do ar alveolar',
  'B',
  'No EPA, o líquido se acumula inicialmente no interstício pulmonar e depois no espaço alveolar, aumentando a espessura da membrana alvéolo-capilar (componente "e" da lei de Fick). Isso dificulta a difusão de O2 (que já tem menor coeficiente de difusão que o CO2), causando hipoxemia. A área de troca também pode reduzir pelos alvéolos alagados, mas o principal mecanismo inicial é o aumento da espessura da barreira de difusão.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Difusão dos Gases e Transporte de O2' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: TRANSPORTE DE CO2 E CURVA DE DISSOCIAÇÃO DA Hb
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Transporte de CO2 e Curva de Dissociação da Hemoglobina',
  'CO2 é transportado: 70% como bicarbonato (via anidrase carbônica → CO2+H2O → H2CO3 → H+ + HCO3-), 23% ligado à Hb (carbaminoemoglobina) e 7% dissolvido. A curva de dissociação da Hb é sigmoide, com P50 normal de 26-27 mmHg. Desvio à DIREITA: ↑T, ↑PCO2, ↑H+ (↓pH), ↑2,3-DPG → facilita liberação de O2 nos tecidos. Desvio à ESQUERDA: ↓T, ↓PCO2, ↑pH, Hb fetal → maior afinidade pelo O2, menor liberação tissular.',
  'TRANSPORTE DE CO2 (do tecido ao pulmão):
1. BICARBONATO (70%): CO2 entra no eritrócito → anidrase carbônica converte em H2CO3 → H+ + HCO3-. O HCO3- sai do eritrócito em troca de Cl- (troca de cloreto / efeito Hamburger). O H+ é tamponado pela desoxiemoglobina (principal tampão intravascular).
2. CARBAMINOEMOGLOBINA (23%): CO2 liga-se a grupos amino terminais da globina (não ao ferro).
3. DISSOLVIDO (7%): pequena fração no plasma.

EFEITO HALDANE: a desoxiemoglobina (nos tecidos) tem MAIOR capacidade de transportar CO2 que a oxiemoglobina. Portanto, quando o O2 é liberado nos tecidos, a Hb fica mais apta a capturar CO2 → favorece o transporte de CO2 dos tecidos ao pulmão. No pulmão, o O2 se liga à Hb e desloca o CO2 (deslocamento reverso).

CURVA DE DISSOCIAÇÃO DA HEMOGLOBINA:
Forma sigmoide → importância: platô superior (Hb mantém saturação alta mesmo com queda de PO2, até ~70 mmHg — segurança na altitude) + parte íngreme (pequena queda de PO2 libera muito O2 — eficiência tissular).

P50: PO2 na qual 50% da Hb está saturada. Normal: 26-27 mmHg.

DESVIO À DIREITA (↓ afinidade pelo O2 → ↑ liberação nos tecidos):
Causas: ↑ Temperatura, ↑ PCO2, ↑ H+ (↓ pH) → EFEITO BOHR, ↑ 2,3-DPG
Memória: nos tecidos em trabalho (quente, ácido, com CO2 alto) → O2 se libera mais facilmente → IDEAL para exercício

EFEITO BOHR: ↓pH (↑H+) desloca curva para direita → Hb libera mais O2. Nos tecidos metabolicamente ativos, ácido láctico e CO2 produzidos deslocam o equilíbrio para liberar mais O2 — mecanismo adaptativo brilhante.

DESVIO À ESQUERDA (↑ afinidade pelo O2 → ↓ liberação nos tecidos):
Causas: ↓ Temperatura, ↓ PCO2, ↓ H+ (↑ pH), ↑ Hb fetal (HbF), carboxiemoglobina, meta-hemoglobina
Hemoglobina fetal: tem maior afinidade pelo O2 (P50 ~18 mmHg) → consegue "roubar" O2 da Hb materna na placenta → vantagem para o feto

2,3-DIFOSFOGLICERATO (2,3-DPG):
Produzido na glicólise anaeróbia do eritrócito.
Aumentado em: altitude, anemia crônica, DPOC → adaptação para liberar mais O2 nos tecidos.
Liga-se à Hb desoxigenada, estabilizando o estado T (tenso, baixa afinidade), desviando curva à direita.
HbF tem menor afinidade ao 2,3-DPG → permanece com maior afinidade pelo O2.',
  'Paciente em acidose metabólica (pH 7,2): efeito Bohr desloca curva à direita → Hb libera mais O2 nos tecidos (adaptação compensatória). Atleta em altitude (La Paz, 3.600 m): produz mais 2,3-DPG em semanas → desvio à direita → maior liberação de O2 (adaptação a longo prazo). Intoxicação por CO: HbCO desloca curva à ESQUERDA (restante da Hb fica com afinidade aumentada, liberando ainda menos O2 nos tecidos) → duplo mecanismo de hipóxia.',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Quais são as três formas de transporte de CO2 no sangue e suas proporções?',
  '1. Bicarbonato (HCO3-): 70% — formado pela anidrase carbônica nos eritrócitos. 2. Carbaminoemoglobina: 23% — CO2 ligado a grupos amino da globina. 3. CO2 dissolvido no plasma: 7%. O bicarbonato é dominante e fundamental para o equilíbrio ácido-base.',
  'transporte CO2', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'O que é o Efeito Bohr e qual sua importância clínica?',
  'Efeito Bohr: ↑ H+ (↓ pH) ou ↑ PCO2 DESLOCA a curva de dissociação à DIREITA, reduzindo afinidade da Hb pelo O2 → maior liberação nos tecidos. Importância: tecidos em atividade (ácidos, com PCO2 alta) recebem mais O2 automaticamente. Em acidose metabólica grave: desvio excessivo pode eventualmente comprometer captura de O2 no pulmão.',
  'Efeito Bohr, curva de dissociação', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Por que a hemoglobina fetal (HbF) consegue "roubar" O2 da hemoglobina materna na placenta?',
  'HbF tem P50 ~18 mmHg vs. HbA P50 ~27 mmHg → MAIOR afinidade pelo O2 (desvio à esquerda). Na placenta, onde PO2 é intermediária, a HbF capta O2 que a HbA libera. Mecanismo: HbF tem menor afinidade ao 2,3-DPG (que reduz afinidade pelo O2), portanto fica na forma de alta afinidade.',
  'HbF, hemoglobina fetal, placenta', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Um paciente em exercício intenso apresenta temperatura de 39°C, pH de 7,30 e PCO2 de 50 mmHg no músculo ativo. Como essas alterações afetam a curva de dissociação da hemoglobina?',
  'Desvio à esquerda: a hemoglobina retém mais O2, protegendo os tecidos do estresse oxidativo',
  'Desvio à direita: os três fatores (temperatura, pH, PCO2) convergem para facilitar a liberação de O2 nos músculos em atividade',
  'Sem efeito: a curva sigmoide é imutável em condições fisiológicas',
  'Desvio à direita apenas pela temperatura; pH e PCO2 têm efeito oposto que se cancela',
  'B',
  'Os três fatores — ↑ temperatura, ↓ pH (efeito Bohr) e ↑ PCO2 — são todos desviadores para DIREITA da curva. Isso reduz a afinidade da Hb pelo O2, facilitando sua liberação nos tecidos musculares em exercício. É uma resposta adaptativa coordenada: o músculo em trabalho cria exatamente o ambiente que sinaliza à Hb para liberar mais O2. O 2,3-DPG também aumenta em exercício prolongado, somando ao desvio à direita.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'O Efeito Haldane descreve que a desoxiemoglobina transporta mais CO2 que a oxiemoglobina. Qual é a consequência prática desse efeito na circulação pulmonar?',
  'No pulmão, ao liberar CO2 para os alvéolos, a Hb não consegue capturar O2 simultaneamente',
  'No pulmão, a ligação do O2 à Hb desloca o CO2 (efeito reverso), facilitando a eliminação de CO2 pelo pulmão',
  'O efeito Haldane ocorre apenas nos tecidos, não tendo relevância na circulação pulmonar',
  'A oxiemoglobina transporta mais CO2 que a desoxiemoglobina — o efeito Haldane facilita o transporte pulmonar de CO2',
  'B',
  'O efeito Haldane é bidirecional: nos tecidos, quando O2 é liberado e a Hb se torna desoxiemoglobina, sua capacidade de carregar CO2 aumenta (capta mais CO2). No pulmão, o O2 se liga à Hb e a converte em oxiemoglobina, que tem MENOR afinidade pelo CO2 → libera CO2 para o alvéolo. Portanto, os efeitos Bohr e Haldane cooperam: Bohr facilita liberação de O2 nos tecidos; Haldane facilita eliminação de CO2 no pulmão.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Alpinista que sobe ao Kilimanjaro (5.895 m) desenvolve, após 3 semanas, adaptações fisiológicas que permitem melhor oxigenação tissular. Qual mecanismo é o mais importante para a liberação de O2 nos tecidos nessa situação?',
  'Aumento da frequência respiratória para compensar a baixa PO2 atmosférica',
  'Aumento do 2,3-DPG eritrocitário, desviando a curva de dissociação para direita',
  'Vasoconstrição pulmonar hipóxica para redistribuir fluxo sanguíneo',
  'Aumento da HbF em detrimento da HbA em adultos adaptados à altitude',
  'B',
  'A adaptação à altitude inclui: imediata (hiperventilação, taquicardia), dias (poliglobulia — eritropoietina), e semanas (↑ 2,3-DPG nos eritrócitos). O 2,3-DPG se liga à Hb desoxigenada, estabilizando o estado de baixa afinidade (forma T), desviando a curva à direita. Isso facilita a liberação de O2 nos tecidos mesmo com saturação arterial reduzida. A HbF é específica do feto e não é produzida em adultos.',
  'Fisiologia do Exercício - Guyton', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A anidrase carbônica eritrocitária é fundamental para o transporte de CO2. O que ocorre quando ela é inibida (ex: acetazolamida)?',
  'CO2 acumula no sangue pois não consegue ser convertido a HCO3-, causando acidose respiratória',
  'A conversão de CO2 a HCO3- é drasticamente reduzida, prejudicando o transporte de CO2 e gerando acidose metabólica por acúmulo de CO2 tissular',
  'A HCO3- sérica aumenta excessivamente, causando alcalose metabólica',
  'Nenhum efeito: o plasma tem anidrase carbônica suficiente para compensar',
  'B',
  'A anidrase carbônica (AC) converte CO2 + H2O → H2CO3 → H+ + HCO3- nos eritrócitos. Sem ela, o CO2 dos tecidos acumula no sangue (a reação sem enzima é 1.000x mais lenta). A acetazolamida inibe a AC e é usada clinicamente para: glaucoma (reduz humor aquoso), mal da altitude (estimula ventilação via acidose), e como diurético fraco. No uso terapêutico, o principal efeito é acidose metabólica leve (perda de HCO3- na urina), o que estimula o centro respiratório.',
  'Farmacologia - Katzung', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Em qual situação clínica a curva de dissociação da hemoglobina apresenta desvio à ESQUERDA com consequências deletérias para o paciente?',
  'Exercício físico intenso com acidose lática',
  'Sepse com febre alta e consumo elevado de O2',
  'Intoxicação por monóxido de carbono — a HbCO desloca a curva à esquerda e reduz a liberação de O2 nos tecidos',
  'DPOC com hipercapnia crônica e poliglobulia',
  'C',
  'Na intoxicação por CO, além de "bloquear" sítios de ligação da Hb (formando HbCO), o CO causa desvio à ESQUERDA da curva de dissociação da Hb residual. Isso significa que a hemoglobina ainda disponível tem maior afinidade pelo O2 e libera menos O2 nos tecidos. É um duplo mecanismo prejudicial: menos Hb disponível E a que sobra libera menos O2. Daí a gravidade da intoxicação por CO mesmo em níveis moderados de HbCO.',
  'Fisiopatologia - Harrison', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Transporte de CO2 e Curva de Dissociação da Hb' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: RELAÇÃO VENTILAÇÃO/PERFUSÃO E ESPAÇO MORTO
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Relação V/Q, Espaço Morto e Shunt Pulmonar',
  'A relação ventilação/perfusão (V/Q) normal é ~0,8 (ventilação alveolar 4 L/min, perfusão 5 L/min). Variação regional: ápice tem V/Q alto (~3,3), base tem V/Q baixo (~0,63). Espaço morto fisiológico = anatômico (150 mL) + alveolar (alvéolos ventilados não perfundidos). Shunt = perfusão sem ventilação (V/Q = 0). Causas de hipoxemia: hipoventilação, desequilíbrio V/Q, shunt, difusão e baixa PiO2. O gradiente P(A-a)O2 diferencia hipo-ventilação pura (P(A-a) normal) das demais causas (P(A-a) aumentado).',
  'RELAÇÃO V/Q NORMAL:
• Ventilação alveolar total: ~4 L/min
• Perfusão pulmonar total: ~5 L/min
• V/Q médio: 4/5 = 0,8

GRADIENTE REGIONAL (em pé):
• Ápice: pouca perfusão (vasos colapsados por pressão hidrostática baixa), boa ventilação → V/Q ~3,3 → ar mais "seco" (PO2 alta, PCO2 baixa)
• Base: perfusão abundante (gravitacional), ventilação um pouco menor → V/Q ~0,63
• Consequência: em TB pulmonar, o ápice (V/Q alto, PO2 alta) é sítio preferencial do M. tuberculosis, que é aeróbio

ESTADOS EXTREMOS DE V/Q:
• V/Q = 0 (SHUNT): alvéolo perfundido mas NÃO ventilado. Sangue venoso misto passa pelo pulmão sem ser oxigenado → sangue desoxigenado volta para circulação arterial. NÃO melhora com O2 suplementar (ar não chega ao alvéolo). Ex: atelectasia, pneumonia consolidante, edema pulmonar, cardiopatias congênitas com shunt D→E.
• V/Q = ∞ (ESPAÇO MORTO ALVEOLAR): alvéolo ventilado mas NÃO perfundido. Ar desperdiçado. Ex: TEP (embolia pulmonar).

ESPAÇO MORTO FISIOLÓGICO (de Bohr):
VD/VT = (PaCO2 − PĒCO2) / PaCO2
Onde: VD = volume do espaço morto; VT = volume corrente; PĒCO2 = PCO2 expirado médio
Normal: VD/VT = 150 mL / 500 mL = 0,3 (30%)
Em TEP: espaço morto aumenta (alvéolos sem perfusão) → PĒCO2 cai (CO2 não chega ao ar expirado dos alvéolos-mortos) → ↑ VD/VT

HIPOXEMIA — CINCO MECANISMOS:
1. Hipoventilação alveolar: ↑ PCO2 → ↓ PAO2. P(A-a) NORMAL. Responde a O2.
2. Desequilíbrio V/Q: causa mais comum de hipoxemia. P(A-a) AUMENTADO. Responde parcialmente ao O2.
3. Shunt: P(A-a) AUMENTADO. NÃO responde significativamente ao O2.
4. Distúrbio de difusão: P(A-a) AUMENTADO. Responde ao O2.
5. Baixa PiO2 (altitude): P(A-a) NORMAL (fisiológico).

GRADIENTE P(A-a)O2:
P(A-a) = PAO2 − PaO2
Normal: ≤15 mmHg (jovem) ou ≤ (idade/4) + 4 mmHg
AUMENTADO em: shunt, V/Q desigual, distúrbio de difusão
NORMAL em: hipoventilação pura, altitude',
  'Embolia pulmonar: área com V/Q = ∞ (ventilada, não perfundida). Gasometria mostra hipoxemia (por redistribuição de fluxo para áreas com V/Q baixo) + hipocapnia (hiperventilação compensatória) + P(A-a) aumentado. Pneumonia lobar: V/Q = 0 (shunt) na área consolidada → hipoxemia que NÃO melhora totalmente com O2 (shunt verdadeiro). DPOC: múltiplas áreas com V/Q desigual → hipoxemia que MELHORA com O2 suplementar (V/Q baixo mas não zero).',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Por que o tuberculose pulmonar prefere o ápice do pulmão?',
  'O ápice tem V/Q alto (~3,3 vs. 0,63 na base), com PO2 alveolar mais elevada (~130 mmHg vs. ~89 mmHg na base). O M. tuberculosis é aeróbio obrigatório e cresce preferencialmente em ambientes com alta PO2. O fluxo sanguíneo baixo no ápice também reduz a chegada de células imunes.',
  'V/Q, tuberculose, ápice', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a diferença fundamental entre shunt e espaço morto em termos de V/Q?',
  'SHUNT: V/Q = 0 → alvéolo PERFUNDIDO mas não ventilado. Sangue venoso não é oxigenado. NÃO melhora com O2 suplementar. Ex: pneumonia consolidante, atelectasia. ESPAÇO MORTO ALVEOLAR: V/Q = ∞ → alvéolo VENTILADO mas não perfundido. Ar desperdiçado. Ex: embolia pulmonar.',
  'shunt, espaço morto, V/Q', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'O que é o gradiente P(A-a)O2 e como ele diferencia as causas de hipoxemia?',
  'P(A-a) = PAO2 − PaO2. Normal ≤15 mmHg. NORMAL: hipoventilação pura e baixa PiO2 (altitude) — o problema é falta de O2 chegando ao alvéolo, mas quando chega, difunde normalmente. AUMENTADO: shunt (não melhora com O2), V/Q desigual (melhora parcialmente), distúrbio de difusão (melhora com O2). É a ferramenta para diferenciar causas de hipoxemia na gasometria.',
  'P(A-a), hipoxemia', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Paciente com pneumonia lobar extensa apresenta PaO2 = 55 mmHg e não melhora com O2 a 100% via máscara. O gradiente P(A-a)O2 está elevado. Qual o mecanismo de hipoxemia?',
  'Hipoventilação alveolar — PCO2 alta comprime o O2 alveolar',
  'Shunt intrapulmonar — alvéolos consolidados são perfundidos mas não ventilados (V/Q = 0)',
  'Distúrbio de difusão — exsudato espessa a membrana alvéolo-capilar',
  'Desequilíbrio V/Q leve — que responde completamente ao O2 suplementar',
  'B',
  'Na pneumonia consolidante, os alvéolos estão preenchidos por exsudato (não há ar). Eles continuam perfundidos (sangue flui), mas não ventilados (V/Q = 0) → shunt verdadeiro. O sangue venoso passa sem ser oxigenado e dilui o sangue arterial. O O2 suplementar NÃO ajuda porque não chega aos alvéolos consolidados. Esta é a distinção clínica crucial: hipoxemia que não responde ao O2 = shunt; hipoxemia que melhora com O2 = V/Q desigual ou distúrbio de difusão.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Paciente com TEP (tromboembolismo pulmonar) apresenta hipoxemia e hipocapnia. Qual o mecanismo da hipocapnia?',
  'O êmbolo libera CO2 no sangue, causando hipercapnia — e não hipocapnia',
  'A área obstruída vira espaço morto; a hipoxemia reflexamente aumenta a frequência respiratória (hiperventilação), que elimina CO2 excessivamente',
  'A hipóxia inibe o centro respiratório, reduzindo a eliminação de CO2',
  'O êmbolo absorve CO2 do sangue circulante, reduzindo a PaCO2',
  'B',
  'No TEP: área obstruída = espaço morto alveolar (V/Q = ∞). O êmbolo redireciona fluxo para outras áreas (V/Q baixo → hipoxemia). A hipoxemia estimula quimiorreceptores periféricos → hiperventilação → eliminação excessiva de CO2 → hipocapnia. A combinação clássica do TEP na gasometria é: hipoxemia + hipocapnia + P(A-a) aumentado + alcalose respiratória. PCO2 alta no TEP seria sinal de mau prognóstico (exaustão respiratória).',
  'Medicina de urgência', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual das seguintes condições causa hipoxemia com gradiente P(A-a)O2 NORMAL?',
  'Fibrose pulmonar',
  'Embolia pulmonar',
  'Hipoventilação por overdose de opioides',
  'SDRA',
  'C',
  'Na hipoventilação pura (overdose de opioides, miopatia grave, obesidade mórbida), o problema é que pouco ar chega aos alvéolos. A PAO2 cai (PCO2 alta "substitui" O2 no alvéolo — equação do gás alveolar). Mas a membrana alvéolo-capilar é normal → todo O2 que chega ao alvéolo atravessa normalmente → P(A-a) normal. O diagnóstico é feito pela PCO2 alta + P(A-a) normal. Fibrose, TEP e SDRA têm P(A-a) aumentado.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'A vasoconstricção pulmonar hipóxica (VPH) é um mecanismo reflexo importante. Qual sua função fisiológica?',
  'Aumentar a pressão arterial pulmonar para melhorar a perfusão dos ápices',
  'Redirecionar o fluxo sanguíneo de áreas hipóxicas (mal ventiladas) para áreas bem ventiladas, otimizando a relação V/Q',
  'Estimular a produção de surfactante nas áreas hipóxicas para reconvulsioná-las',
  'Reduzir o trabalho cardíaco direito ao diminuir o fluxo pulmonar total',
  'B',
  'A VPH é um mecanismo local: hipóxia alveolar causa vasoconstrição da arteríola pulmonar adjacente, desviando o fluxo sanguíneo para alvéolos bem ventilados. Resultado: melhora da relação V/Q global. É o oposto do que ocorre na circulação sistêmica (onde hipóxia causa VASO-DILATAÇÃO). Se a hipóxia é generalizada (altitude, DPOC grave), a VPH generalizada causa hipertensão pulmonar → cor pulmonale. Vasodilatadores pulmonares (sildenafila) tratam a hipertensão mas podem piorar o V/Q ao abolir a VPH local.',
  'West - Fisiologia Respiratória', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Um paciente com DPOC grave tem PaO2 = 52 mmHg. Ao receber O2 a 28% via Venturi mask, a PaO2 sobe para 72 mmHg. Isso é consistente com qual mecanismo de hipoxemia predominante?',
  'Shunt puro — O2 suplementar nunca melhora shunt',
  'Desequilíbrio V/Q — O2 suplementar melhora parcialmente ao elevar a PAO2 nas áreas com V/Q baixo',
  'Distúrbio de difusão grave — espessamento da membrana exige FiO2 muito alta',
  'Hipoventilação pura — PCO2 alta comprimia a PAO2',
  'B',
  'Na DPOC, o mecanismo predominante de hipoxemia é o desequilíbrio V/Q (áreas com V/Q baixo mas não zero — shunt funcional). Ao aumentar a FiO2, eleva-se a PAO2 mesmo nas áreas mal ventiladas, e algum O2 adicional difunde para o sangue → SaO2 melhora. Isso diferencia do shunt verdadeiro (pneumonia, atelectasia), no qual O2 suplementar não ajuda pois os alvéolos não estão ventilados. O O2 em DPOC deve ser titulado com cautela (risco de hipercapnia por supressão do drive hipóxico).',
  'Pneumologia clínica', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Relação Ventilação/Perfusão e Espaço Morto' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: CONTROLE NEURAL E QUIMIORRECEPTORES
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Controle Neural da Respiração e Quimiorreceptores',
  'O centro respiratório localiza-se no tronco encefálico (bulbo e ponte). Grupos respiratórios dorsal (GRD) e ventral (GRV) no bulbo controlam o ritmo. O grupo pneumotáxico na ponte limita a inspiração. Quimiorreceptores CENTRAIS (medula oblonga): respondem principalmente ao pH do LCR (indiretamente ao CO2). Quimiorreceptores PERIFÉRICOS (corpos carotídeos e aórticos): respondem à hipoxemia (PaO2 <60 mmHg), hipercapnia e acidose. O CO2 é o regulador mais potente da ventilação em indivíduos normais.',
  'CENTRO RESPIRATÓRIO - LOCALIZAÇÃO:
• Grupo Respiratório Dorsal (GRD): bulbo dorsal → neurônios inspiratórios, geram o ritmo básico
• Grupo Respiratório Ventral (GRV): bulbo ventrolateral → recrutado na respiração forçada (inspiração e expiração ativas)
• Grupo Pneumotáxico (ponte superior): limita a duração da inspiração, controla frequência respiratória
• Grupo Apnêustico (ponte inferior): prolonga a inspiração (inibido pelo pneumotáxico)

RITMO RESPIRATÓRIO:
Gerado por "marcapassos" no complexo pré-Bötzinger (subgrupo do GRV) → disparo espontâneo rítmico mesmo sem estímulos externos. O ritmo é modulado pelos quimiorreceptores, mecanorreceptores e centros superiores.

MECANORRECEPTORES:
• Receptores de estiramento pulmonar (fibras Aδ): localizados no músculo liso brônquico → reflexo de Hering-Breuer: distensão pulmonar inibe a inspiração (previne hiperinsuflação). Mais relevante em RN e anestesiados.
• Receptores J (juxtacapilares): na parede alveolar → ativados por edema ou embolia → dispneia, apneia ou polipneia.
• Receptores irritantes: traqueia e brônquios → tosse, broncospasmo.

QUIMIORRECEPTORES CENTRAIS:
Localização: superfície ventral da medula oblonga
Estímulo: pH do LCR → quando CO2 plasmático ↑, CO2 atravessa a BHE (lipofílico) e se combina com água no LCR → ácido carbônico → H+ → ↓ pH do LCR → estímulo poderoso de ventilação
Obs: HCO3- e H+ NÃO atravessam a BHE eficientemente → quimiorreceptores centrais são insensíveis a acidose/alcalose metabólica aguda

QUIMIORRECEPTORES PERIFÉRICOS:
Localização: corpúsculos carotídeos (bifurcação da carótida comum) e corpúsculos aórticos
Estímulo principal: PaO2 (hipoxemia → PaO2 < 60 mmHg ativa fortemente)
Também respondem: ↑ PCO2, ↓ pH (mais rápido que os centrais), isquemia local
Via aferente: nervo de Hering (IX par) dos corpos carotídeos e nervo vago dos corpos aórticos
Funcionam rapidamente (segundos) → responsáveis pela resposta ventilatória imediata à hipoxemia

REGULAÇÃO PELA PCO2 (principal estímulo em normais):
Ventilação aumenta ~2 L/min para cada 1 mmHg de aumento da PCO2
PCO2 normal = 40 mmHg; ↑ para 45 mmHg → já duplica a ventilação

REGULAÇÃO PELA PO2:
Ventilação aumenta significativamente apenas quando PaO2 < 60 mmHg
Na hipóxia crônica (DPOC, altitude): os quimiorreceptores centrais se adaptam à hipercapnia (rim compensa com HCO3- → pH do LCR normaliza) → o "drive" ventilatório passa a depender mais da hipoxemia (drive hipóxico). Por isso, oferecer muito O2 para DPOC hipercápnico pode suprimir o drive e piorar a hipercapnia.',
  'DPOC com hipercapnia crônica: PCO2 = 60 mmHg cronicamente. Rim retém HCO3- → pH = 7,38 (compensado). LCR normaliza o pH → quimiorreceptores centrais "se adaptam". O paciente passa a depender do drive hipóxico (PaO2 baixa) para ventilar. Se receber O2 excessivo → PaO2 sobe → quimiorreceptores periféricos param de estimular → hipoventilação → mais hipercapnia. Conclusão: em DPOC hipercápnico, titular O2 para SpO2 88-92%.',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a diferença entre quimiorreceptores centrais e periféricos em termos de localização e estímulo?',
  'CENTRAIS (bulbo): respondem ao pH do LCR (indiretamente ao CO2 — CO2 atravessa BHE e acidifica o LCR). Insensíveis a alterações metabólicas agudas (H+ e HCO3- não atravessam BHE). PERIFÉRICOS (corpos carotídeos/aórticos): respondem à PaO2 (<60 mmHg), PCO2 e pH — mais rápidos. Principais detectores de hipoxemia.',
  'quimiorreceptores', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Por que O2 em excesso pode ser perigoso em paciente com DPOC hipercápnico crônico?',
  'No DPOC hipercápnico crônico, os quimiorreceptores centrais se "adaptam" à PCO2 alta (rim normaliza pH do LCR). O drive ventilatório passa a depender da hipoxemia (drive hipóxico via quimiorreceptores periféricos). O2 excessivo → PaO2 sobe → drive hipóxico suprimido → hipoventilação → PCO2 sobe mais → narcose hipercápnica. Meta: SpO2 88-92%.',
  'DPOC, O2, drive hipóxico', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual o estímulo mais potente para aumentar a ventilação em indivíduo normal?',
  'Em indivíduo NORMAL: o CO2 (PCO2) é o estímulo mais potente. A ventilação aumenta ~2 L/min por mmHg de aumento da PCO2. O O2 só estimula significativamente abaixo de PaO2 = 60 mmHg. Por isso, em normais, a ventilação é finamente ajustada pela PCO2, não pela PaO2.',
  'controle da respiração, CO2', 'facil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Um paciente com acidose metabólica grave (pH = 7,15, HCO3- = 10 mEq/L) apresenta respiração de Kussmaul (profunda e rápida). Qual quimiorreceptor é o principal responsável por essa resposta?',
  'Quimiorreceptores centrais — detectam diretamente a queda do HCO3- no LCR',
  'Quimiorreceptores periféricos (corpos carotídeos) — detectam a queda do pH sanguíneo e H+',
  'Receptores de estiramento pulmonar — ativados pelo esforço muscular da acidose',
  'Receptores J — ativados pela vasodilatação da acidose metabólica',
  'B',
  'Na acidose metabólica, o H+ não atravessa eficientemente a BHE → quimiorreceptores centrais são pouco estimulados agudamente (o LCR tem pH relativamente preservado). Os quimiorreceptores PERIFÉRICOS (corpos carotídeos) respondem rapidamente ao ↑ H+ sanguíneo e ↓ pH → estimulam hiperventilação compensatória (respiração de Kussmaul) → elimina CO2 → ↓ PaCO2 → compensação respiratória da acidose metabólica. Com tempo, a PCO2 baixa alcança o LCR e reduz seu pH também → centrais passam a contribuir.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'O reflexo de Hering-Breuer é ativado por qual estímulo e qual sua função?',
  'Hipóxia severa — interrompe a inspiração para economizar energia',
  'Distensão pulmonar — inibe a inspiração para prevenir hiperinsuflação excessiva',
  'Hipercapnia — acelera a frequência respiratória via vago',
  'Toque na mucosa traqueal — desencadeia tosse protetora',
  'B',
  'O reflexo de Hering-Breuer é mediado por receptores de estiramento no músculo liso brônquico (fibras Aδ mielinizadas). Quando o pulmão se distende suficientemente, sinais via nervo vago inibem o centro inspiratório, terminando a inspiração. Previne hiperinsuflação. É mais relevante em: recém-nascidos (fundamental para o padrão respiratório neonatal) e em adultos anestesiados com ventilação controlada. Em adultos acordados, o volume corrente normal (~500 mL) geralmente não é suficiente para ativar o reflexo.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Paciente encontrado inconsciente após uso de heroína. GCS = 8, FR = 5 irpm, PaO2 = 50, PaCO2 = 70, pH = 7,20. P(A-a) = 8 mmHg. Qual o mecanismo principal de hipoxemia?',
  'Shunt intrapulmonar pela broncoaspiração de vômito',
  'Hipoventilação alveolar pura por depressão do centro respiratório',
  'Distúrbio de difusão por edema pulmonar',
  'Desequilíbrio V/Q por broncoespasmo induzido pelos opioides',
  'B',
  'A P(A-a) de 8 mmHg é NORMAL, indicando que a membrana alvéolo-capilar e a relação V/Q estão preservadas. A hipoxemia se explica pela equação do gás alveolar: PAO2 = 150 − 70/0,8 = 87,5 mmHg; P(A-a) = 87,5 − 50 = 37,5 mmHg... Porém se P(A-a) é dada como 8, o mecanismo é hipoventilação pura. Os opioides deprimem os neurônios do GRD bulbar → FR cai → CO2 acumula → PCO2 sobe → O2 é deslocado no alvéolo pela equação do gás alveolar → PaO2 cai. Tratamento: naloxona (antagonista opioide), suporte ventilatório.',
  'Fisiologia - Guyton', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual característica do CO2 explica por que ele é capaz de atravessar a barreira hematoencefálica e estimular os quimiorreceptores centrais, enquanto os íons H+ e HCO3- não conseguem?',
  'O CO2 tem carga positiva que é atraída pelo gradiente eletroquímico do LCR',
  'O CO2 é uma molécula lipofílica apolar que atravessa livremente as membranas biológicas por difusão simples',
  'O CO2 tem transportador específico na BHE que o internaliza ativamente',
  'O CO2 é convertido a HCO3- no plasma e esta forma atravessa a BHE',
  'B',
  'O CO2 é uma molécula pequena e apolar (lipofílica), que atravessa membranas biológicas por difusão simples — incluindo a barreira hematoencefálica (BHE). Uma vez no LCR, a anidrase carbônica converte CO2 + H2O → H2CO3 → H+ + HCO3-. O H+ gerado no LCR estimula diretamente os quimiorreceptores centrais na superfície ventral do bulbo. Os íons H+ e HCO3- plasmáticos são carregados (hidrofílicos) e não atravessam a BHE facilmente, explicando por que alterações metabólicas ácido-base demoram mais a afetar os quimiorreceptores centrais.',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Qual estrutura do SNC é considerada o gerador do ritmo respiratório básico (marcapasso)?',
  'Grupo pneumotáxico da ponte superior',
  'Complexo pré-Bötzinger (subgrupo do GRV bulbar)',
  'Hipotálamo posterior — controla ritmo em paralelo ao ciclo circadiano',
  'Córtex motor — controle voluntário é o gerador do ritmo automático',
  'B',
  'O complexo pré-Bötzinger, localizado no grupo respiratório ventral (GRV) do bulbo, é o marcapasso do ritmo respiratório. Seus neurônios disparam espontaneamente mesmo quando isolados do resto do SNC, gerando o ritmo automático. O grupo pneumotáxico da ponte modula (limita) a duração da inspiração. O grupo apnêustico da ponte (inibido pelo pneumotáxico) prolonga a inspiração. O córtex motor permite o controle voluntário (prender a respiração, falar, cantar).',
  'Guyton - Fisiologia', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Controle Neural da Respiração e Quimiorreceptores' AND m.nome = 'Fisiologia';

-- ============================================================
-- TÓPICO: DISTÚRBIOS ÁCIDO-BASE RESPIRATÓRIOS
-- ============================================================
INSERT OR IGNORE INTO resumos (topico_id, titulo, resumo_rapido, explicacao_completa, exemplo_clinico, criado_em)
SELECT t.id,
  'Distúrbios Ácido-Base Respiratórios',
  'pH normal: 7,35-7,45. PCO2 normal: 35-45 mmHg. HCO3- normal: 22-26 mEq/L. Acidose respiratória: PCO2 > 45 mmHg, pH < 7,35 (hipoventilação). Alcalose respiratória: PCO2 < 35 mmHg, pH > 7,45 (hiperventilação). Compensação renal na acidose: rins retêm HCO3- (demora dias). Compensação renal na alcalose: rins excretam HCO3-. Regra do pH: cada 10 mmHg de ↑ PCO2 → pH cai 0,08 (agudo) ou 0,03 (crônico, compensado).',
  'EQUAÇÃO DE HENDERSON-HASSELBALCH:
pH = 6,1 + log (HCO3- / 0,03 × PCO2)
Relação simplificada: pH é diretamente proporcional ao HCO3- e inversamente proporcional à PCO2.

ACIDOSE RESPIRATÓRIA (↑ PCO2, ↓ pH):
Causa: HIPOVENTILAÇÃO ALVEOLAR
Etiologias: DPOC grave, overdose de opioides/benzodiazepínicos, síndrome de hipoventilação-obesidade, miastenia gravis, Guillain-Barré, pneumotórax, hemotórax, tórax instável.

COMPENSAÇÃO RENAL (demora 3-5 dias):
Rins ↑ excreção de H+ e ↑ reabsorção de HCO3-
Cada 10 mmHg de ↑ PCO2: HCO3- sobe 1 mEq/L (agudo) ou 3,5 mEq/L (crônico)

EXEMPLO: DPOC exacerbado
• pH 7,25 | PCO2 70 mmHg | HCO3- 30 mEq/L
• Interpretação: acidose respiratória parcialmente compensada (HCO3- alto por compensação renal — doença crônica)

ALCALOSE RESPIRATÓRIA (↓ PCO2, ↑ pH):
Causa: HIPERVENTILAÇÃO ALVEOLAR
Etiologias: ansiedade/pânico, dor aguda, sepse precoce, TEP, intoxicação por salicilatos (fase inicial), gravidez (progesterona estimula centro respiratório), altitude, ventilação mecânica com volume minuto excessivo.

COMPENSAÇÃO RENAL:
Rins ↓ reabsorção de HCO3- (excretam mais)
Cada 10 mmHg de ↓ PCO2: HCO3- cai 2 mEq/L (agudo) ou 5 mEq/L (crônico)

SINAIS E SINTOMAS:
Acidose respiratória: confusão, sonolência, cefaleia, hiperemia (vasodilatação cerebral pelo CO2), narcoselocalização em extremos.
Alcalose respiratória: parestesias peribucais/dedos, cãibras, tetania (hipocalcemia ionizada — alcalose aumenta ligação do Ca2+ às proteínas), síncope, hiperventilação visível.

ABORDAGEM SISTEMÁTICA DA GASOMETRIA (5 passos):
1. pH: < 7,35 = acidose; > 7,45 = alcalose
2. PCO2: >45 = acidótico; <35 = alcalótico. Segue o pH? → distúrbio respiratório
3. HCO3-: >26 = alcalótico; <22 = acidótico. Segue o pH? → distúrbio metabólico
4. Compensação esperada: está dentro do esperado? Se não → distúrbio misto
5. Gradiente P(A-a): para identificar causa de hipoxemia associada',
  'Homem de 65 anos com DPOC agudizado: gasometria pH 7,28 / PCO2 72 / HCO3- 33 / PaO2 48. Interpretação: acidose respiratória (pH baixo, PCO2 alta, HCO3- alto por compensação crônica renal). Compensação esperada: HCO3- = 24 + 3,5 × (72-40)/10 = 24 + 11,2 = 35,2 → com HCO3- observado de 33, a compensação está adequada (distúrbio simples, sem distúrbio metabólico associado). Conduta: suporte ventilatório (VNI/BiPAP), broncodilatadores, O2 titulado (SpO2 88-92%).',
  datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Quais são os valores normais de pH, PaCO2 e HCO3- na gasometria arterial?',
  'pH: 7,35 – 7,45 | PaCO2: 35 – 45 mmHg | HCO3-: 22 – 26 mEq/L | PaO2: 80 – 100 mmHg | SaO2: 95 – 99%. O pH reflete o balanço entre CO2 (componente respiratório) e HCO3- (componente metabólico).',
  'gasometria, valores normais', 'facil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Qual a compensação renal esperada para acidose respiratória aguda vs. crônica?',
  'AGUDA (horas): para cada 10 mmHg de ↑ PCO2 → HCO3- sobe ~1 mEq/L (tampões proteicos intracelulares). CRÔNICA (3-5 dias): para cada 10 mmHg de ↑ PCO2 → HCO3- sobe ~3,5 mEq/L (compensação renal plena). HCO3- muito acima do esperado → alcalose metabólica associada.',
  'acidose respiratória, compensação', 'dificil', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO flashcards (topico_id, frente, verso, tag, dificuldade, criado_em)
SELECT t.id,
  'Por que a alcalose respiratória pode causar parestesias e tetania?',
  'Alcalose (↑ pH) aumenta a ligação do Ca2+ às proteínas plasmáticas → ↓ Ca2+ ionizado livre → hipocalcemia ionizada → hiperexcitabilidade neuromuscular → parestesias peribucais, sinal de Chvostek, cãibras e tetania. A calcemia total não muda, mas a fração ionizada (biologicamente ativa) cai.',
  'alcalose respiratória, cálcio, tetania', 'medio', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Gasometria: pH 7,22 / PCO2 78 mmHg / HCO3- 31 mEq/L / PaO2 52 mmHg. Qual o distúrbio ácido-base e como classificá-lo?',
  'Alcalose metabólica com compensação respiratória inadequada',
  'Acidose mista (respiratória + metabólica)',
  'Acidose respiratória com compensação renal parcial (distúrbio crônico)',
  'Acidose metabólica com tentativa de compensação respiratória',
  'C',
  'pH baixo (7,22) + PCO2 alta (78) = acidose respiratória. HCO3- elevado (31) indica compensação renal. Compensação esperada (crônica): HCO3- = 24 + 3,5 × (78-40)/10 = 24 + 13,3 = 37,3 mEq/L. HCO3- observado (31) está ABAIXO do esperado para compensação crônica plena → indica que a compensação renal está incompleta (distúrbio subagudo ou acidose metabólica associada). Se o HCO3- estivesse em ~37, seria acidose respiratória crônica compensada. Este caso sugere DPOC em exacerbação aguda sobre crônica.',
  'Interpretação de gasometria - MCC', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Jovem de 22 anos com crise de ansiedade apresenta: parestesias peribucais, cãibras nas mãos, FR = 28 irpm. Gasometria: pH 7,52 / PCO2 28 / HCO3- 22. Diagnóstico e mecanismo:',
  'Alcalose metabólica por vômitos — perda de HCl',
  'Acidose respiratória com compensação metabólica — hiperventilação compensatória',
  'Alcalose respiratória por hiperventilação — PCO2 baixa eleva pH e reduz Ca2+ ionizado',
  'Distúrbio misto: alcalose metabólica + alcalose respiratória',
  'C',
  'pH alto (7,52) + PCO2 baixa (28) = alcalose respiratória por hiperventilação (ansiedade → FR alta → elimina CO2 → PCO2 cai → pH sobe). HCO3- normal (22) confirma: sem componente metabólico. Os sintomas (parestesias, cãibras) são causados pela queda do Ca2+ ionizado: alcalose → Ca2+ se liga mais às proteínas → menos Ca2+ livre → hiperexcitabilidade neuromuscular. Tratamento: respirar em saco de papel (reinalar CO2), ansiolítico se necessário.',
  'Fisiologia - Guyton; Clínica médica', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Sobre a intoxicação por salicilatos (aspirina), é CORRETO afirmar:',
  'Causa apenas acidose metabólica por geração de ácido salicílico',
  'Causa apenas alcalose respiratória por estímulo direto do centro respiratório',
  'Causa distúrbio misto: alcalose respiratória (estímulo direto do centro respiratório) + acidose metabólica (geração de ácido orgânico)',
  'Causa apenas acidose respiratória por depressão do centro respiratório em altas doses',
  'C',
  'A intoxicação por salicilatos causa clássico DISTÚRBIO MISTO: 1) Alcalose respiratória: o ácido salicílico estimula diretamente o centro respiratório → hiperventilação → ↓ PCO2 → alcalose respiratória (fase precoce, predominante em adultos). 2) Acidose metabólica: o salicilato é metabolizado em ácido, desacopla a fosforilação oxidativa (↑ lactato) e inibe o ciclo de Krebs → acúmulo de ácidos orgânicos → ↑ ânion gap (fase tardia). Em crianças, a acidose metabólica pode predominar. O distúrbio misto (alcalose respiratória + acidose metabólica) é característico.',
  'Toxicologia - Harrison', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Gestante de 28 semanas apresenta gasometria: pH 7,44 / PCO2 31 / HCO3- 20. Este resultado é:',
  'Distúrbio patológico: alcalose respiratória por doença pulmonar gestacional',
  'Fisiológico para a gestação — progesterona estimula o centro respiratório gerando alcalose respiratória compensada metabolicamente',
  'Acidose metabólica com compensação respiratória pela anemia gestacional',
  'Padrão anormal sugestivo de TEP na gestação',
  'B',
  'Na gravidez, a progesterona estimula diretamente o centro respiratório (grupo respiratório dorsal), aumentando a ventilação minuto em ~40-50%. Isso gera alcalose respiratória crônica fisiológica (PCO2 cai para ~30 mmHg). Os rins compensam excretando HCO3- → HCO3- cai para ~20 mEq/L. Resultado: pH levemente alto (7,42-7,46), PCO2 ~28-32, HCO3- ~18-22 — padrão normal da gravidez. A PCO2 baixa materna favorece a transferência de CO2 do feto para a mãe (gradiente favorável).',
  'Fisiologia da Gravidez - Williams', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';

INSERT OR IGNORE INTO questoes (topico_id, enunciado, alternativa_a, alternativa_b, alternativa_c, alternativa_d, gabarito, explicacao, fonte, criado_em)
SELECT t.id,
  'Ao iniciar ventilação mecânica em paciente com DPOC e hipercapnia crônica (PCO2 basal = 65 mmHg, HCO3- = 38 mEq/L), o residente ajusta o ventilador para normalizar rapidamente a PCO2 para 40 mmHg. Qual o risco?',
  'Nenhum — normalizar a PCO2 é o objetivo terapêutico em qualquer situação de hipercapnia',
  'Alcalose metabólica grave: o HCO3- retido cronicamente pelo rim não é eliminado rapidamente → pH sobe perigosamente (alcalose de posthipercapnia)',
  'Hipoxemia grave: a queda da PCO2 aumenta a captação de O2 pelo pulmão, reduzindo a PaO2',
  'Acidose metabólica por desnaturação das proteínas de tampão em pH muito baixo',
  'B',
  'O paciente com hipercapnia crônica retém HCO3- como compensação renal (HCO3- = 38). Se a PCO2 for corrigida rapidamente para 40 mmHg via VM, o sistema respiratório normaliza, mas o HCO3- elevado (compensação metabólica) persiste — o rim demora dias para excretar o excesso. Resultado: pH = 6,1 + log(38/0,03×40) = 6,1 + log(31,7) = 6,1 + 1,5 = 7,60 → alcalose grave. A meta é reduzir a PCO2 GRADUALMENTE até o valor basal do paciente (PCO2 permissiva), não forçar a normalização.',
  'UTI - Ventilação Mecânica', datetime('now')
FROM topicos t JOIN materias m ON t.materia_id = m.id
WHERE t.titulo = 'Distúrbios Ácido-Base Respiratórios' AND m.nome = 'Fisiologia';
