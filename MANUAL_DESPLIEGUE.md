# MANUAL DE DESPLIEGUE - PAI-4 DevSecOps

## 1. Requisitos Previos

- Docker y Docker Compose
- Git
- Bash/Shell

## 2. Instalacion y Configuracion

### 2.1 Clonar el Repositorio

```bash
git clone https://github.com/Security-Team-11/PAI-4.git
cd PAI-4
```

### 2.2 Levantar este Proyecto

```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f vulnerable-app
```

Servicio local:
- `vulnerable-app`: `http://localhost:8080`

### 2.3 Levantar DefectDojo desde GitHub

```bash
git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo
docker compose up -d
docker compose logs initializer
```

Accesos:
- `http://localhost:8000`
- `http://localhost:8000/api/key-v2`

### 2.4 Ejecutar Pruebas y Enviar Reportes

```bash
bash tests/run-security-tests.sh http://localhost:8080
bash integracion_defectdojo.sh http://localhost:8000 <API_KEY> 1
```

## 3. Pipeline CI/CD

Configura en GitHub:
- `DEFECTDOJO_URL`
- `DEFECTDOJO_API_KEY`

Si no estan definidos, el workflow no falla: simplemente omite el envio.

## 4. Troubleshooting

### DefectDojo no inicia

```bash
cd django-DefectDojo
docker compose logs initializer
docker compose ps
```

### Error de conexion a DefectDojo

```bash
curl -v http://localhost:8000
curl -H "Authorization: Token <API_KEY>" http://localhost:8000/api/v2/users/
```
