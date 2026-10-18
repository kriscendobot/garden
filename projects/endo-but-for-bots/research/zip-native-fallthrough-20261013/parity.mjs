// Differential parity harness: @endo/zip (pure JS) vs node:zlib ZIP API (Node >= 26.8).
// Usage: node parity.mjs <path-to-packages/zip>   (writes JSON-ish lines to stdout)
import * as zlib from 'node:zlib';
import { readFileSync } from 'node:fs';
import { pathToFileURL } from 'node:url';

const zipDir = process.argv[2];
const { ZipReader, ZipWriter } = await import(pathToFileURL(`${zipDir}/index.js`).href);
const te = new TextEncoder();
const hasNative = typeof zlib.ZipBuffer === 'function';
const out = [];
const log = (kind, name, o) => { out.push({ kind, name, ...o }); };
const hex = b => Buffer.from(b).toString('hex');
const bufEq = (a, b) => Buffer.compare(Buffer.from(a), Buffer.from(b)) === 0;
const firstDiff = (a, b) => { const n = Math.min(a.length, b.length); for (let i = 0; i < n; i++) if (a[i] !== b[i]) return i; return a.length === b.length ? -1 : n; };
const err = e => ({ code: e.code, message: String(e.message).slice(0, 140) });
const deflateNow = b => new Uint8Array(zlib.deflateRawSync(b));
const inflateNow = b => new Uint8Array(zlib.inflateRawSync(b));

