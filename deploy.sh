[Unit]
Description=Gunicorn instance to serve FlaskApp
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/flaskapp
Environment="PATH=/opt/flaskapp/venv/bin"
ExecStart=/opt/flaskapp/venv/bin/gunicorn --workers 3 --bind unix:/opt/flaskapp/flaskapp.sock -m 007 wsgi:app

[Install]
WantedBy=multi-user.target