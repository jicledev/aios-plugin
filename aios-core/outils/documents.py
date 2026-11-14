# /// script
# requires-python = ">=3.11"
# dependencies = ["pypdf", "python-docx"]
# ///
"""Outil documents de l'AIOS : Drive, boîte a-lire, rangement des originaux.

Lancer avec : uv run --script documents.py <commande> ...
Codes de sortie : 0 succès ; 2 réglage « documents: aucun » ; 3 réglage absent ;
4 Drive introuvable ; 5 fichier introuvable ou format non pris en charge.
"""
import argparse
import datetime
import os
import shutil
import string
import sys
from pathlib import Path

AUCUN, ABSENT, SANS_DRIVE, FICHIER = 2, 3, 4, 5
IGNORES = {"desktop.ini", "thumbs.db"}


class Arret(Exception):
    def __init__(self, code, message):
        super().__init__(message)
        self.code = code


def racine_drive() -> Path:
    """Première racine « Mon Drive » / « My Drive » trouvée (ou AIOS_RACINES_DRIVE, pour les tests).

    Ordre : mode « miroir » (dossier dans le profil), puis mode « streaming » (lecteurs A: à Z:).
    """
    forcees = os.environ.get("AIOS_RACINES_DRIVE")
    noms = ("Mon Drive", "My Drive")
    if forcees:
        candidats = [Path(p) for p in forcees.split(os.pathsep) if p]
    else:
        profil = os.environ.get("USERPROFILE") or str(Path.home())
        candidats = [Path(profil) / n for n in noms]
        candidats += [Path(f"{l}:\\") / n for l in string.ascii_uppercase for n in noms]
    for c in candidats:
        if c.is_dir():
            return c
    raise Arret(SANS_DRIVE, "Google Drive introuvable sur cet ordinateur (lecteur « Mon Drive »).")


def reglage(vault: Path) -> str:
    """Valeur de la ligne « documents: » de .aios-vault."""
    marqueur = Path(vault) / ".aios-vault"
    if not marqueur.is_file():
        raise Arret(ABSENT, f"{vault} n'est pas un vault AIOS (pas de .aios-vault).")
    for ligne in marqueur.read_text(encoding="utf-8").splitlines():
        if ligne.startswith("documents:"):
            return ligne.split(":", 1)[1].strip()
    raise Arret(ABSENT, "Les documents ne sont pas encore réglés : dis « active les documents ».")


def dossier_aios(vault: Path) -> Path:
    """Dossier AIOS dans Drive, créé avec a-lire/ et documents/ si besoin."""
    valeur = reglage(vault)
    if valeur == "aucun":
        raise Arret(AUCUN, "Pas de Google Drive réglé pour les documents (documents: aucun).")
    if not valeur.startswith("drive:") or not valeur[6:]:
        raise Arret(ABSENT, f"Réglage documents illisible : « {valeur} ». Dis « active les documents ».")
    d = racine_drive() / valeur[6:]
    for sous in ("a-lire", "documents"):
        (d / sous).mkdir(parents=True, exist_ok=True)
    return d


def fichiers_a_lire(vault: Path) -> list[str]:
    base = dossier_aios(vault) / "a-lire"
    trouves = []
    for f in base.rglob("*"):
        rel = f.relative_to(base)
        if not f.is_file() or any(p.startswith(".") for p in rel.parts):
            continue
        if f.name.lower() in IGNORES or f.suffix.lower() == ".tmp" or f.name.startswith("~$"):
            continue
        trouves.append((f.stat().st_mtime, rel.as_posix()))
    return [r for _, r in sorted(trouves)]


def destination_libre(dossier: Path, nom: str) -> Path:
    cible = dossier / nom
    stem, ext = Path(nom).stem, Path(nom).suffix
    n = 2
    while cible.exists():
        cible = dossier / f"{stem}-{n}{ext}"
        n += 1
    return cible


def ranger(vault: Path, fichier: Path) -> tuple[str, str]:
    """Déplace (depuis a-lire) ou copie (ailleurs) l'original dans documents/<année>/."""
    fichier = Path(fichier)
    if not fichier.is_file():
        raise Arret(FICHIER, f"Fichier introuvable : {fichier}")
    aios = dossier_aios(vault)
    dossier = aios / "documents" / str(datetime.date.today().year)
    dossier.mkdir(parents=True, exist_ok=True)
    cible = destination_libre(dossier, fichier.name)
    if fichier.resolve().is_relative_to((aios / "a-lire").resolve()):
        shutil.move(str(fichier), str(cible))
    else:
        shutil.copy2(fichier, cible)
    return cible.relative_to(aios).as_posix(), cible.resolve().as_uri()


FORMATS = {".pdf": "pdf", ".docx": "word", ".png": "image", ".jpg": "image",
           ".jpeg": "image", ".gif": "image", ".webp": "image"}


def verifier(fichier: Path) -> Path:
    fichier = Path(fichier)
    if not fichier.is_file():
        raise Arret(FICHIER, f"Fichier introuvable : {fichier}")
    return fichier


def format_de(fichier: Path) -> str:
    return FORMATS.get(Path(fichier).suffix.lower(), "autre")


def empreinte(fichier: Path) -> str:
    import hashlib
    h = hashlib.sha256()
    with open(verifier(fichier), "rb") as f:
        for bloc in iter(lambda: f.read(1 << 20), b""):
            h.update(bloc)
    return h.hexdigest()


