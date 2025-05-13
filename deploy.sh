#!/usr/bin/env bash

# --- Variables (ajústalas) ---
APP_DIR="/home/ubuntu/my_flask_app"
GIT_REPO="https://github.com/dimebag7777/primer_deploy.git"
USER="dimebag"
SERVICE_FILE="/etc/systemd/system/flask_app.service"
NGINX_CONF="/etc/nginx/sites-available/nginx_flask_app.conf"
DOMAIN_OR_IP="179.5.119.85"

# 1. Actualizar sistema e instalar dependencias
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-venv python3-pip nginx git

# 2. Clonar repo si no existe
if [ ! -d "$APP_DIR" ]; then
  sudo -u $USER git clone $GIT_REPO $APP_DIR
fi

# 3. Crear y activar entorno virtual
cd $APP_DIR
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 4. Instalar y habilitar unit de systemd
sudo cp deploy_configs/flask_app.service $SERVICE_FILE
sudo systemctl daemon-reload
sudo systemctl enable flask_app.service
sudo systemctl start flask_app.service

# 5. Configurar Nginx
sudo cp nginx_flask_app.conf $NGINX_CONF
sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# 6. Firewall (si usas UFW)
sudo ufw allow 'Nginx Full'

echo "Despliegue completado. Accede a http://$DOMAIN_OR_IP/"