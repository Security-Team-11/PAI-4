#!/bin/bash
# Script para generar PDF de documentación - PAI-4 DevSecOps

echo "Generando documentación PDF..."

# Verificar pandoc
if ! command -v pandoc &> /dev/null; then
    echo "⚠ Pandoc no instalado. Instalarlo: apt-get install pandoc wkhtmltopdf"
    echo "Procedimiento alternativo:"
    echo "1. Usar MS Word o Google Docs para convertir a PDF"
    echo "2. Usar herramientas online: https://pandoc.org/try/"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Convertir INFORME_TECNICO.md a PDF
pandoc "$PROJECT_ROOT/INFORME_TECNICO.md" \
    -o "$PROJECT_ROOT/INFORME_TECNICO.pdf" \
    --from markdown \
    --to pdf \
    --toc \
    --number-sections \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -V mainfont="Calibri"

# Convertir MANUAL_DESPLIEGUE.md a PDF
pandoc "$PROJECT_ROOT/MANUAL_DESPLIEGUE.md" \
    -o "$PROJECT_ROOT/MANUAL_DESPLIEGUE.pdf" \
    --from markdown \
    --to pdf \
    --toc \
    -V geometry:margin=1in \
    -V fontsize=11pt

echo "✓ PDFs generados:"
echo "  - INFORME_TECNICO.pdf"
echo "  - MANUAL_DESPLIEGUE.pdf"