// ---------- WRITE parity ----------
const writeCases = [
  { name: 'store/no-date', files: [['a.txt', 'hello\n', {}]], method: 'store' },
  { name: 'store/even-second', files: [['a.txt', 'hello\n', { date: new Date(Date.UTC(2020, 0, 2, 3, 4, 6)) }]], method: 'store' },
  { name: 'store/odd-second', files: [['a.txt', 'hello\n', { date: new Date(Date.UTC(2020, 0, 2, 3, 4, 7)) }]], method: 'store' },
  { name: 'store/mode-755+comment', files: [['bin/x', '#!/bin/sh\n', { mode: 0o755, comment: 'c', date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'store' },
  { name: 'store/multi-order', files: [['z', 'z', { date: new Date(Date.UTC(2020, 0, 2)) }], ['a', 'a', { date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'store' },
  { name: 'deflate/compressible', files: [['a.txt', 'x'.repeat(4096), { date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'deflate' },
  { name: 'deflate/incompressible', files: [['r.bin', Buffer.from(Array.from({ length: 256 }, (_, i) => (i * 167 + 13) & 255)), { date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'deflate' },
  { name: 'store/empty-file', files: [['e', '', { date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'store' },
  { name: 'store/utf8-name', files: [['é/ü.txt', 'x', { date: new Date(Date.UTC(2020, 0, 2)) }]], method: 'store' },
];
const asBytes = c => (typeof c === 'string' ? te.encode(c) : new Uint8Array(c));
const endoWrite = c => {
  const w = new ZipWriter(c.method === 'deflate' ? { deflateNow } : {});
  for (const [n, d, o] of c.files) w.setNow(n, asBytes(d), o);
  return w.snapshot();
};
const nativeWrite = c => {
  const entries = c.files.map(([n, d, o]) => zlib.ZipEntry.createSync(n, Buffer.from(asBytes(d)), {
    method: c.method, mode: o.mode ?? 0o644, comment: o.comment ?? '',
    // Endo's "no date" means DOS time 0; the closest native expression is an explicit date.
    ...(o.date ? { modified: o.date } : {}),
  }));
  return Buffer.concat([...zlib.createZipArchiveSync(entries)]);
};
if (hasNative) {
  for (const c of writeCases) {
    let e, n;
    try { e = endoWrite(c); } catch (x) { log('write', c.name, { endoError: err(x) }); continue; }
    try { n = nativeWrite(c); } catch (x) { log('write', c.name, { nativeError: err(x) }); continue; }
    // Cross-read: can each side read the other's output, and do contents agree?
    let crossEndoReadsNative, crossNativeReadsEndo;
    try { const r = new ZipReader(n, { inflateNow }); crossEndoReadsNative = c.files.every(([nm, d]) => bufEq(r.getNow(nm), asBytes(d))); } catch (x) { crossEndoReadsNative = err(x); }
    try { const r = new zlib.ZipBuffer(Buffer.from(e)); crossNativeReadsEndo = c.files.every(([nm, d]) => bufEq(r.get(nm).contentSync(), asBytes(d))); } catch (x) { crossNativeReadsEndo = err(x); }
    log('write', c.name, { bytesEqual: bufEq(e, n), endoLen: e.length, nativeLen: n.length, firstDiff: firstDiff(e, n), crossEndoReadsNative, crossNativeReadsEndo });
  }
  // Determinism: native default timestamp is "now".
  const a = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a', Buffer.from('a'), { method: 'store' })])]);
  await new Promise(r => setTimeout(r, 2100));
  const b = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a', Buffer.from('a'), { method: 'store' })])]);
  log('write', 'native-default-date-determinism', { bytesEqual: bufEq(a, b) });
  const e1 = new ZipWriter(); e1.setNow('a', te.encode('a')); const e2 = new ZipWriter(); e2.setNow('a', te.encode('a'));
  log('write', 'endo-default-date-determinism', { bytesEqual: bufEq(e1.snapshot(), e2.snapshot()) });
}

// ---------- READ parity (success and failure) ----------
const base = (() => { const w = new ZipWriter(); w.setNow('a.txt', te.encode('hello\n'), { date: new Date(Date.UTC(2020, 0, 2)) }); w.setNow('b/c.txt', te.encode('world\n'), { mode: 0o600, date: new Date(Date.UTC(2021, 5, 6, 7, 8, 10)) }); return Buffer.from(w.snapshot()); })();
const patch = (buf, f) => { const b = Buffer.from(buf); f(b); return b; };
const eocd = b => b.lastIndexOf(Buffer.from([0x50, 0x4b, 0x05, 0x06]));
const cdir = b => b.indexOf(Buffer.from([0x50, 0x4b, 0x01, 0x02]));
const corpus = {
  'endo-written': base,
  'repo-fixture': readFileSync(`${zipDir}/test/_fixture.zip`),
  'empty-buffer': Buffer.alloc(0),
  'garbage': Buffer.from('this is not a zip archive at all, not even close.'),
  'truncated-half': base.subarray(0, base.length >> 1),
  'truncated-last-byte': base.subarray(0, base.length - 1),
  'archive-comment': patch(Buffer.concat([base, Buffer.from('hi')]), b => b.writeUInt16LE(2, eocd(b) + 20)),
  'trailing-junk': Buffer.concat([base, Buffer.from('junk')]),
  'sfx-prefix': Buffer.concat([Buffer.from('#!prefix\n'), base]),
  'crc-mismatch': patch(base, b => { const i = cdir(b); b.writeUInt32LE(0xdeadbeef, i + 16); b.writeUInt32LE(0xdeadbeef, 14); }),
  'crc-mismatch-central-only': patch(base, b => b.writeUInt32LE(0xdeadbeef, cdir(b) + 16)),
  'local-central-name-mismatch': patch(base, b => { b[30] = 'X'.charCodeAt(0); }),
  'encrypted-flag': patch(base, b => { b.writeUInt16LE(1, 6); b.writeUInt16LE(1, cdir(b) + 8); }),
  'unsupported-method-12': patch(base, b => { b.writeUInt16LE(12, 8); b.writeUInt16LE(12, cdir(b) + 10); }),
  'declared-huge-size': patch(base, b => { b.writeUInt32LE(0x7fffffff, 22); b.writeUInt32LE(0x7fffffff, cdir(b) + 24); }),
  'eocd-count-too-high': patch(base, b => { const i = eocd(b); b.writeUInt16LE(9, i + 8); b.writeUInt16LE(9, i + 10); }),
  'cdir-offset-out-of-range': patch(base, b => b.writeUInt32LE(0x00ffffff, eocd(b) + 16)),
  'path-traversal-name': (() => { const w = new ZipWriter(); w.setNow('../../etc/passwd', te.encode('x')); return Buffer.from(w.snapshot()); })(),
  'duplicate-names': (() => { const w1 = new ZipWriter(); w1.setNow('a', te.encode('1')); w1.setNow('b', te.encode('2')); const b = Buffer.from(w1.snapshot()); let i = -1; while ((i = b.indexOf(Buffer.from('b'), i + 1)) !== -1) { if (b[i - 1] === 0 || b.readUInt32LE(i - 30) === 0x04034b50 || b.readUInt32LE(i - 46) === 0x02014b50) b[i] = 'a'.charCodeAt(0); } return b; })(),
  'non-utf8-name-cp437': patch((() => { const w = new ZipWriter(); w.setNow('é', te.encode('x')); return Buffer.from(w.snapshot()); })(), b => { /* replace 2-byte UTF-8 é (c3 a9) with 0x82 0x41 (CP437 é + 'A') in both headers */ let i = -1; while ((i = b.indexOf(Buffer.from([0xc3, 0xa9]), i + 1)) !== -1) { b[i] = 0x82; b[i + 1] = 0x41; } }),
};
if (hasNative) {
  corpus['native-written-store'] = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a.txt', Buffer.from('hello\n'), { method: 'store', modified: new Date(Date.UTC(2020, 0, 2)) })])]);
  corpus['native-written-deflate'] = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a.txt', Buffer.from('x'.repeat(4096)), { method: 'deflate', modified: new Date(Date.UTC(2020, 0, 2)) })])]);
  corpus['native-written-zstd'] = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a.txt', Buffer.from('x'.repeat(4096)), { method: 'zstd', modified: new Date(Date.UTC(2020, 0, 2)) })])]);
  corpus['native-written-dir+symlink'] = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('d/', Buffer.alloc(0), { modified: new Date(Date.UTC(2020, 0, 2)) }), zlib.ZipEntry.createSymlink('d/l', 'target', { modified: new Date(Date.UTC(2020, 0, 2)) }), zlib.ZipEntry.createSync('d/f', Buffer.from('f'), { method: 'store', modified: new Date(Date.UTC(2020, 0, 2)) })])]);
  corpus['native-written-archive-comment'] = Buffer.concat([...zlib.createZipArchiveSync([zlib.ZipEntry.createSync('a', Buffer.from('a'), { method: 'store', modified: new Date(Date.UTC(2020, 0, 2)) })], 'comment')]);
}
const endoRead = buf => {
  const r = new ZipReader(new Uint8Array(buf), { inflateNow, checkCrc32: true });
  return [...r.files.keys()].map(n => { const s = r.stat(n); let c; try { c = hex(r.getNow(n)).slice(0, 24); } catch (x) { c = { error: err(x) }; } return { n, mode: s.mode.toString(8), date: s.date?.toISOString?.(), c }; });
};
const nativeRead = buf => {
  const z = new zlib.ZipBuffer(Buffer.from(buf));
  return [...z.values()].filter(e => e.isFile).map(e => { let c; try { c = hex(e.contentSync()).slice(0, 24); } catch (x) { c = { error: err(x) }; } return { n: e.name, mode: e.mode.toString(8), date: e.modified.toISOString(), c, ...(e.isSymlink ? { symlink: true } : {}) }; });
};
for (const [name, buf] of Object.entries(corpus)) {
  let e, n;
  try { e = { ok: endoRead(buf) }; } catch (x) { e = { error: err(x) }; }
  if (hasNative) { try { n = { ok: nativeRead(buf) }; } catch (x) { n = { error: err(x) }; } }
  const outcome = !n ? 'endo-only' : (!!e.ok === !!n.ok ? (e.ok ? (JSON.stringify(e.ok) === JSON.stringify(n.ok) ? 'SAME' : 'BOTH-OK-DIFFER') : 'BOTH-REJECT') : (e.ok ? 'ENDO-ACCEPTS-NATIVE-REJECTS' : 'NATIVE-ACCEPTS-ENDO-REJECTS'));
  log('read', name, { outcome, endo: e, native: n });
}
for (const o of out) console.log(JSON.stringify(o));
