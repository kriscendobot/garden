// Is @endo/zip's existing deflate (CompressionStream 'deflate-raw') byte-identical to zlib.deflateRawSync on Node?
import * as zlib from 'node:zlib';
import { pathToFileURL } from 'node:url';
const { deflate } = await import(pathToFileURL(`${process.argv[2]}/deflate.js`).href);
const inputs = ['', 'x'.repeat(4096), 'hello world '.repeat(300)];
for (const s of inputs) { const b = new TextEncoder().encode(s); const a = await deflate(b); const n = zlib.deflateRawSync(b); console.log(JSON.stringify({ len: b.length, equal: Buffer.compare(Buffer.from(a), n) === 0 })); }
