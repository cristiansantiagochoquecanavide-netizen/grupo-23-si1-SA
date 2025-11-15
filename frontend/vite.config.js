import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';
import fs from 'fs';
import path from 'path';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/js/app.jsx'],
            refresh: true,
        }),
        react(),
        {
            name: 'copy-manifest',
            writeBundle() {
                const manifestPath = path.resolve('../backend/public/build/.vite/manifest.json');
                const destPath = path.resolve('../backend/public/build/manifest.json');
                
                if (fs.existsSync(manifestPath)) {
                    fs.copyFileSync(manifestPath, destPath);
                    console.log('✓ Manifest copiado a build/manifest.json');
                }
            }
        }
    ],

    build: {
        manifest: true,
        outDir: '../backend/public/build',
        emptyOutDir: true,
    },
});