# ImageResizerCLI

ImageResizer es una herramienta por línea de comandos escrita en Swift para redimensionar imágenes en formato PNG a los tamaños estándar de iOS: **1x**, **2x**, y **3x**. Esto facilita la creación de recursos escalables para proyectos móviles.

## Características
- Redimensiona automáticamente imágenes en **1x**, **2x**, y **3x**.
- Compatible con macOS.
- Organiza las imágenes redimensionadas en una carpeta de salida.

---

## Requisitos
- **Swift 5.7** o superior.
- **macOS 11.0** o superior.
- **Xcode** (opcional, para compilar el proyecto si no usas Swift desde la línea de comandos).

---

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/ImageResizerCLI.git
   ```

2. Navega al directorio del proyecto:
   ```bash
   cd ImageResizerCLI
   ```

3. Compila el proyecto usando Swift Package Manager:
   ```bash
   swift build -c release
   ```

   Esto generará un ejecutable en:
   ```
   .build/release/ImageResizerCLI
   ```

4. (Opcional) Instala la herramienta de forma global copiándola en `/usr/local/bin`:
   ```bash
   cp .build/release/ImageResizerCLI /usr/local/bin/imageresizer
   ```

---

## Uso

### Comando básico
Ejecuta el script desde la terminal con:
```bash
ImageResizerCLI <carpeta-entrada> <carpeta-salida>
```

### Argumentos
- **`<carpeta-entrada>`**: Ruta a la carpeta que contiene las imágenes PNG originales.
- **`<carpeta-salida>`**: Ruta a la carpeta donde se guardarán las imágenes redimensionadas.

### Ejemplo práctico
Imagina que tienes una carpeta con imágenes llamada `input-images` y quieres guardar las versiones redimensionadas en `output-images`:
```bash
ImageResizerCLI input-images output-images
```

---

## Formato de salida
Por cada imagen PNG en la carpeta de entrada, el script generará tres versiones redimensionadas con los sufijos:
- **`@1x`**: Escala completa (100%).
- **`@2x`**: Redimensionada al 50%.
- **`@3x`**: Redimensionada al 33%.

### Ejemplo
Si tu archivo original se llama `icon.png`, el resultado será:
```
output-images/
  ├── icon@1x.png
  ├── icon@2x.png
  ├── icon@3x.png
```

---

## Mensajes de la herramienta

Durante la ejecución, verás mensajes como:
- `✅ Imagen redimensionada:` Indica que una imagen se ha procesado correctamente.
- `⚠️` Advertencias, como cuando una imagen no se puede procesar.
- `❌` Errores, por ejemplo, si no se puede leer la carpeta de entrada.

---

## Recomendaciones
1. **Imágenes originales:** Asegúrate de que tus imágenes originales estén en formato PNG.
2. **Carpetas:** Verifica que las rutas de entrada y salida existan y tengan permisos de escritura.
3. **Rendimiento:** Este script está optimizado para imágenes de tamaños razonables. Procesar imágenes muy grandes puede ser más lento.

---

## Problemas comunes

| Problema                            | Posible causa                                       | Solución                              |
|-------------------------------------|----------------------------------------------------|---------------------------------------|
| `❌ Error al leer la carpeta de entrada` | La carpeta no existe o no tiene imágenes PNG.       | Verifica la ruta y los archivos.      |
| `⚠️ No se pudo cargar la imagen`     | El archivo no es un PNG válido o está corrupto.     | Revisa las imágenes en la carpeta.    |
| `❌ Error al guardar la imagen`      | No tienes permisos para escribir en la carpeta de salida. | Verifica los permisos de la carpeta. |

---
