#!/usr/bin/env node
// detect.cjs — the build-vs-buy detector: one engine, three callers (the
// pre-push probe, the procurer jury seat, and the prefer-endo-primitives shim).
// design: designs/export-index-build-vs-buy.md § 3; rule: skills/build-vs-buy/SKILL.md.
//
// USAGE
//   node detect.cjs [--repo <root>] [--base <ref> | --staged | --worktree | --stdin <label>]
//                   [--index <tsv>[=<repo-root>]]... [--passes name,idiom]
//
//   Diff source: --base <ref> reviews `<ref>...HEAD` (head content at HEAD);
//   --staged the index; --worktree unstaged edits; --stdin <label> treats every
//   stdin line as an added line of one file named <label>. With none of these,
//   the staged diff is used when non-empty, else the worktree diff.
//   --index names an export-index TSV (repeatable). `=<repo-root>` names the repo
//   the provider source is read from (default --repo); the first index is the
//   project's own, later ones are provider repos.
//
// OUTPUT: one JSON object per hit on stdout.
//   name pass:  {pass:"name", file, line, name, strength, reason, provider:{specifier,
//                export, package, def}, local_src, provider_src, waiver, local_shape,
//                provider_shape}
//   idiom pass: {pass:"idiom", file, line, id, name, description, advice,
//                provider:{specifier, export}, waiver:null}   (only unwaived idioms)
//   strength: strong | weak | blocked (name pass; idiom hits are always "idiom").
// EXIT: 0 ran (zero or more hits); 2 usage; 3 git or an index unreadable.

'use strict';

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');
const lib = require('./lib.cjs');

const SRC_CAP = 120;
const STOPLIST_FLOOR = new Set(['main', 'run', 'init', 'setup', 'test', 'get', 'set', 'make']);
const SOURCE_RE = /\.(c|m)?jsx?$|\.tsx?$/;
const SKIP_PATH_RE = /(^|\/)(node_modules|references|dist|bundles?)\//;

function usage(message) {
  process.stderr.write(`detect: ${message}\n`);
  process.exit(2);
}

const options = { repo: '.', mode: null, base: null, label: null, indexes: [], passes: new Set(['name', 'idiom']) };
const argv = process.argv.slice(2);
for (let i = 0; i < argv.length; i += 1) {
  const arg = argv[i];
  const next = () => (i + 1 < argv.length ? argv[++i] : usage(`${arg} needs a value`));
  if (arg === '--repo') options.repo = next();
  else if (arg === '--base') (options.mode = 'base'), (options.base = next());
  else if (arg === '--staged') options.mode = 'staged';
  else if (arg === '--worktree') options.mode = 'worktree';
  else if (arg === '--stdin') (options.mode = 'stdin'), (options.label = next());
  else if (arg === '--index') options.indexes.push(next());
  else if (arg === '--passes') options.passes = new Set(next().split(','));
  else usage(`unknown argument ${arg}`);
}

function git(args, { allowFail = false } = {}) {
  try {
    return execFileSync('git', ['-C', options.repo, ...args], {
      encoding: 'utf8',
      maxBuffer: 256 * 1024 * 1024,
      stdio: ['ignore', 'pipe', 'ignore'],
    });
  } catch (error) {
    if (allowFail) return null;
    process.stderr.write(`detect: git ${args.join(' ')} failed\n`);
    process.exit(3);
  }
  return null;
}

// --- the diff: [{ file, content, added:Set<line> }] ---------------------------
function diffArgs() {
  if (options.mode === 'base') return [`${options.base}...HEAD`];
  if (options.mode === 'staged') return ['--staged'];
  return [];
}

function headContent(file) {
  if (options.mode === 'base') return git(['show', `HEAD:${file}`], { allowFail: true });
  if (options.mode === 'staged') return git(['show', `:${file}`], { allowFail: true });
  try {
    return fs.readFileSync(path.join(options.repo, file), 'utf8');
  } catch {
    return null;
  }
}

function addedLines(file) {
  const out = git(['diff', '-U0', '--no-color', ...diffArgs(), '--', file], { allowFail: true }) || '';
  const added = new Set();
  for (const match of out.matchAll(/^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@/gm)) {
    const start = Number(match[1]);
    const count = match[2] === undefined ? 1 : Number(match[2]);
    for (let n = start; n < start + count; n += 1) added.add(n);
  }
  return added;
}

function changedFiles() {
  if (options.mode === 'stdin') {
    const content = fs.readFileSync(0, 'utf8');
    const lines = content.split('\n');
    return [{ file: options.label, content, added: new Set(lines.map((_, n) => n + 1)) }];
  }
  if (!options.mode) {
    const staged = git(['diff', '--staged', '--name-only'], { allowFail: true }) || '';
    options.mode = staged.trim() ? 'staged' : 'worktree';
  }
  const names = (git(['diff', '--name-only', '--diff-filter=d', ...diffArgs()]) || '')
    .split('\n')
    .filter(Boolean)
    .filter(f => SOURCE_RE.test(f) && !/\.d\.(c|m)?ts$/.test(f) && !SKIP_PATH_RE.test(f));
  const files = [];
  for (const file of names) {
    const content = headContent(file);
    if (content === null) continue;
    files.push({ file, content, added: addedLines(file) });
  }
  return files;
}

