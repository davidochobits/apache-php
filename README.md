Proyecto PHP con Despliegue Automático vía Git
Este proyecto permite levantar un entorno PHP (Apache) que clona automáticamente un repositorio privado al iniciar el contenedor. Ideal para entornos de desarrollo o despliegues rápidos donde se requiere sincronización inmediata con un repositorio remoto mediante SSH.

Características
Despliegue automático: Clona un repositorio Git privado en el volumen de la aplicación al iniciar.

Autenticación SSH: Configuración mediante clave privada (Base64) para acceso seguro a repositorios privados.

Persistencia: Utiliza volúmenes de Docker para mantener el código entre reinicios del contenedor.

Entorno personalizable: Basado en PHP 8.3 (Apache), extensible según tus necesidades.

Requisitos Previos
Docker y Docker Compose instalados.

Clave privada SSH con acceso al repositorio remoto.

Configuración
1. Variables de entorno
Crea un archivo .env en la raíz del proyecto para definir tus credenciales:

Fragmento de código
# Clave privada SSH en formato base64
# Generación: base64 -w0 ~/.ssh/id_rsa
RSA_KEY=tu_clave_privada_en_base64_aqui

# URL SSH del repositorio (p. ej. git@github.com:usuario/repo.git)
GIT_URL=git@github.com:usuario/repo.git
2. Ejecución
Para iniciar el entorno, simplemente ejecuta:

Bash
docker-compose up --build
El script entrypoint.sh se encargará automáticamente de:

Configurar la clave SSH en /root/.ssh/id_rsa.

Añadir el host del repositorio a known_hosts.

Clonar el código fuente en /var/www/html si el directorio está vacío.

Iniciar el servidor Apache.

Estructura del proyecto
Dockerfile: Define la imagen base, dependencias (PHP, LDAP, Git, SSH) y configuración del punto de entrada.

entrypoint.sh: Script lógico que gestiona la autenticación SSH y la clonación del repositorio.

docker-compose.yml: Orquestación del servicio y gestión de volúmenes persistentes.

Notas técnicas
Seguridad: Asegúrate de que la clave SSH utilizada tenga permisos limitados (solo lectura si es posible).

Persistencia: El código se clona dentro del volumen app_code. Si deseas actualizar el código, puedes borrar el volumen (docker-compose down -v) o entrar al contenedor y hacer git pull.
