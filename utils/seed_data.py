from database.database import (
    STATUS_PENDENTE,
    current_user_id,
    execute,
    fetch_all,
    fetch_one,
    init_db,
    insert_returning_id,
    listar_flashcards,
    listar_perguntas,
    salvar_flashcard,
    salvar_pergunta,
)


MATERIA_ELETRONICA = "Eletronica Analogica"

BASE_TOPICOS = [
    ("Lei de Ohm", "V = R x I", "Relaciona tensao, corrente e resistencia."),
    ("Tensao, corrente e resistencia", "I = V / R", "Explica as tres grandezas basicas de qualquer circuito."),
    ("Associacao em serie", "Req = R1 + R2 + ...", "Componentes no mesmo caminho tem a mesma corrente."),
    ("Associacao em paralelo", "1 / Req = 1 / R1 + 1 / R2 + ...", "Componentes em caminhos diferentes recebem a mesma tensao."),
    ("Divisor de tensao", "Vout = Vin x R2 / (R1 + R2)", "Usa resistores para obter uma tensao menor."),
    ("Leis de Kirchhoff", "Nos: soma das correntes = 0 | Malhas: soma das tensoes = 0", "Organiza correntes e tensoes em circuitos."),
    ("Potencia eletrica", "P = V x I", "Mostra quanta energia eletrica e usada por segundo."),
    ("Capacitores", "C = Q / V | tau = R x C", "Armazenam energia e suavizam variacoes de tensao."),
    ("Diodos", "Direta: Vanodo > Vcatodo", "Conduzem principalmente em um sentido."),
    ("Transistores BJT", "Ic = beta x Ib", "Uma pequena corrente controla uma corrente maior."),
    ("Amplificadores operacionais", "Av inversor = -Rf / Rin", "Amplificam, comparam e condicionam sinais."),
]


def _conteudo(titulo, formula, explicacao):
    return {
        "titulo": titulo,
        "formula": formula,
        "explicacao": explicacao,
        "resumo_rapido": explicacao[:120],
        "analogia": f"Pense em {titulo} como uma ferramenta para entender melhor o caminho da energia no circuito.",
        "exemplo": f"Exemplo: identifique os valores do enunciado, aplique {formula} e confira a unidade final.",
        "exercicio": f"Explique com suas palavras quando voce usaria {titulo} em uma placa simples.",
        "dica_prova": "Antes de calcular, escreva a formula, destaque as unidades e so depois substitua os valores.",
        "aplicacao_pratica": "Aparece em Arduino, ESP32, sensores, fontes, filtros e circuitos de interface.",
        "explicacao_extra": f"Em termos simples: {titulo} ajuda a prever o que acontece no circuito sem precisar adivinhar.",
        "outro_exemplo": "Use numeros pequenos primeiro. Depois repita o mesmo raciocinio com os valores reais.",
    }


TOPICOS = [_conteudo(*item) for item in BASE_TOPICOS]


def criar_perguntas_quiz(topico_id, titulo, formula):
    return [
        (
            topico_id,
            f"Qual e a ideia central de {titulo}?",
            "Entender ou calcular o comportamento de um circuito",
            "Remover todos os componentes do circuito",
            "Ignorar tensao e corrente",
            "Usar apenas programacao",
            "A",
            f"{titulo} e usado para analisar circuitos eletricos de forma organizada.",
        ),
        (
            topico_id,
            f"Qual relacao combina melhor com {titulo}?",
            formula,
            "F = m x a",
            "v = d / t",
            "A = b x h",
            "A",
            f"A formula principal deste topico e {formula}.",
        ),
        (
            topico_id,
            f"Onde {titulo} pode aparecer na pratica?",
            "Em placas, sensores, fontes e microcontroladores",
            "Apenas em desenho artistico",
            "Somente em banco de dados",
            "Nunca aparece em engenharia",
            "A",
            "Eletronica analogica aparece em hardware real, sensores, fontes e interfaces.",
        ),
    ]


def criar_perguntas_estudo(titulo, formula):
    return [
        (
            "multipla_escolha",
            f"Qual e a ideia principal de {titulo}?",
            "Compreender melhor o comportamento do circuito",
            "Revise o resumo rapido e identifique onde o conceito aparece no circuito.",
            {
                "A": "Compreender melhor o comportamento do circuito",
                "B": "Ignorar as grandezas eletricas",
                "C": "Trocar todos os componentes por fios",
                "D": "Usar apenas tentativa e erro",
            },
        ),
        (
            "multipla_escolha",
            f"Qual formula ou relacao ajuda em {titulo}?",
            formula or "Conceito fundamental do topico",
            "Use a formula como ponto de partida e confira as unidades antes de calcular.",
            {
                "A": formula or "Conceito fundamental do topico",
                "B": "F = m x a",
                "C": "A = b x h",
                "D": "v = d / t",
            },
        ),
        (
            "verdadeiro_falso",
            f"{titulo} pode aparecer em exercicios e projetos praticos de eletronica.",
            "Verdadeiro",
            "O objetivo e conectar o conceito com circuitos reais, placas, sensores ou fontes.",
            None,
        ),
        (
            "resposta_curta",
            f"Explique {titulo} com suas palavras em uma frase.",
            "Resposta pessoal conectada ao comportamento do circuito.",
            "Uma boa resposta cita o conceito principal e como ele afeta tensao, corrente ou componentes.",
            None,
        ),
        (
            "resposta_curta",
            f"Cite uma aplicacao pratica de {titulo}.",
            "Aplicacao em circuitos, projetos, sensores, fontes ou exercicios.",
            "Procure lembrar de uma situacao concreta em que o topico ajuda a analisar ou montar circuitos.",
            None,
        ),
    ]


