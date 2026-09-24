// lib.cjs — the shared, deterministic AST helpers behind the export-name index
// (scripts/jobs/export-index/) and the build-vs-buy detector (detect.cjs).
//
// It reuses the self-contained @babel/parser bundle the re-export policy already
// vendors (skills/re-export-deprecation-policy/vendor/), so neither caller ever
// installs a dependency at run time (designs/reexport-deprecation-policy-gauntlet.md,
// Decision 4). Everything here is a pure function of its input text.

'use strict';

const crypto = require('crypto');
const path = require('path');

const babel = require(path.join(
  __dirname,
  '..',
  're-export-deprecation-policy',
  'vendor',
  'babel-parser.cjs',
));

// Same plugin set as reexport-parse.cjs, so both detectors agree on what parses.
function pluginsFor(name) {
  const lower = name.toLowerCase();
  const common = [
    'importAssertions',
    'importAttributes',
    'decorators-legacy',
    'classProperties',
    'classPrivateProperties',
    'classPrivateMethods',
    'exportDefaultFrom',
    'exportNamespaceFrom',
    'dynamicImport',
    'topLevelAwait',
  ];
  if (/\.(ts|mts|cts)$/.test(lower)) return ['typescript', ...common];
  if (/\.tsx$/.test(lower)) return ['typescript', 'jsx', ...common];
  return ['jsx', ...common];
}

// Returns the Program AST, or null when the source does not parse at all.
function parse(source, filename) {
  try {
    return babel.parse(source, {
      sourceType: 'module',
      allowReturnOutsideFunction: true,
      allowAwaitOutsideFunction: true,
      errorRecovery: true,
      plugins: pluginsFor(filename),
    }).program;
  } catch {
    return null;
  }
}

const SKIP_KEYS = new Set([
  'loc',
  'start',
  'end',
  'extra',
  'leadingComments',
  'trailingComments',
  'innerComments',
  'range',
  'errors',
]);

// Depth-first walk; `visit(node, parent)` is called for every AST node.
function walk(node, visit, parent = null) {
  if (!node || typeof node.type !== 'string') return;
  visit(node, parent);
  for (const key of Object.keys(node)) {
    if (SKIP_KEYS.has(key)) continue;
    const value = node[key];
    if (Array.isArray(value)) {
      for (const child of value) walk(child, visit, node);
    } else if (value && typeof value.type === 'string') {
      walk(value, visit, node);
    }
  }
}

// The AST node-type sequence of a subtree. Identifier names and literal values
// never enter it, so it is alpha-normalized by construction.
function typeSequence(node) {
  const types = [];
  walk(node, n => types.push(n.type));
  return types;
}

function shapeOf(node) {
  return crypto
    .createHash('sha256')
    .update(typeSequence(node).join(' '))
    .digest('hex')
    .slice(0, 12);
}

function tokenCount(node) {
  return typeSequence(node).length;
}

// Normalized-token Jaccard: the sets of node-type trigrams of two subtrees.
function trigrams(types) {
  const set = new Set();
  for (let i = 0; i + 2 < types.length; i += 1) {
    set.add(`${types[i]}/${types[i + 1]}/${types[i + 2]}`);
  }
  return set;
}

function jaccard(leftNode, rightNode) {
  const left = trigrams(typeSequence(leftNode));
  const right = trigrams(typeSequence(rightNode));
  if (left.size === 0 && right.size === 0) return 1;
  let common = 0;
  for (const gram of left) if (right.has(gram)) common += 1;
  return common / (left.size + right.size - common);
}

const isFunctionValue = node =>
  !!node &&
  (node.type === 'ArrowFunctionExpression' ||
    node.type === 'FunctionExpression' ||
    node.type === 'ClassExpression');

// Classify a declaration node into the index `kind` vocabulary, returning
// { kind, fn } where `fn` is the node whose body carries the shape.
function classify(node) {
  if (node.type === 'FunctionDeclaration') return { kind: 'function', fn: node };
  if (node.type === 'ClassDeclaration') return { kind: 'class', fn: node };
  if (node.type === 'VariableDeclarator') {
    let init = node.init;
    // Unwrap `harden(() => ...)` / `freeze(...)`, a common Endo idiom.
    while (
      init &&
      init.type === 'CallExpression' &&
      init.arguments.length === 1 &&
      init.callee.type === 'Identifier' &&
      /^(harden|freeze)$/.test(init.callee.name)
    ) {
      init = init.arguments[0];
    }
    if (isFunctionValue(init)) {
      return { kind: init.type === 'ClassExpression' ? 'class' : 'const-function', fn: init };
    }
    return { kind: 'const', fn: null };
  }
  return null;
}

function arityOf(fn) {
  if (!fn || !Array.isArray(fn.params)) return '';
  return String(fn.params.length);
}

// Every function-valued declaration in a module, at any nesting depth:
// [{ name, line, endLine, kind, fn }]. Used by the detector's name pass.
function localFunctionDeclarations(program) {
  const found = [];
  walk(program, node => {
    let name = null;
    if ((node.type === 'FunctionDeclaration' || node.type === 'ClassDeclaration') && node.id) {
      name = node.id.name;
    } else if (node.type === 'VariableDeclarator' && node.id && node.id.type === 'Identifier') {
      name = node.id.name;
    }
    if (!name) return;
    const info = classify(node);
    if (!info || !info.fn) return;
    found.push({
      name,
      line: node.loc.start.line,
      endLine: node.loc.end.line,
      kind: info.kind,
      fn: info.fn,
    });
  });
  return found;
}

// Split a camelCase / snake_case / kebab identifier into its segments.
function segments(name) {
  return name
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2')
    .split(/[\s_$-]+/)
    .filter(Boolean);
}

module.exports = {
  parse,
  walk,
  classify,
  arityOf,
  shapeOf,
  tokenCount,
  jaccard,
  localFunctionDeclarations,
  segments,
};
