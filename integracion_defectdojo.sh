#!/bin/bash
# Script para enviar reportes a DefectDojo - PAI-4 DevSecOps
# Uso: ./integracion_defectdojo.sh [URL] [API_KEY] [PRODUCT_ID] [REPORTS_DIR]

set -e

# Variables configurables
URL="${1:-http://localhost:8080}"
API_KEY="${2:-3b4402b708ee1bf20e3ff241857a8ca1a044a22c}"
PRODUCT_ID="${3:-1}"
REPORTS_DIR="${4:-./reports}"

echo "=========================================="
echo "Integracion DefectDojo - PAI-4 DevSecOps"
echo "=========================================="
echo "DefectDojo URL: $URL"
echo "Product ID: $PRODUCT_ID"
echo "Directorio de reportes: $REPORTS_DIR"
echo ""

# Verificar conexion a DefectDojo
echo "Verificando conexion a DefectDojo..."
if ! curl -s -f "$URL/api/v2/users/" -H "Authorization: Token 3b4402b708ee1bf20e3ff241857a8ca1a044a22c" > /dev/null; then
    echo "Error: No se puede conectar a DefectDojo"
    echo "  - Verificar que DefectDojo esta ejecutandose: $URL"
    echo "  - Verificar API_KEY correcta"
    echo "  - Si lo has clonado desde GitHub:"
    echo "    git clone https://github.com/DefectDojo/django-DefectDojo.git"
    echo "    cd django-DefectDojo && docker compose up -d"
    exit 1
fi
echo "Conexion establecida"
echo ""

send_report() {
    local scan_type="$1"
    local file="$2"
    local engagement_name="$3"

    if [ ! -f "$file" ]; then
        echo "Archivo no encontrado: $file"
        return 1
    fi

    echo "Enviando: $scan_type"
    echo "  Archivo: $file"

    response=$(curl -s -X POST "$URL/api/v2/import-scan/" \
        -H "Authorization: Token 3b4402b708ee1bf20e3ff241857a8ca1a044a22c" \
        -F "scan_type=$scan_type" \
        -F "file=@$file" \
        -F "product=$PRODUCT_ID" \
        -F "engagement_name=$engagement_name" \
        -F "active=true" \
        --max-time 60)

    if echo "$response" | grep -q "id"; then
        echo "Exito"
    else
        echo "Error al enviar"
        echo "  Respuesta: $response"
    fi
    echo ""
}

echo "Subiendo reportes..."
echo ""

send_report "Semgrep JSON Report" "$REPORTS_DIR/semgrep-report.json" "CI-CD-Pipeline-$(date +%Y%m%d-%H%M%S)"
send_report "Trivy Scan" "$REPORTS_DIR/trivy-report.json" "CI-CD-Pipeline-$(date +%Y%m%d-%H%M%S)"
send_report "ZAP Scan" "$REPORTS_DIR/zap-report.json" "CI-CD-Pipeline-$(date +%Y%m%d-%H%M%S)" || true

echo "=========================================="
echo "Integracion completada"
echo "Acceder a DefectDojo: $URL"
echo "=========================================="