def garantir_flashcards_topico(topico_id, titulo, explicacao, formula, dica_prova):
    if listar_flashcards(topico_id):
        return
    salvar_flashcard(topico_id, f"O que e {titulo}?", explicacao or f"Conceito principal de {titulo}.", pontuar=False)
    salvar_flashcard(topico_id, f"Qual formula/ideia lembra {titulo}?", formula or dica_prova or "Revise o resumo do topico.", pontuar=False)


def garantir_perguntas_topico(topico_id, titulo, formula):
    existentes = listar_perguntas(topico_id)
    if len(existentes) >= 5:
        return

    enunciados_existentes = {pergunta["enunciado"] for pergunta in existentes}
    for tipo, enunciado, resposta, explicacao, alternativas in criar_perguntas_estudo(titulo, formula):
        if len(listar_perguntas(topico_id)) >= 5:
            break
        if enunciado in enunciados_existentes:
            continue
        salvar_pergunta(topico_id, tipo, enunciado, resposta, explicacao, alternativas)
        enunciados_existentes.add(enunciado)


def _obter_materia_eletronica(user_id):
    materia = fetch_one(
        """
        SELECT *
        FROM materias
        WHERE user_id = ? AND lower(nome) IN (lower(?), lower(?))
        ORDER BY id
        LIMIT 1
        """,
        (user_id, MATERIA_ELETRONICA, "Eletrônica Analógica"),
    )
    descricao = "Fundamentos praticos de eletronica analogica para Engenharia da Computacao."
    if materia:
        execute(
            "UPDATE materias SET nome = ?, descricao = ? WHERE id = ? AND user_id = ?",
            (MATERIA_ELETRONICA, descricao, materia["id"], user_id),
        )
        return materia["id"]
    return insert_returning_id(
        "INSERT INTO materias (user_id, nome, descricao) VALUES (?, ?, ?)",
        (user_id, MATERIA_ELETRONICA, descricao),
    )


def seed_dados_iniciais():
    init_db()
    user_id = current_user_id()
    materia_id = _obter_materia_eletronica(user_id)

    for ordem, topico in enumerate(TOPICOS, start=1):
        existente = fetch_one(
            "SELECT * FROM topicos WHERE user_id = ? AND materia_id = ? AND lower(titulo) = lower(?)",
            (user_id, materia_id, topico["titulo"]),
        )
        if existente:
            topico_id = existente["id"]
            execute(
                """
                UPDATE topicos
                SET ordem = ?, resumo_rapido = ?, formula = ?, explicacao = ?, analogia = ?, exemplo = ?,
                    exercicio = ?, dica_prova = ?, aplicacao_pratica = ?,
                    explicacao_extra = ?, outro_exemplo = ?
                WHERE id = ? AND user_id = ?
                """,
                (
                    ordem,
                    topico["resumo_rapido"],
                    topico["formula"],
                    topico["explicacao"],
                    topico["analogia"],
                    topico["exemplo"],
                    topico["exercicio"],
                    topico["dica_prova"],
                    topico["aplicacao_pratica"],
                    topico["explicacao_extra"],
                    topico["outro_exemplo"],
                    topico_id,
                    user_id,
                ),
            )
        else:
            topico_id = insert_returning_id(
                """
                INSERT INTO topicos (
                    user_id, materia_id, ordem, titulo, resumo_rapido, formula, explicacao, analogia,
                    exemplo, exercicio, dica_prova, aplicacao_pratica,
                    explicacao_extra, outro_exemplo, status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    user_id,
                    materia_id,
                    ordem,
                    topico["titulo"],
                    topico["resumo_rapido"],
                    topico["formula"],
                    topico["explicacao"],
                    topico["analogia"],
                    topico["exemplo"],
                    topico["exercicio"],
                    topico["dica_prova"],
                    topico["aplicacao_pratica"],
                    topico["explicacao_extra"],
                    topico["outro_exemplo"],
                    STATUS_PENDENTE,
                ),
            )

        if not fetch_all("SELECT id FROM quiz WHERE user_id = ? AND topico_id = ?", (user_id, topico_id)):
            for pergunta in criar_perguntas_quiz(topico_id, topico["titulo"], topico["formula"]):
                insert_returning_id(
                    """
                    INSERT INTO quiz (
                        user_id, topico_id, pergunta, alternativa_a, alternativa_b,
                        alternativa_c, alternativa_d, resposta_correta, explicacao
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (user_id, *pergunta),
                )

        garantir_flashcards_topico(
            topico_id,
            topico["titulo"],
            topico["explicacao"],
            topico["formula"],
            topico["dica_prova"],
        )
        garantir_perguntas_topico(topico_id, topico["titulo"], topico["formula"])

    todos_topicos = fetch_all(
        """
        SELECT id, titulo, COALESCE(explicacao, '') AS explicacao, COALESCE(formula, '') AS formula,
               COALESCE(dica_prova, '') AS dica_prova
        FROM topicos
        WHERE user_id = ?
        """,
        (user_id,),
    )
    for topico in todos_topicos:
        garantir_flashcards_topico(
            topico["id"],
            topico["titulo"],
            topico["explicacao"],
            topico["formula"],
            topico["dica_prova"],
        )
        garantir_perguntas_topico(topico["id"], topico["titulo"], topico["formula"])
