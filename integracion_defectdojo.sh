#!/bin/bash
# Script para enviar reportes a DefectDojo local

URL="http://localhost:8080"
API_KEY="TU_API_KEY_AQUI" # La sacas de DefectDojo > User Profile
PRODUCT_ID="1" # Cambia esto por el ID del producto en tu DefectDojo

echo "Subiendo reporte de Trivy (SCA / IaC)..."
curl -X POST "$URL/api/v2/import-scan/" \
  -H "Authorization: Token $API_KEY" \
  -F "scan_type=Trivy Scan" \
  -F "file=@reporte-trivy.json" \
  -F "product=$PRODUCT_ID" \
  -F "engagement_name=CI/CD Pipeline"

echo "Subiendo reporte de ZAP (DAST)..."
curl -X POST "$URL/api/v2/import-scan/" \
  -H "Authorization: Token $API_KEY" \
  -F "scan_type=ZAP Scan" \
  -F "file=@report_json.json" \
  -F "product=$PRODUCT_ID" \
  -F "engagement_name=CI/CD Pipeline"

echo "Reportes subidos correctamente."