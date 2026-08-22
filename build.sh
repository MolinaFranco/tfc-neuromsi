#!/bin/bash
# Compila la tesis completa. Requiere pdflatex con -shell-escape (minted),
# bibtex, y makeglossaries con xindy.
#
# makeglossaries se corre DOS veces a proposito: en la primera pasada el
# documento todavia no tiene glosario ni indice de figuras, asi que los numeros
# de pagina que quedan registrados en el .glo son los de un documento mas corto.
# Recien despues de que la paginacion converge conviene regenerar el glosario.
set -e
cd "$(dirname "$0")"
latex() { pdflatex -shell-escape -interaction=nonstopmode main.tex > /dev/null; }

latex
bibtex main > /dev/null
makeglossaries main > /dev/null
latex
latex
makeglossaries main > /dev/null
latex
latex

echo "main.pdf generado ($(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}') paginas)"
grep -c 'Rerun to get' main.log > /dev/null && echo "AVISO: quedan referencias sin converger" || true
