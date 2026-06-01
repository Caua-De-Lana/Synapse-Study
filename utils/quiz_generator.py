from database.database import current_user_id, fetch_all, insert_returning_id


def _texto(topico, campo, padrao=""):
    return (topico.get(campo) or padrao or "").strip()


def montar_perguntas_quiz(topico):
    titulo = _texto(topico, "titulo", "este tópico")
    formula = _texto(topico, "formula", "conceito principal")
    resumo = _texto(topico, "resumo_rapido", _texto(topico, "explicacao", f"Conceito essencial de {titulo}."))
    exemplo = _texto(topico, "exemplo", "Aplicar o conceito em um caso simples.")

    return [
        {
            "pergunta": f"Qual é o objetivo principal de estudar {titulo}?",
            "alternativa_a": "Entender melhor o comportamento do conteúdo na prática",
            "alternativa_b": "Decorar palavras sem aplicar",
            "alternativa_c": "Ignorar exemplos resolvidos",
            "alternativa_d": "Evitar exercícios",
            "resposta_correta": "A",
            "explicacao": f"{titulo} deve ajudar você a compreender e aplicar o conteúdo, não apenas decorar.",
        },
        {
            "pergunta": f"Qual relação ou ideia está mais ligada a {titulo}?",
            "alternativa_a": formula,
            "alternativa_b": "F = m x a",
            "alternativa_c": "A = b x h",
            "alternativa_d": "v = d / t",
            "resposta_correta": "A",
            "explicacao": f"A relação central deste tópico é: {formula}.",
        },
        {
            "pergunta": f"Qual resumo combina melhor com {titulo}?",
            "alternativa_a": resumo[:180],
            "alternativa_b": "O tópico não tem aplicação em exercícios",
            "alternativa_c": "O conceito só serve para memorização",
            "alternativa_d": "A ordem de estudo não importa",
            "resposta_correta": "A",
            "explicacao": resumo,
        },
        {
            "pergunta": f"Como praticar {titulo} com mais eficiência?",
            "alternativa_a": "Ler o resumo, resolver um exemplo e conferir a explicação",
            "alternativa_b": "Pular direto para outro assunto",
            "alternativa_c": "Responder sem revisar o enunciado",
            "alternativa_d": "Estudar apenas quando errar uma prova",
            "resposta_correta": "A",
            "explicacao": exemplo,
        },
    ]


def garantir_quiz_topico(topico):
    existentes = fetch_all(
        "SELECT id FROM quiz WHERE user_id = ? AND topico_id = ?",
        (current_user_id(), topico["id"]),
    )
    if existentes:
        return len(existentes)

    for pergunta in montar_perguntas_quiz(topico):
        insert_returning_id(
            """
            INSERT INTO quiz (
                user_id, topico_id, pergunta, alternativa_a, alternativa_b,
                alternativa_c, alternativa_d, resposta_correta, explicacao
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                current_user_id(),
                topico["id"],
                pergunta["pergunta"],
                pergunta["alternativa_a"],
                pergunta["alternativa_b"],
                pergunta["alternativa_c"],
                pergunta["alternativa_d"],
                pergunta["resposta_correta"],
                pergunta["explicacao"],
            ),
        )
    return 4


def garantir_quiz_materia(topicos):
    total = 0
    for topico in topicos:
        total += garantir_quiz_topico(topico)
    return total
