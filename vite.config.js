import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/js/app.jsx'],
            refresh: true,
        }),
        react(),
    ],
    server: {
        https: true, // Asegura que el servidor de desarrollo use HTTPS
    },
    build: {
        manifest: true, // Genera un manifiesto para los assets
    },
});

