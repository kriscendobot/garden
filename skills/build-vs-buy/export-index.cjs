#!/usr/bin/env node
// export-index.cjs — generate the export-name index for one extracted tree.
//
//   node export-index.cjs <tree-dir> <owner/repo> <commit>   > index.tsv
//
// <tree-dir> is a `git archive` extraction of the repo at <commit> (the caller,
// scripts/jobs/export-index/build-export-index.sh, never hands us a checkout).
// For every workspace package (root `workspaces` globs; the root package itself
// when there are none) it resolves the public entry points from `exports`
// (falling back to `main`), follows `export … from` / `export *` transitively
// inside the package, and emits one row per exported value binding, attributed
// to its DEFINING declaration. Output is sorted, so it is byte-identical across
// runs. Columns: name specifier package def kind arity shape tokens private.
// A second section, `#dep <package> <dependency>...`, records each package's
// runtime dependencies so the detector can tell a cycle from a reachable buy.

'use strict';

const fs = require('fs');
const path = require('path');
const lib = require('./lib.cjs');

const GENERATOR = 'export-index/1';

const [treeDir, repo, commit] = process.argv.slice(2);
if (!treeDir || !repo || !commit) {
  process.stderr.write('export-index: usage: export-index.cjs <tree-dir> <owner/repo> <commit>\n');
  process.exit(2);
}

const readJson = file => {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    return null;
  }
};

const isDir = p => {
  try {
    return fs.statSync(p).isDirectory();
  } catch {
    return false;
  }
};
const isFile = p => {
  try {
    return fs.statSync(p).isFile();
  } catch {
    return false;
  }
};

// Minimal workspace-glob expansion: literal segments, `*`, and `**`.
function expandGlob(base, pattern) {
  const parts = pattern.replace(/\/+$/, '').split('/').filter(p => p && p !== '.');
  let current = [base];
  for (const part of parts) {
    const next = [];
    for (const dir of current) {
      if (part === '**') {
        const stack = [dir];
        while (stack.length) {
          const d = stack.pop();
          next.push(d);
          for (const entry of safeReaddir(d)) {
            if (entry === 'node_modules' || entry.startsWith('.')) continue;
            const child = path.join(d, entry);
            if (isDir(child)) stack.push(child);
          }
        }
      } else if (part.includes('*')) {
        const re = new RegExp(`^${part.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*')}$`);
        for (const entry of safeReaddir(dir)) {
          const child = path.join(dir, entry);
          if (re.test(entry) && isDir(child)) next.push(child);
        }
      } else {
        const child = path.join(dir, part);
        if (isDir(child)) next.push(child);
      }
    }
    current = next;
  }
  return current;
}

function safeReaddir(dir) {
  try {
    return fs.readdirSync(dir).sort();
  } catch {
    return [];
  }
}

function workspaceDirs() {
  const root = readJson(path.join(treeDir, 'package.json')) || {};
  let globs = root.workspaces;
  if (globs && !Array.isArray(globs)) globs = globs.packages;
  if (!Array.isArray(globs) || globs.length === 0) return [treeDir];
  const dirs = new Set();
  for (const glob of globs) {
    if (glob.startsWith('!')) continue;
    for (const dir of expandGlob(treeDir, glob)) {
      if (isFile(path.join(dir, 'package.json'))) dirs.add(dir);
    }
  }
  return [...dirs].sort();
}

// Collect the string targets under an `exports` value, dropping `types`-only
// conditions. Returns an array of relative target paths.
function targetsOf(value) {
  if (typeof value === 'string') return [value];
  if (Array.isArray(value)) return value.flatMap(targetsOf);
  if (value && typeof value === 'object') {
    const out = [];
    for (const [condition, sub] of Object.entries(value)) {
      if (condition === 'types' || condition === 'typings') continue;
      out.push(...targetsOf(sub));
    }
    return out;
  }
  return [];
}

