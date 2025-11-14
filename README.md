# Riftstrike — Godot 4 HTML5 MVP

Resumen
- Prototipo Godot 4 orientado a exportar a HTML5: avatar, sistema básico de cartas (robo/mano/jugar), Rifts y HUD mínimo.
- Assets placeholders; preparado para reemplazarse.

Requisitos
- Godot 4.x instalado.
- Plantillas de export HTML5 instaladas (Editor → Manage Export Templates).
- Navegador moderno; para pruebas locales usa `python -m http.server` o sube a hosting estático.

Estructura mínima del repo
- project.godot
- scenes/Main.tscn
- scenes/Player.tscn
- scripts/player.gd
- scripts/card_manager.gd
- data/cards.json
- README.md

Quick start
1. Crear proyecto Godot 4 y pegar los archivos en las rutas indicadas.
2. Abrir Godot; cargar `scenes/Main.tscn` como escena principal y ejecutar (F5).
3. Para exportar a HTML5:
   - Asegúrate de tener Export Templates instaladas.
   - File → Export → Add → HTML5 → Export to `build/html5`.
   - O usa CLI: `godot --export "HTML5" build/html5/index.html` (ajusta el preset).
4. Para servir localmente la carpeta exportada:
   - `cd build/html5`
   - `python -m http.server 8000`
   - Abrir http://localhost:8000 en el navegador.

Git & GitHub (subida rápida)
- Crear repo en GitHub llamado `Riftstrike-Godot-HTML5`.
- En tu máquina:
  - git init
  - git add .
  - git commit -m "Initial Riftstrike Godot HTML5 MVP"
  - git branch -M main
  - git remote add origin https://github.com/b2znbjc5cd-collab/Riftstrike-Godot-HTML5.git
  - git push -u origin main

Si prefieres usar `gh` CLI para crear el repo:
- gh auth login
- gh repo create <tu_usuario>/Riftstrike-Godot-HTML5 --public --source=. --remote=origin --push

Publicar HTML5 en GitHub Pages (opcional)
- Exporta a `build/html5`, luego crea branch `gh-pages` con el contenido exportado y púshalo:
  - git checkout --orphan gh-pages
  - rm -rf .
  - cp -r ../build/html5/* .
  - git add .
  - git commit -m "Publish HTML5 build"
  - git push -u origin gh-pages --force

Cuando tengas el repo público, pásame la URL o confirma la autorización y yo me encargo de la parte final (CI, builds automáticos, ZIP de export).