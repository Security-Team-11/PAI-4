# PAI-4: DevSecOps - Informe Tecnico

## Resumen

El proyecto implementa un pipeline DevSecOps con Semgrep, Trivy, OWASP ZAP y DefectDojo. La novedad de esta version es que DefectDojo ya no se despliega dentro de este repositorio: se consume como instancia externa levantada desde el repositorio oficial `django-DefectDojo`.

## Arquitectura

- Este repo levanta solo la aplicacion vulnerable en `http://localhost:8080`
- DefectDojo se clona desde GitHub y se levanta aparte con `docker compose up -d`
- La integracion se realiza mediante API v2 con token


## Flujo de uso

1. Levantar la app vulnerable desde este repo
2. Levantar DefectDojo desde `https://github.com/DefectDojo/django-DefectDojo`
3. Obtener la API key en `/api/key-v2`
4. Ejecutar pruebas locales
5. Importar reportes con `integracion_defectdojo.sh`

## GitHub Actions

El workflow usa los secrets:

- `DEFECTDOJO_URL`
- `DEFECTDOJO_API_KEY`

Si faltan, se omite el envio a DefectDojo sin romper el pipeline.