def infos(fichier: Path) -> list[str]:
    fmt = format_de(verifier(fichier))
    lignes = [f"format: {fmt}"]
    if fmt == "pdf":
        from pypdf import PdfReader
        pages = PdfReader(fichier).pages
        texte = any((p.extract_text() or "").strip() for p in pages)
        lignes += [f"pages: {len(pages)}", f"texte: {'oui' if texte else 'non'}"]
    return lignes


def extraire(fichier: Path, pages: str | None = None) -> str:
    fmt = format_de(verifier(fichier))
    if fmt == "pdf":
        from pypdf import PdfReader
        toutes = PdfReader(fichier).pages
        debut, fin = plage(pages, len(toutes)) if pages else (1, len(toutes))
        morceaux = []
        for n in range(debut, fin + 1):
            morceaux.append(f"--- page {n} ---\n{(toutes[n - 1].extract_text() or '').strip()}")
        return "\n".join(morceaux)
    if fmt == "word":
        import docx
        d = docx.Document(fichier)
        morceaux = [p.text for p in d.paragraphs if p.text.strip()]
        for t in d.tables:
            for ligne in t.rows:
                morceaux.append(" | ".join(c.text.strip() for c in ligne.cells))
        return "\n".join(morceaux)
    if fmt == "image":
        raise Arret(FICHIER, "Image : lecture visuelle nécessaire.")
    raise Arret(FICHIER, f"Format non pris en charge : {Path(fichier).suffix or 'sans extension'}.")


def plage(pages: str, total: int) -> tuple[int, int]:
    a, _, b = pages.partition("-")
    return max(int(a), 1), min(int(b or a), total)


def decouper(fichier: Path, pages: str) -> Path:
    """Copie les pages A-B d'un PDF dans un PDF temporaire (l'original n'est pas touché).

    Sert à lire un gros PDF par morceaux avec la lecture native de Claude Code.
    """
    import tempfile
    from pypdf import PdfReader, PdfWriter
    if format_de(verifier(fichier)) != "pdf":
        raise Arret(FICHIER, "Seul un PDF peut être découpé.")
    source = PdfReader(fichier)
    debut, fin = plage(pages, len(source.pages))
    w = PdfWriter()
    for n in range(debut, fin + 1):
        w.add_page(source.pages[n - 1])
    dossier = Path(tempfile.gettempdir()) / "aios-decoupe"
    dossier.mkdir(exist_ok=True)
    sortie = dossier / f"{Path(fichier).stem}-p{debut}-{fin}.pdf"
    with open(sortie, "wb") as s:
        w.write(s)
    return sortie


def doublons(vault: Path, cle: str) -> list[str]:
    vault = Path(vault)
    trouves = []
    for f in sorted(vault.rglob("*.md")):
        rel = f.relative_to(vault)
        if rel.parts[0] in (".git", "90-archives"):
            continue
        lignes = f.read_text(encoding="utf-8", errors="replace").splitlines()
        if not lignes or lignes[0].strip() != "---":
            continue
        for ligne in lignes[1:]:
            if ligne.strip() == "---":
                break
            if ligne.strip() == f"empreinte: {cle}":
                trouves.append(rel.as_posix())
                break
    return trouves


def main(argv=None) -> int:
    # Sortie toujours en UTF-8 (la console Windows est souvent en cp1252) : accents des noms de fichiers.
    for flux in (sys.stdout, sys.stderr):
        flux.reconfigure(encoding="utf-8")
    p = argparse.ArgumentParser(prog="documents.py", description="Outil documents de l'AIOS")
    s = p.add_subparsers(dest="commande", required=True)
    s.add_parser("racine-drive")
    for nom in ("dossier", "a-lire"):
        s.add_parser(nom).add_argument("vault", type=Path)
    r = s.add_parser("ranger")
    r.add_argument("vault", type=Path)
    r.add_argument("fichier", type=Path)
    for nom in ("empreinte", "infos"):
        s.add_parser(nom).add_argument("fichier", type=Path)
    x = s.add_parser("extraire")
    x.add_argument("fichier", type=Path)
    x.add_argument("--pages", help="plage de pages A-B (PDF)")
    c = s.add_parser("decouper")
    c.add_argument("fichier", type=Path)
    c.add_argument("pages", help="plage de pages A-B")
    d = s.add_parser("doublon")
    d.add_argument("vault", type=Path)
    d.add_argument("empreinte")
    a = p.parse_args(argv)
    try:
        if a.commande == "racine-drive":
            print(racine_drive())
        elif a.commande == "dossier":
            print(dossier_aios(a.vault))
        elif a.commande == "a-lire":
            for rel in fichiers_a_lire(a.vault):
                print(rel)
        elif a.commande == "ranger":
            print("\n".join(ranger(a.vault, a.fichier)))
        elif a.commande == "empreinte":
            print(empreinte(a.fichier))
        elif a.commande == "infos":
            print("\n".join(infos(a.fichier)))
        elif a.commande == "extraire":
            print(extraire(a.fichier, a.pages))
        elif a.commande == "decouper":
            print(decouper(a.fichier, a.pages))
        elif a.commande == "doublon":
            for rel in doublons(a.vault, a.empreinte):
                print(rel)
    except Arret as e:
        print(f"AIOS : {e}", file=sys.stderr)
        return e.code
    except Exception as e:  # PDF protégé ou abîmé, fichier verrouillé, plage invalide…
        print(f"AIOS : impossible de traiter ce fichier (protégé ou abîmé, ou en cours d'utilisation) : "
              f"{type(e).__name__}: {e}", file=sys.stderr)
        return FICHIER
    return 0


if __name__ == "__main__":
    sys.exit(main())
