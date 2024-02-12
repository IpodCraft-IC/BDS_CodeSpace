#!/bin/bash

# Establece la versión que quieras descargar. "latest" es para descargar la versión oficial más reciente del servidor
BEDROCK_VERSION="latest"

# Establece si quieres descargar versiones oficiales o versiones beta/preview
# bin-linux - Esto establece para descargar versiones oficiales.
# bin-linux-preview - Esto establece para descargar versiones beta/preview.
BEDROCK_PREFIJO="bin-linux"

if [ ! -d Minecraft_Bedrock_Server/ ]; then
    mkdir Minecraft_Bedrock_Server
fi

cd Minecraft_Bedrock_Server

RANDVERSION=$(echo $((1 + $RANDOM % 4000)))

if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" == "latest" ]; then
    echo -e "\n Descargando la versión reciente de Bedrock server"
    curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -H "Accept-Encoding: gzip, deflate" -o versions.html.gz https://www.minecraft.net/en-us/download/server/bedrock
    DOWNLOAD_URL=$(zgrep -o "https://minecraft.azureedge.net/$BEDROCK_PREFIJO/[^\"]*" versions.html.gz)
else 
    echo -e "\n Descargando la versión ${BEDROCK_VERSION} de Bedrock server"
    DOWNLOAD_URL=https://minecraft.azureedge.net/$BEDROCK_PREFIJO/bedrock-server-$BEDROCK_VERSION.zip
fi

DOWNLOAD_FILE=$(echo ${DOWNLOAD_URL} | cut -d"/" -f5)

echo -e "Respaldando archivos de configuración"
rm *.bak versions.html.gz
rm -r behavior_packs/
rm -r definitions/
rm -r development_behavior_packs/
rm -r development_resource_packs/
rm -r development_skin_packs/
rm -r minecraftpe/
rm -r premium_cache/
rm -r resource_packs/
rm -r treatments/
rm -r world_templates/
cp server.properties server.properties.bak
cp permissions.json permissions.json.bak
cp allowlist.json allowlist.json.bak


echo -e "Descargando los archivos de: $DOWNLOAD_URL"

curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -o $DOWNLOAD_FILE $DOWNLOAD_URL

echo -e "Descomprimiendo el archivo del servidor"
unzip -o $DOWNLOAD_FILE

echo -e "Limpiando la basura de la actualización"
rm $DOWNLOAD_FILE

echo -e "Restaurando archivos de configuración de respaldo: en la primera instalación, es posible que aparezcan errores de 'archivo no encontrado', los cuales puedes ignorar."
cp -rf server.properties.bak server.properties
cp -rf permissions.json.bak permissions.json
cp -rf allowlist.json.bak allowlist.json

chmod +x bedrock_server

echo -e "Actualización Completada!"