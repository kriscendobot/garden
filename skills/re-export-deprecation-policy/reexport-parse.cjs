#!/usr/bin/env node
// reexport-parse.cjs — the deterministic Babel-backed parse helper the
// re-export-deprecation-policy probe and jury seat share. It reads a JavaScript /
// TypeScript module's source from STDIN and prints, one JSON object per line, a
// stable descriptor for each **value** qualified re-export (`export … from '…'`)
// the module declares. The probe parses the file's BEFORE and AFTER contents and
// takes the set difference of these descriptors (after − before) to isolate the
// *newly introduced* re-exports (@kriskowal's Decision 3 pipeline, stage b).
//
// It carries its own tooling: the parser is the self-contained @babel/parser
// CommonJS bundle vendored beside this file (`vendor/babel-parser.cjs`), so the
// garden never `npm install`s or fetches a dependency at run time (Decision 4).
//
// CONTRACT
//   Usage:  node reexport-parse.cjs <filename> < source
//   <filename> selects the parser plugin set by extension; source is read from
//   stdin (so the caller can feed `git show base:file` or the working tree).
//
//   stdout: zero or more lines, each a JSON object:
//     {"key":"<stable-descriptor>","line":<n>,"deprecated":<bool>,"form":"<form>"}
//     - key         identity independent of position, for the set difference.
//     - line        1-based line of the re-export in THIS source (for reporting).
//     - deprecated  true iff the node's immediately-preceding leading comment is a
//                   JSDoc block containing `@deprecated` (Decision 2).
//     - form        named | wildcard | namespace  (for the human message).
//
//   Type-only re-exports are SKIPPED (Decision 5): `export type { … } from`,
//   `export type * from`, and any specifier whose `exportKind === 'type'` is not
//   emitted; a statement with no value specifiers left produces no line.
//
//   Exit codes:
//     0  parsed (zero or more re-exports emitted)
//     3  the source could not be parsed — a reason on stderr; the caller treats
//        the file as undetermined rather than crashing the gate.
//     2  usage error (no filename).

'use strict';

const babel = require('./vendor/babel-parser.cjs');

const filename = process.argv[2];
if (!filename) {
  process.stderr.write('reexport-parse: usage: reexport-parse.cjs <filename> < source\n');
  process.exit(2);
}

function readStdin() {
  const chunks = [];
  const fd = 0;
  const buffer = Buffer.alloc(65536);
  const fs = require('fs');
  for (;;) {
    let bytesRead;
    try {
      bytesRead = fs.readSync(fd, buffer, 0, buffer.length, null);
    } catch (error) {
      if (error.code === 'EAGAIN') continue;
      if (error.code === 'EOF') break;
      throw error;
    }
    if (bytesRead === 0) break;
    chunks.push(Buffer.from(buffer.subarray(0, bytesRead)));
  }
  return Buffer.concat(chunks).toString('utf8');
}

// Plugin set by extension. TypeScript and Flow are mutually exclusive in Babel,
// so `.ts`/`.tsx`/`.mts`/`.cts` get the typescript plugin and everything else
// gets a broad JS set (flow stays off — endo is TS, not Flow). `errorRecovery`
// keeps a single stray syntax error from blinding us to the module's exports.
function pluginsFor(name) {
  const lower = name.toLowerCase();
  const isTs = /\.(ts|tsx|mts|cts)$/.test(lower);
  const isTsx = /\.tsx$/.test(lower);
  const isJsx = /\.(jsx)$/.test(lower);
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
  if (isTs) {
    return isTsx ? ['typescript', 'jsx', ...common] : ['typescript', ...common];
  }
  // A plain .js in the endo/JSX world may carry JSX; include it. `.mjs`/`.cjs`
  // rarely do but it is harmless to allow.
  return isJsx ? ['jsx', ...common] : ['jsx', ...common];
}

const source = readStdin();

let ast;
try {
  ast = babel.parse(source, {
    sourceType: 'module',
    allowReturnOutsideFunction: true,
    allowAwaitOutsideFunction: true,
    errorRecovery: true,
    attachComment: true,
    plugins: pluginsFor(filename),
  });
} catch (error) {
  process.stderr.write(`reexport-parse: parse failed for ${filename}: ${error.message}\n`);
  process.exit(3);
}

// A leading JSDoc `@deprecated` block immediately preceding the statement marks a
// compliant deprecation shim (Decision 2). We look at the LAST leading comment: a
// compliant shim writes the `/** @deprecated … */` block directly above the line.
function isDeprecated(node) {
  const comments = node.leadingComments;
  if (!comments || comments.length === 0) return false;
  const last = comments[comments.length - 1];
  return last.type === 'CommentBlock' && /@deprecated\b/.test(last.value);
}

function quote(value) {
  return String(value).replace(/\|/g, '\\|');
}

// One descriptor per VALUE re-export statement. The key is order-independent
// within a statement (specifiers sorted) so a reordering is not a "new" export.
function describe(node) {
  const line = node.loc ? node.loc.start.line : 0;
  const deprecated = isDeprecated(node);
  const source = node.source.value;

  if (node.type === 'ExportAllDeclaration') {
    // `export * from 'x'` (wildcard) or `export * as ns from 'x'` (namespace).
    // TypeScript marks a type-only `export type * from` with exportKind === 'type'.
    if (node.exportKind === 'type') return null;
    if (node.exported) {
      // `export * as ns from 'x'`
      return {
        key: `namespace|${quote(node.exported.name)}|${quote(source)}`,
        line,
        deprecated,
        form: 'namespace',
      };
    }
    return { key: `wildcard|${quote(source)}`, line, deprecated, form: 'wildcard' };
  }

  if (node.type === 'ExportNamedDeclaration' && node.source) {
    if (node.exportKind === 'type') return null; // `export type { … } from 'x'`
    // Keep only value specifiers; a per-specifier `type` (`export { type A, b }`)
    // is dropped, so a statement of only type specifiers yields no descriptor.
    const pairs = [];
    for (const specifier of node.specifiers) {
      if (specifier.exportKind === 'type') continue;
      if (specifier.type === 'ExportNamespaceSpecifier') {
        pairs.push(`*as ${specifier.exported.name}`);
        continue;
      }
      const localName =
        specifier.local && specifier.local.name ? specifier.local.name : '';
      const exportedName =
        specifier.exported &&
        (specifier.exported.name || specifier.exported.value);
      pairs.push(`${localName}:${exportedName}`);
    }
    if (pairs.length === 0) return null; // all specifiers were type-only
    pairs.sort();
    return {
      key: `named|${quote(source)}|${pairs.map(quote).join(',')}`,
      line,
      deprecated,
      form: 'named',
    };
  }

  return null;
}

for (const node of ast.program.body) {
  if (
    node.type === 'ExportAllDeclaration' ||
    (node.type === 'ExportNamedDeclaration' && node.source)
  ) {
    const descriptor = describe(node);
    if (descriptor) process.stdout.write(`${JSON.stringify(descriptor)}\n`);
  }
}
