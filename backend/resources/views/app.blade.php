<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>App Carga Horaria</title>
    @if (file_exists(public_path('build/manifest.json')))
        @vite(['resources/js/app.jsx'])
    @else
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@3/tailwind.min.css">
    @endif
</head>
<body>
    <div id="root"></div>
</body>
</html>
