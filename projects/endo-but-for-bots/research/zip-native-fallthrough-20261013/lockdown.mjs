// Does node:zlib's ZIP API work after SES lockdown()? Usage: node lockdown.mjs <repo-root>
import { pathToFileURL } from 'node:url';
const root = process.argv[2];
await import(pathToFileURL(`${root}/packages/ses/index.js`).href);
lockdown({ errorTaming: 'unsafe', overrideTaming: 'severe' });
const zlib = await import('node:zlib');
try {
  const e = zlib.ZipEntry.createSync('a', Buffer.from('hello'), { method: 'deflate', modified: new Date(0) });
  const bytes = Buffer.concat([...zlib.createZipArchiveSync([e])]);
  const z = new zlib.ZipBuffer(bytes);
  console.log(JSON.stringify({ lockdown: 'ok', roundTrip: z.get('a').contentSync().toString(), frozenProto: Object.isFrozen(Object.prototype) }));
} catch (x) { console.log(JSON.stringify({ lockdown: 'error', message: String(x.message), stack: String(x.stack).split('\n').slice(0, 4) })); }
const { ZipWriter, ZipReader } = await import(pathToFileURL(`${root}/packages/zip/index.js`).href);
const w = new ZipWriter(); w.setNow('a', new TextEncoder().encode('hi'));
console.log(JSON.stringify({ endoUnderLockdown: new TextDecoder().decode(new ZipReader(w.snapshot()).getNow('a')) }));