// --- the index -----------------------------------------------------------------
function loadIndexes() {
  const rows = [];
  const deps = new Map();
  options.indexes.forEach((spec, position) => {
    const eq = spec.indexOf('=');
    const tsv = eq < 0 ? spec : spec.slice(0, eq);
    const repoRoot = eq < 0 ? options.repo : spec.slice(eq + 1);
    let text;
    try {
      text = fs.readFileSync(tsv, 'utf8');
    } catch {
      process.stderr.write(`detect: cannot read index ${tsv}\n`);
      process.exit(3);
    }
    const commit = (text.match(/^# repo=\S+ commit=(\S+)/m) || [])[1] || 'HEAD';
    for (const line of text.split('\n')) {
      if (!line) continue;
      const cols = line.split('\t');
      if (cols[0] === '#dep') {
        deps.set(cols[1], new Set((cols[2] || '').split(' ').filter(Boolean)));
        continue;
      }
      if (line.startsWith('#')) continue;
      const [name, specifier, pkg, def, kind, arity, shape, tokens, priv] = cols;
      rows.push({ name, specifier, package: pkg, def, kind, arity, shape, tokens, private: priv === '1', commit, repoRoot, external: position > 0 });
    }
  });
  return { rows, deps };
}

// --- helpers -----------------------------------------------------------------------
const cap = lines => lines.slice(0, SRC_CAP).join('\n');

const importsSpecifier = (content, specifier) =>
  content.split('\n').some(
    line =>
      (/^\s*(import|export)\s/.test(line) || /\sfrom\s*["']/.test(line) || /(require|import)\s*\(\s*["']/.test(line)) &&
      line.includes(specifier),
  );

const isCommentLine = line => /^\s*(\/\/|\/\*|\*|#)/.test(line);

function exemptMarkers(content) {
  const head = content.split('\n').slice(0, 5).join('\n');
  return {
    all: head.includes('build-vs-buy-exempt'),
    idiom: head.includes('prefer-endo-primitives-exempt'),
  };
}

function loadIdioms() {
  const file = path.join(__dirname, 'idioms.tsv');
  return fs
    .readFileSync(file, 'utf8')
    .split('\n')
    .filter(line => line && !line.startsWith('#'))
    .map(line => {
      const [id, regex, specifier, exportName, waiver, description] = line.split('\t');
      return { id, re: new RegExp(regex), specifier, exportName: exportName === '-' ? null : exportName, waiver, description };
    });
}

// The nearest package.json above `file` in the worktree: { name, deps:Set }.
const pkgCache = new Map();
function localPackage(file) {
  if (options.mode === 'stdin') return null;
  let dir = path.resolve(options.repo, path.dirname(file));
  const top = path.resolve(options.repo);
  while (dir.startsWith(top)) {
    if (pkgCache.has(dir)) return pkgCache.get(dir);
    const manifest = path.join(dir, 'package.json');
    if (fs.existsSync(manifest)) {
      let record = null;
      try {
        const pkg = JSON.parse(fs.readFileSync(manifest, 'utf8'));
        record = {
          name: pkg.name || null,
          deps: new Set(Object.keys({ ...pkg.dependencies, ...pkg.peerDependencies, ...pkg.devDependencies })),
        };
      } catch {
        record = null;
      }
      pkgCache.set(dir, record);
      return record;
    }
    if (dir === top) break;
    dir = path.dirname(dir);
  }
  return null;
}

function transitiveDeps(deps, start) {
  const seen = new Set();
  const stack = [...(deps.get(start) || [])];
  while (stack.length) {
    const name = stack.pop();
    if (seen.has(name)) continue;
    seen.add(name);
    for (const d of deps.get(name) || []) stack.push(d);
  }
  return seen;
}

// The provider declaration's source (with its leading JSDoc) and AST node.
const providerCache = new Map();
function providerSource(row) {
  const key = `${row.repoRoot}\0${row.commit}\0${row.def}`;
  if (providerCache.has(key)) return providerCache.get(key);
  const colon = row.def.lastIndexOf(':');
  const file = row.def.slice(0, colon);
  const line = Number(row.def.slice(colon + 1));
  let text = null;
  try {
    text = execFileSync('git', ['-C', row.repoRoot, 'show', `${row.commit}:${file}`], {
      encoding: 'utf8',
      maxBuffer: 64 * 1024 * 1024,
      stdio: ['ignore', 'pipe', 'ignore'],
    });
  } catch {
    text = null;
  }
  let result = { src: '', fn: null };
  if (text !== null) {
    const lines = text.split('\n');
    const program = lib.parse(text, file);
    const decl = program && lib.localFunctionDeclarations(program).find(d => d.name === row.name && d.line === line);
    let start = line;
    while (start > 1 && /^\s*(\/\*\*|\*|\*\/|\/\/)/.test(lines[start - 2])) start -= 1;
    const end = decl ? decl.endLine : line;
    result = { src: cap(lines.slice(start - 1, end)), fn: decl ? decl.fn : null };
  }
  providerCache.set(key, result);
  return result;
}

// --- the passes ----------------------------------------------------------------------
function main() {
  const idioms = loadIdioms();
  const { rows, deps } = options.passes.has('name') ? loadIndexes() : { rows: [], deps: new Map() };
  const fnRows = rows.filter(r => r.kind === 'function' || r.kind === 'class' || r.kind === 'const-function');
  const byName = new Map();
  const packagesByName = new Map();
  for (const row of rows) {
    if (!packagesByName.has(row.name)) packagesByName.set(row.name, new Set());
    packagesByName.get(row.name).add(row.package);
  }
  for (const row of fnRows) {
    if (!byName.has(row.name)) byName.set(row.name, []);
    byName.get(row.name).push(row);
  }
  const generic = name => STOPLIST_FLOOR.has(name) || (packagesByName.get(name) || new Set()).size >= 3;
  const distinctive = name =>
    lib.segments(name).length >= 2 && !generic(name) && (packagesByName.get(name) || new Set()).size === 1;

  const out = [];
  for (const { file, content, added } of changedFiles()) {
    const exempt = exemptMarkers(content);
    if (exempt.all) continue;
    const lines = content.split('\n');

    // Idiom pass: every matching added line, remembered for strength too.
    const idiomLines = [];
    const emitted = new Set();
    lines.forEach((text, n) => {
      if (!added.has(n + 1) || isCommentLine(text)) return;
      for (const idiom of idioms) {
        if (!idiom.re.test(text)) continue;
        idiomLines.push({ line: n + 1, idiom });
        if (!options.passes.has('idiom') || exempt.idiom) continue;
        if (idiom.waiver === 'import' && importsSpecifier(content, idiom.specifier)) continue;
        const key = `${idiom.specifier}\0${idiom.description}`;
        if (emitted.has(key)) continue;
        emitted.add(key);
        out.push({
          pass: 'idiom',
          file,
          line: n + 1,
          id: idiom.id,
          name: idiom.exportName,
          description: idiom.description,
          advice: idiom.waiver === 'none' && idiom.exportName ? `${idiom.exportName} from ${idiom.specifier}` : idiom.specifier,
          provider: { specifier: idiom.specifier, export: idiom.exportName },
          waiver: null,
        });
      }
    });

    if (!options.passes.has('name') || fnRows.length === 0) continue;
    const program = lib.parse(content, file);
    if (!program) continue;
    const local = localPackage(file);
    for (const decl of lib.localFunctionDeclarations(program)) {
      if (!added.has(decl.line)) continue;
      const candidates = byName.get(decl.name);
      if (!candidates) continue;
      if (local && candidates.some(r => r.package === local.name)) continue; // the definition itself
      const judged = candidates
        .map(row => {
          let blocked = null;
          if (local) {
            if (local.name && transitiveDeps(deps, row.package).has(local.name)) blocked = 'dependency-cycle';
            else if (row.private && !local.deps.has(row.package)) blocked = 'private-provider';
            else if (row.external && !local.deps.has(row.package)) blocked = 'provider-not-a-dependency';
          }
          return { row, blocked };
        })
        .sort((a, b) => (a.blocked ? 1 : 0) - (b.blocked ? 1 : 0) || a.row.specifier.length - b.row.specifier.length);
      const { row, blocked } = judged[0];
      const provider = providerSource(row);
      const localShape = lib.shapeOf(decl.fn);
      const similarity = provider.fn ? lib.jaccard(decl.fn, provider.fn) : 0;
      const idiomNamesIt = idiomLines.some(
        h => h.idiom.exportName === decl.name && h.line >= decl.line && h.line <= decl.endLine,
      );
      let strength;
      let reason;
      if (blocked) {
        strength = 'blocked';
        reason = blocked;
      } else if (distinctive(decl.name) && (localShape === row.shape || similarity >= 0.6 || idiomNamesIt)) {
        strength = 'strong';
        reason = localShape === row.shape ? 'shape-equal' : similarity >= 0.6 ? `jaccard=${similarity.toFixed(2)}` : 'idiom';
      } else {
        strength = 'weak';
        reason = distinctive(decl.name) ? `jaccard=${similarity.toFixed(2)}` : 'generic-name';
      }
      const above = decl.line >= 2 ? lines[decl.line - 2] : '';
      const waiverMatch = above.match(/\/\/\s*build-not-buy:\s*(.*)$/);
      out.push({
        pass: 'name',
        file,
        line: decl.line,
        name: decl.name,
        strength,
        reason,
        provider: { specifier: row.specifier, export: row.name, package: row.package, def: row.def },
        local_src: cap(lines.slice(decl.line - 1, decl.endLine)),
        provider_src: provider.src,
        waiver: waiverMatch ? waiverMatch[1].trim() || '(no reason given)' : null,
        local_shape: localShape,
        provider_shape: row.shape,
      });
    }
  }
  for (const hit of out) process.stdout.write(`${JSON.stringify(hit)}\n`);
}

main();
