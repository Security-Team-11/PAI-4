# PAI-4: DevSecOps - Aseguramiento de la Cadena de Suministro

**Proyecto de Seguridad en el Desarrollo de Aplicaciones Web**

## Descripcion

Implementacion de un Pipeline DevSecOps automatizado que integra herramientas de analisis de seguridad con DefectDojo para la gestion centralizada de vulnerabilidades en aplicaciones web.

## Herramientas Implementadas

- Semgrep
- Trivy
- OWASP ZAP
- DefectDojo

## Inicio Rapido

### Local (Docker)

```bash
# Levantar solo la app vulnerable de este repo
docker-compose up -d

# Aplicacion local
http://localhost:8080

# Ejecutar pruebas
bash tests/run-security-tests.sh

# Enviar reportes a una instancia externa de DefectDojo
bash integracion_defectdojo.sh http://localhost:8000 <API_KEY>
```

### DefectDojo Externo

Este repositorio no levanta DefectDojo. Debes arrancarlo desde su repositorio oficial:

```bash
git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo
docker compose up -d
docker compose logs initializer
```

Despues:

```text
http://localhost:8000
http://localhost:8000/api/key-v2
```

Luego usa el token en este proyecto:

```bash
bash integracion_defectdojo.sh http://localhost:8000 <API_KEY> 1
```

### GitHub Actions

Configura estos secrets:

- `DEFECTDOJO_URL`
- `DEFECTDOJO_API_KEY`

Si no existen, el paso de envio a DefectDojo se omite.