// [{ specifier, target }] for one package.
function entryPoints(pkgDir, pkg) {
  const entries = [];
  const exp = pkg.exports;
  if (exp !== undefined && exp !== null) {
    const subpathMap =
      typeof exp === 'object' && !Array.isArray(exp) && Object.keys(exp).some(k => k.startsWith('.'))
        ? exp
        : { '.': exp };
    for (const [subpath, value] of Object.entries(subpathMap)) {
      if (!subpath.startsWith('.') || subpath.includes('*') || subpath === './package.json') continue;
      const specifier = subpath === '.' ? pkg.name : `${pkg.name}${subpath.slice(1)}`;
      for (const target of new Set(targetsOf(value))) {
        if (!/\.(c|m)?(j|t)sx?$/.test(target) || /\.d\.(c|m)?ts$/.test(target)) continue;
        entries.push({ specifier, target: path.join(pkgDir, target) });
      }
    }
  } else {
    const main = pkg.main || 'index.js';
    entries.push({ specifier: pkg.name, target: path.join(pkgDir, main) });
  }
  return entries.filter(e => isFile(e.target) || resolveFile(e.target));
}

function resolveFile(candidate) {
  for (const option of [candidate, `${candidate}.js`, `${candidate}.ts`, path.join(candidate, 'index.js')]) {
    if (isFile(option)) return option;
  }
  return null;
}

const moduleCache = new Map();
function loadModule(file) {
  if (moduleCache.has(file)) return moduleCache.get(file);
  let record = null;
  try {
    const program = lib.parse(fs.readFileSync(file, 'utf8'), file);
    if (program) record = { file, program, locals: localBindings(program) };
  } catch {
    record = null;
  }
  moduleCache.set(file, record);
  return record;
}

// Top-level declarations and imports: name -> { decl } | { importFrom, imported }.
function localBindings(program) {
  const locals = new Map();
  const addDecl = node => {
    if (!node) return;
    if ((node.type === 'FunctionDeclaration' || node.type === 'ClassDeclaration') && node.id) {
      locals.set(node.id.name, { decl: node });
    } else if (node.type === 'VariableDeclaration') {
      for (const d of node.declarations) {
        if (d.id && d.id.type === 'Identifier') locals.set(d.id.name, { decl: d });
      }
    }
  };
  for (const stmt of program.body) {
    if (stmt.type === 'ImportDeclaration' && stmt.importKind !== 'type') {
      for (const s of stmt.specifiers) {
        if (s.type === 'ImportSpecifier' && s.importKind !== 'type') {
          const imported = s.imported.type === 'Identifier' ? s.imported.name : s.imported.value;
          locals.set(s.local.name, { importFrom: stmt.source.value, imported });
        }
      }
    } else if (stmt.type === 'ExportNamedDeclaration') {
      addDecl(stmt.declaration);
    } else {
      addDecl(stmt);
    }
  }
  return locals;
}

const exportedName = node => (node.type === 'Identifier' ? node.name : node.value);

// Resolve `name` as exported by `file` to its defining declaration:
// { file, decl } or null (defined outside the package, or not found).
function resolveExport(file, name, pkgDir, seen = new Set()) {
  const key = `${file}\0${name}`;
  if (seen.has(key)) return null;
  seen.add(key);
  const mod = loadModule(file);
  if (!mod) return null;
  for (const stmt of mod.program.body) {
    if (stmt.type === 'ExportNamedDeclaration' && stmt.exportKind !== 'type') {
      if (stmt.declaration) {
        const local = localBindings({ body: [stmt] });
        if (local.has(name)) return { file, decl: local.get(name).decl };
      }
      for (const s of stmt.specifiers || []) {
        if (s.exportKind === 'type' || exportedName(s.exported) !== name) continue;
        if (stmt.source) {
          const target = relativeTarget(file, stmt.source.value, pkgDir);
          const inner = s.local ? exportedName(s.local) : name;
          return target ? resolveExport(target, inner, pkgDir, seen) : null;
        }
        return resolveLocal(file, exportedName(s.local), pkgDir, seen);
      }
    }
  }
  for (const stmt of mod.program.body) {
    if (stmt.type === 'ExportAllDeclaration' && stmt.exportKind !== 'type' && !stmt.exported && name !== 'default') {
      const target = relativeTarget(file, stmt.source.value, pkgDir);
      const hit = target && resolveExport(target, name, pkgDir, seen);
      if (hit) return hit;
    }
  }
  return null;
}

