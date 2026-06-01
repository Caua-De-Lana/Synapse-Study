from pathlib import Path


UPLOAD_DIR = Path("uploads")


def salvar_upload(uploaded_file):
    UPLOAD_DIR.mkdir(exist_ok=True)
    destino = UPLOAD_DIR / uploaded_file.name
    destino.write_bytes(uploaded_file.getvalue())
    return str(destino)
