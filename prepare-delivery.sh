#!/bin/bash
# Script de preparación para entrega - PAI-4 DevSecOps

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DELIVERY_DIR="/tmp/PAI4-delivery"
TEAM_NUM="${1:-11}"
ZIP_NAME="PAI4-ST${TEAM_NUM}.zip"

echo "==========================================="
echo "Preparando entrega: $ZIP_NAME"
echo "==========================================="
echo ""

# Crear directorio de entrega
rm -rf "$DELIVERY_DIR"
mkdir -p "$DELIVERY_DIR"

echo "[1/5] Copiando código fuente..."
mkdir -p "$DELIVERY_DIR/src"
cp "$PROJECT_ROOT/src"/* "$DELIVERY_DIR/src/" 2>/dev/null || true

echo "[2/5] Copiando scripts y configuraciones..."
mkdir -p "$DELIVERY_DIR/scripts"
cp "$PROJECT_ROOT/integracion_defectdojo.sh" "$DELIVERY_DIR/scripts/"
cp "$PROJECT_ROOT/tests/run-security-tests.sh" "$DELIVERY_DIR/scripts/"
cp "$PROJECT_ROOT/config"/* "$DELIVERY_DIR/scripts/" 2>/dev/null || true
cp "$PROJECT_ROOT/docker-compose.yml" "$DELIVERY_DIR/"

echo "[3/5] Copiando logs y evidencias..."
mkdir -p "$DELIVERY_DIR/logs"
cp "$PROJECT_ROOT/logs"/* "$DELIVERY_DIR/logs/" 2>/dev/null || true
cp "$PROJECT_ROOT/.github/workflows/pipeline.yml" "$DELIVERY_DIR/logs/pipeline.yml"

echo "[4/5] Copiando documentación..."
mkdir -p "$DELIVERY_DIR/documentacion"
cp "$PROJECT_ROOT/README.md" "$DELIVERY_DIR/documentacion/"
cp "$PROJECT_ROOT/MANUAL_DESPLIEGUE.md" "$DELIVERY_DIR/documentacion/"
cp "$PROJECT_ROOT/INFORME_TECNICO.md" "$DELIVERY_DIR/documentacion/"

# Intentar generar PDFs
echo "[5/5] Generando documentación PDF..."
if command -v pandoc &> /dev/null; then
    pandoc "$PROJECT_ROOT/INFORME_TECNICO.md" \
        -o "$DELIVERY_DIR/documentacion/INFORME_TECNICO.pdf" \
        --from markdown --to pdf \
        --toc --number-sections \
        -V geometry:margin=1in -V fontsize=11pt 2>/dev/null || true
    
    echo "      ✓ PDF generado: INFORME_TECNICO.pdf"
else
    echo "      ⚠ Pandoc no disponible - convertir manualmente:"
    echo "        1. Abrir INFORME_TECNICO.md en Word/Google Docs"
    echo "        2. Exportar como PDF"
fi

echo ""
echo "==========================================="
echo "Creando archivo ZIP..."
echo "==========================================="

# Crear ZIP
cd "$DELIVERY_DIR/.."
zip -r "$ZIP_NAME" "$(basename $DELIVERY_DIR)" > /dev/null

echo "✓ Archivo ZIP creado: $ZIP_NAME"
echo ""
echo "Ubicación: /tmp/$ZIP_NAME"
echo ""

# Listar contenido
echo "Contenido del ZIP:"
echo "================="
unzip -l "/tmp/$ZIP_NAME" | head -30

echo ""
echo "Tamaño: $(du -h /tmp/$ZIP_NAME | cut -f1)"
echo ""
echo "==========================================="
echo "LISTO PARA ENTREGA"
echo "==========================================="
echo ""
echo "Instrucciones de entrega:"
echo "1. Descargar: /tmp/$ZIP_NAME"
echo "2. Subir en plataforma de enseñanza virtual"
echo "3. Verificar antes de enviar (fecha límite: 27 abril 23:59)"
echo ""
echo "Contenido mínimo requerido:"
echo "  ✓ Código fuente (src/)"
echo "  ✓ Scripts de seguridad (scripts/)"
echo "  ✓ Logs y evidencias (logs/)"
echo "  ✓ Documentación PDF (documentacion/)"
echo ""
