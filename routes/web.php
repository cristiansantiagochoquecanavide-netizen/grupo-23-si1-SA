<?php

use Illuminate\Support\Facades\Route;

// ===============================
// RUTA SPA (React controla todo)
// ===============================
Route::view('/{path?}', 'app')
    ->where('path', '.*')
    ->name('app');


