const esbuild = require('esbuild'); const fs = require('fs'); const path = require('path');
fs.mkdirSync('dist', { recursive: true });
esbuild.buildSync({ entryPoints: ['src/main.jsx'], bundle: true, minify: true, format: 'esm', sourcemap: false,
  outfile: 'dist/app.js', jsx: 'automatic', target: ['es2020', 'safari15'],
  define: { 'process.env.NODE_ENV': '"production"' }, legalComments: 'none' });
for (const f of fs.readdirSync('public')) fs.copyFileSync(path.join('public', f), path.join('dist', f));
console.log('Build concluído em dist/');
