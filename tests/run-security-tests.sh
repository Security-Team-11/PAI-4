#!/bin/bash
# Script de pruebas de seguridad locales - PAI-4 DevSecOps
# Ejecuta todas las herramientas de análisis sin necesidad del pipeline

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="$PROJECT_ROOT/logs"
REPORTS_DIR="$PROJECT_ROOT/reports"

# Crear directorios
mkdir -p "$LOGS_DIR" "$REPORTS_DIR"

echo "=========================================="
echo "Iniciando pruebas de seguridad locales"
echo "=========================================="
echo "Fecha: $(date)"
echo "Directorio: $PROJECT_ROOT"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. SAST - Semgrep
echo -e "${YELLOW}[1/3] Iniciando SAST con Semgrep...${NC}"
if command -v semgrep &> /dev/null; then
    semgrep --config=p/security-audit --json -o "$REPORTS_DIR/semgrep-report.json" "$PROJECT_ROOT/src" 2>&1 | tee -a "$LOGS_DIR/semgrep.log" || true
    echo -e "${GREEN}✓ SAST completado${NC}"
else
    echo -e "${YELLOW}⚠ Semgrep no instalado. Instalar: pip install semgrep${NC}"
fi

# 2. SCA/IaC - Trivy
echo -e "${YELLOW}[2/3] Iniciando SCA/IaC con Trivy...${NC}"
if command -v trivy &> /dev/null; then
    trivy fs --format json --output "$REPORTS_DIR/trivy-report.json" "$PROJECT_ROOT" 2>&1 | tee -a "$LOGS_DIR/trivy.log" || true
    trivy config --format json --output "$REPORTS_DIR/trivy-config-report.json" "$PROJECT_ROOT/config" 2>&1 | tee -a "$LOGS_DIR/trivy.log" || true
    echo -e "${GREEN}✓ SCA/IaC completado${NC}"
else
    echo -e "${YELLOW}⚠ Trivy no instalado. Instalar desde: https://github.com/aquasecurity/trivy${NC}"
fi

# 3. DAST - OWASP ZAP (requiere servidor ejecutándose)
echo -e "${YELLOW}[3/3] Iniciando DAST con OWASP ZAP...${NC}"
TARGET_URL="${1:-http://localhost:8080}"
if command -v zaproxy &> /dev/null || command -v zap.sh &> /dev/null; then
    echo "Objetivo: $TARGET_URL"
    # Nota: ZAP necesita interfaz gráfica o daemon, este es un placeholder
    echo "Para ejecutar ZAP en modo daemon: zaproxy -cmd -port 8090" > "$LOGS_DIR/zap-instructions.txt"
    echo -e "${YELLOW}⚠ ZAP requiere configuración manual en modo headless${NC}"
else
    echo -e "${YELLOW}⚠ OWASP ZAP no instalado${NC}"
fi

echo ""
echo "=========================================="
echo "Reportes generados en: $REPORTS_DIR"
ls -lh "$REPORTS_DIR" 2>/dev/null || echo "Sin reportes generados"
echo ""
echo "Logs en: $LOGS_DIR"
ls -lh "$LOGS_DIR" 2>/dev/null || echo "Sin logs generados"
echo "=========================================="
