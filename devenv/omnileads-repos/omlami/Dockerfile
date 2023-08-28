# Especifica la imagen base
FROM python:3.10.4-slim-bullseye  as run

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos necesarios al contenedor
COPY ami.py requirements.txt /app/

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Especifica el comando para ejecutar tu componente
CMD [ "python", "ami.py" ]
