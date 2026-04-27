<?php
/**
 * Aplicación Web Vulnerable - PAI-4 DevSecOps
 * Propósito: Demostración de vulnerabilidades para pruebas de seguridad
 * 
 * VULNERABILIDADES INTENCIONALES:
 * - SQL Injection
 * - Cross-Site Scripting (XSS)
 * - Insecure Direct Object References (IDOR)
 * - Missing Authentication
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Simulación de base de datos vulnerable
$users = [
    1 => ['id' => 1, 'name' => 'Admin', 'email' => 'admin@example.com', 'password' => 'admin123'],
    2 => ['id' => 2, 'name' => 'User1', 'email' => 'user1@example.com', 'password' => 'pass123'],
    3 => ['id' => 3, 'name' => 'User2', 'email' => 'user2@example.com', 'password' => 'pass456']
];

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aplicación Vulnerable - PAI-4</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; }
        h1 { color: #d32f2f; }
        .form-group { margin: 15px 0; }
        input, textarea { width: 100%; padding: 8px; box-sizing: border-box; }
        button { background: #1976d2; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 3px; }
        button:hover { background: #1565c0; }
        .warning { background: #fff3cd; border: 1px solid #ffc107; padding: 10px; margin: 10px 0; border-radius: 3px; color: #856404; }
        .result { background: #e3f2fd; border: 1px solid #2196F3; padding: 10px; margin: 10px 0; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>⚠️ Aplicación Vulnerable - Propósitos Educativos</h1>
        <div class="warning">
            Esta aplicación contiene vulnerabilidades intencionales para pruebas de seguridad en el pipeline DevSecOps.
        </div>

        <h2>1. Búsqueda de Usuarios (SQL Injection)</h2>
        <form method="GET">
            <div class="form-group">
                <input type="text" name="search" placeholder="Ej: 1 OR 1=1" value="<?php echo isset($_GET['search']) ? htmlspecialchars($_GET['search']) : ''; ?>">
                <button type="submit">Buscar</button>
            </div>
        </form>
        <?php
        if (isset($_GET['search'])) {
            // VULNERABILIDAD: SQL Injection simulado
            $search = $_GET['search'];
            echo '<div class="result">';
            echo '<h4>Resultados de búsqueda:</h4>';
            // Simulación: si contiene "OR" probablemente sea injection
            if (stripos($search, 'OR') !== false || stripos($search, '1=1') !== false) {
                echo '<p><strong>⚠️ Inyección detectada:</strong> Se encontró patrón sospechoso</p>';
                echo '<p>Parámetro: ' . htmlspecialchars($search) . '</p>';
                foreach ($users as $user) {
                    echo '<p>- ' . $user['name'] . ' (' . $user['email'] . ')</p>';
                }
            } else {
                foreach ($users as $user) {
                    if (stripos($user['name'], $search) !== false || stripos($user['email'], $search) !== false) {
                        echo '<p>- ' . $user['name'] . ' (' . $user['email'] . ')</p>';
                    }
                }
            }
            echo '</div>';
        }
        ?>

        <h2>2. Acceso a Perfil de Usuario (IDOR)</h2>
        <form method="GET">
            <div class="form-group">
                <input type="number" name="userid" min="1" max="3" placeholder="ID de usuario (1-3)" value="<?php echo isset($_GET['userid']) ? htmlspecialchars($_GET['userid']) : ''; ?>">
                <button type="submit" name="action" value="profile">Ver Perfil</button>
            </div>
        </form>
        <?php
        if (isset($_GET['userid']) && isset($_GET['action']) && $_GET['action'] === 'profile') {
            $userid = $_GET['userid'];
            // VULNERABILIDAD: IDOR - Acceso sin autenticación
            if (isset($users[$userid])) {
                $user = $users[$userid];
                echo '<div class="result">';
                echo '<h4>Información del Usuario:</h4>';
                echo '<p><strong>ID:</strong> ' . $user['id'] . '</p>';
                echo '<p><strong>Nombre:</strong> ' . $user['name'] . '</p>';
                echo '<p><strong>Email:</strong> ' . $user['email'] . '</p>';
                echo '<p><strong>Contraseña:</strong> ' . $user['password'] . '</p>';
                echo '</div>';
            } else {
                echo '<div class="result"><p>Usuario no encontrado</p></div>';
            }
        }
        ?>

        <h2>3. Comentarios (XSS - Cross-Site Scripting)</h2>
        <form method="POST">
            <div class="form-group">
                <textarea name="comment" placeholder="Escriba su comentario..." rows="4"></textarea>
                <button type="submit" name="action" value="comment">Enviar Comentario</button>
            </div>
        </form>
        <?php
        if (isset($_POST['action']) && $_POST['action'] === 'comment' && isset($_POST['comment'])) {
            $comment = $_POST['comment'];
            // VULNERABILIDAD: XSS - Sin sanitización
            echo '<div class="result">';
            echo '<h4>Comentario publicado:</h4>';
            echo '<p>' . $comment . '</p>'; // Sin htmlspecialchars() - XSS vulnerability
            echo '</div>';
        }
        ?>

        <h2>4. Estadísticas de Sistema</h2>
        <div class="result">
            <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
            <p><strong>Sistema Operativo:</strong> <?php echo php_uname(); ?></p>
            <p><strong>Usuario actual:</strong> <?php echo get_current_user() ?: 'no disponible'; ?></p>
            <p><strong>Directorio:</strong> <?php echo getcwd(); ?></p>
        </div>

        <hr>
        <p style="font-size: 12px; color: #666;">
            <strong>Herramientas de análisis detectadas:</strong><br>
            - Semgrep (SAST): Detectará inyección SQL, XSS<br>
            - Trivy (SCA/IaC): Verificará dependencias y configuración<br>
            - OWASP ZAP (DAST): Detectará vulnerabilidades en tiempo de ejecución
        </p>
    </div>
</body>
</html>
