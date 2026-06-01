from io import BytesIO

from pypdf import PdfReader


def extrair_texto_pdf(uploaded_file):
    reader = PdfReader(BytesIO(uploaded_file.getvalue()))
    partes = []
    for page in reader.pages:
        partes.append(page.extract_text() or "")
    return "\n".join(partes).strip()
