from database.database import obter_ou_criar_materia, obter_ou_criar_topico


DEFAULT_CONTENT = {
    "formula": "",
    "explicacao": "Comece pela definição, depois veja um exemplo e pratique com um exercício curto.",
    "analogia": "Pense neste tópico como uma peça de um mapa: ele ajuda você a chegar no objetivo maior.",
    "exemplo": "Pegue um caso simples, identifique os dados principais e resolva passo a passo.",
    "exercicio": "Escreva um resumo de 3 linhas e resolva uma questão básica sobre o tema.",
    "dica_prova": "Memorize a ideia central e pratique pelo menos um exemplo resolvido.",
    "aplicacao_pratica": "Use o tópico em exercícios, projetos ou situações parecidas com sua prova.",
    "explicacao_extra": "Volte ao básico: o que é, para que serve e onde aparece.",
    "outro_exemplo": "Crie um exemplo com números ou situações pequenas para reduzir a dificuldade.",
}


RULES = [
    {
        "materia": "Eletrônica Analógica",
        "keywords": ["eletrônica", "eletronica", "circuito", "diodo", "transistor", "ohm", "kirchhoff"],
        "topicos": [
            ("Lei de Ohm", ["lei de ohm", "ohm"], "V = R x I"),
            ("Leis de Kirchhoff", ["kirchhoff"], "Nós: soma das correntes = 0 | Malhas: soma das tensões = 0"),
            ("Diodos", ["diodo", "diodos"], "Direta: Vanodo > Vcatodo"),
            ("Transistores BJT", ["transistor", "transistores", "bjt"], "Ic = beta x Ib"),
        ],
    },
    {
        "materia": "SQL",
        "keywords": ["sql", "join", "group by", "window"],
        "topicos": [
            ("JOIN", ["join", "joins"], ""),
            ("GROUP BY", ["group by", "agrupamento"], ""),
            ("Window Functions", ["window", "window functions", "over"], ""),
        ],
    },
    {
        "materia": "Python",
        "keywords": ["python", "pandas", "api", "apis"],
        "topicos": [
            ("Python básico", ["python"], ""),
            ("Pandas", ["pandas"], ""),
            ("APIs", ["api", "apis"], ""),
        ],
    },
]


AREA_DEFAULTS = {
    "Programação": ("Programação", ["Lógica de programação", "Python básico", "APIs"]),
    "Dados / Business Intelligence": ("Dados e BI", ["SQL", "Dashboards", "Indicadores"]),
    "Matemática": ("Matemática", ["Funções", "Álgebra", "Porcentagem"]),
    "Física": ("Física", ["Cinemática", "Dinâmica", "Eletricidade"]),
    "Inglês": ("Inglês", ["Leitura", "Vocabulário", "Listening"]),
    "Eletrônica": ("Eletrônica Analógica", ["Lei de Ohm", "Leis de Kirchhoff", "Diodos"]),
    "Engenharia": ("Fundamentos de Engenharia", ["Modelagem de problemas", "Unidades", "Análise de sistemas"]),
}


def gerar_plano_estudos(areas, objetivo):
    objetivo_lower = (objetivo or "").lower()
    plano = {}

    for rule in RULES:
        if any(keyword in objetivo_lower for keyword in rule["keywords"]):
            plano.setdefault(rule["materia"], [])
            for titulo, keywords, formula in rule["topicos"]:
                if any(keyword in objetivo_lower for keyword in keywords):
                    plano[rule["materia"]].append((titulo, formula))

    for area in areas:
        if area in AREA_DEFAULTS and area not in ["Outro"]:
            materia, topicos = AREA_DEFAULTS[area]
            plano.setdefault(materia, [])
            if not plano[materia]:
                plano[materia].extend((topico, "") for topico in topicos)

    if not plano:
        plano["Plano inicial"] = [
            ("Organizar materiais", ""),
            ("Revisar conceitos principais", ""),
            ("Resolver exercícios", ""),
        ]

    criado = []
    for materia_nome, topicos in plano.items():
        materia_id = obter_ou_criar_materia(materia_nome, "Criada automaticamente pelo onboarding.")
        vistos = set()
        for ordem, (titulo, formula) in enumerate(topicos, start=1):
            if titulo.lower() in vistos:
                continue
            vistos.add(titulo.lower())
            conteudo = dict(DEFAULT_CONTENT)
            conteudo["formula"] = formula
            conteudo["explicacao"] = f"Estude {titulo} dentro da matéria {materia_nome}. Foque no conceito, aplicação e exercícios."
            obter_ou_criar_topico(materia_id, titulo, ordem, conteudo)
        criado.append({"materia": materia_nome, "topicos": [titulo for titulo, _ in topicos]})

    return criado
