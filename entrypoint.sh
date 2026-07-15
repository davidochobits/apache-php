#!/bin/sh
set -e

echo "========== INICIANDO CONTENEDOR =========="

# Configurar la clave SSH si se ha proporcionado
if [ -n "$RSA_KEY" ]; then
    echo "$RSA_KEY" | base64 -d > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
fi

# Clonar el repositorio solo si el directorio aún no contiene uno
if [ -n "$GIT_URL" ] && [ ! -d .git ]; then
    # Extraer el host de GIT_URL para añadirlo a known_hosts
    # Soporta formatos: git@host:ruta/repo.git y ssh://git@host/ruta/repo.git
    GIT_HOST=$(echo "$GIT_URL" | sed -E 's#^ssh://##; s#^[^@]*@##; s#[:/].*$##')
    if [ -n "$GIT_HOST" ]; then
        echo "========== AÑADIENDO $GIT_HOST A KNOWN_HOSTS =========="
        ssh-keyscan "$GIT_HOST" >> /root/.ssh/known_hosts 2>/dev/null
    fi

    echo "========== CLONANDO REPOSITORIO =========="
    git clone "$GIT_URL" .
    echo "========== REPOSITORIO CLONADO CON ÉXITO =========="
elif [ -d .git ]; then
    echo "========== REPOSITORIO YA EXISTENTE, OMITIENDO CLONADO =========="
fi

echo "========== ARRANCANDO: $* =========="
exec "$@"
