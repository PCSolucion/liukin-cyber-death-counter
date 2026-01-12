# Cyberpunk 2077 - Trauma Team Death Counter
**Widget de OBS estilo Cyberpunk / Trauma Team para contar muertes en tiempo real.**

Este proyecto es un contador de muertes ("Death Counter") diseñado para streamers que juegan Cyberpunk 2077. Funciona interceptando pulsaciones de teclado globales (incluso mientras juegas) y mostrando un HUD animado en OBS.

![Trauma Team Style](https://cdn.displate.com/artwork/857x1200/2020-03-25/6699dc2a53601e873d07b2257bb2cdc6_dd4c2e81f21d34b92067288e0774ec81.jpg)

## 🚀 Características

*   **Sin Dependencias**: Escrito enteramente en PowerShell + HTML/JS. No necesitas instalar Node.js, Python ni nada extra.
*   **Diseño Inmersivo**: Interfaz inspirada en el HUD de los cascos de Trauma Team.
    *   Monitor de signos vitales (ECG animado).
    *   Efectos de distorsión y "Daño Crítico" al sumar muertes.
    *   Modo oscuro optimizado para streams (fondo transparente/oscuro).
*   **Persistencia**: Guarda el número de muertes en un archivo local (`count.txt`) para no perder la cuenta al reiniciar.

## 🎮 Controles

Mientras juegas (con el script ejecutándose):

*   **`NumPad 9`**: **+1 Muerte** (Suma al contador y lanza alerta visual).
*   **`NumPad 7`**: **-1 Muerte** (Resta al contador por si te equivocas).

*(Asegúrate de tener el BLOQ NUM activado)*

## 🛠️ Instalación y Uso

1.  **Descargar**: Clona este repositorio o descarga el ZIP.
2.  **Iniciar**: Haz doble clic en el archivo **`start_widget.bat`**.
    *   Acepta los permisos de Administrador (Necesario para leer teclas sobre juegos a pantalla completa).
    *   Se abrirá una ventana negra ("Listener"). **Miniminízala, no la cierres.**
3.  **Configurar OBS Studio**:
    *   Agrega una nueva fuente de **Navegador**.
    *   URL: `http://localhost:3000`
    *   Ancho: `500`
    *   Alto: `300`
    *   Borra el CSS personalizado (déjalo vacío).
4.  **¡Jugar!**

## 🔧 Solución de Problemas

*   **¿El contador no sube?**
    *   Asegúrate de haber ejecutado el `.bat` como Administrador.
    *   Comprueba que tienes el **Bloq Num** activado.
    *   Algunos antivirus pueden bloquear scripts de PowerShell que escuchan teclas (Keyloggers). Añade la carpeta a exclusiones si es necesario.
*   **¿Cómo reinicio a 0?**
    *   Abre el archivo `count.txt` en la carpeta, escribe `0` y guarda.

## 📂 Estructura del Proyecto

*   `main.ps1`: Script principal que orquesta el servidor y el listener.
*   `server.ps1`: Servidor HTTP ligero en PowerShell para comunicar el widget.
*   `key_listener.ps1`: Detector de teclas globales usando User32.dll.
*   `public/`: Archivos del frontend (HTML, CSS, JS).

## 👤 Créditos

Diseñado para **Liukin**. 
Estilo visual basado en **Cyberpunk 2077 - Trauma Team**.