function resolveLocal(file, name, pkgDir, seen) {
  const mod = loadModule(file);
  const binding = mod && mod.locals.get(name);
  if (!binding) return null;
  if (binding.decl) return { file, decl: binding.decl };
  const target = relativeTarget(file, binding.importFrom, pkgDir);
  return target ? resolveExport(target, binding.imported, pkgDir, seen) : null;
}

// A relative specifier resolved inside the package, or null.
function relativeTarget(fromFile, specifier, pkgDir) {
  if (!specifier || !specifier.startsWith('.')) return null;
  const resolved = resolveFile(path.resolve(path.dirname(fromFile), specifier));
  if (!resolved || !resolved.startsWith(pkgDir + path.sep)) return null;
  return resolved;
}

// Every exported value name of `file` (following `export *`).
function exportedNames(file, pkgDir, seen = new Set()) {
  if (seen.has(file)) return new Set();
  seen.add(file);
  const names = new Set();
  const mod = loadModule(file);
  if (!mod) return names;
  for (const stmt of mod.program.body) {
    if (stmt.type === 'ExportNamedDeclaration' && stmt.exportKind !== 'type') {
      if (stmt.declaration) for (const n of localBindings({ body: [stmt] }).keys()) names.add(n);
      for (const s of stmt.specifiers || []) {
        if (s.exportKind !== 'type') names.add(exportedName(s.exported));
      }
    } else if (stmt.type === 'ExportAllDeclaration' && stmt.exportKind !== 'type') {
      if (stmt.exported) {
        names.add(exportedName(stmt.exported));
      } else {
        const target = relativeTarget(file, stmt.source.value, pkgDir);
        if (target) for (const n of exportedNames(target, pkgDir, seen)) names.add(n);
      }
    }
  }
  names.delete('default');
  return names;
}

const rows = [];
const deps = [];
for (const pkgDir of workspaceDirs()) {
  const pkg = readJson(path.join(pkgDir, 'package.json'));
  if (!pkg || !pkg.name) continue;
  const isPrivate = pkg.private === true ? '1' : '0';
  const runtimeDeps = Object.keys({ ...(pkg.dependencies || {}), ...(pkg.peerDependencies || {}) }).sort();
  deps.push(`#dep\t${pkg.name}\t${runtimeDeps.join(' ')}`);
  for (const { specifier, target } of entryPoints(pkgDir, pkg)) {
    const entry = resolveFile(target);
    if (!entry) continue;
    for (const name of [...exportedNames(entry, pkgDir)].sort()) {
      const hit = resolveExport(entry, name, pkgDir);
      if (!hit) continue;
      const info = lib.classify(hit.decl);
      if (!info) continue;
      const def = `${path.relative(treeDir, hit.file)}:${hit.decl.loc.start.line}`;
      const fn = info.fn;
      rows.push(
        [
          name,
          specifier,
          pkg.name,
          def,
          info.kind,
          fn ? lib.arityOf(fn) : '',
          fn ? lib.shapeOf(fn) : '',
          fn ? String(lib.tokenCount(fn)) : '',
          isPrivate,
        ].join('\t'),
      );
    }
  }
}

const sorted = [...new Set(rows)].sort();
const header = `# repo=${repo} commit=${commit} generator=${GENERATOR}\n# name\tspecifier\tpackage\tdef\tkind\tarity\tshape\ttokens\tprivate\n`;
process.stdout.write(header + [...sorted, ...deps.sort()].map(line => `${line}\n`).join(''));
