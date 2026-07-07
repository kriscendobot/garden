// Minimal driver for the prebuilt agoric xsnap-worker, reimplementing just the
// fd-3/fd-4 netstring protocol from @agoric/xsnap's xsnap.js.
// Detects the uncatchable metered stack overflow as process exit code 12.
import { spawn } from 'node:child_process';

const WORKER =
  process.env.XSNAP_WORKER ||
  '/home/kris/.cache/agoric-sdk/xsnap/prebuilt/0.14.2/bundle/dist/linux-x64/release/xsnap-worker';

const OK = '.'.charCodeAt(0);
const ERROR = '!'.charCodeAt(0);
const QUERY = '?'.charCodeAt(0);
const OK_SEPARATOR = 1;

const enc = new TextEncoder();
const dec = new TextDecoder();

// netstring frame: <len>:<payload>,
function frame(bytes) {
  const head = enc.encode(`${bytes.length}:`);
  const out = new Uint8Array(head.length + bytes.length + 1);
  out.set(head, 0);
  out.set(bytes, head.length);
  out[out.length - 1] = ','.charCodeAt(0);
  return out;
}

// Parse netstrings out of an accumulating buffer.
function makeReader(onMessage) {
  let buf = Buffer.alloc(0);
  return chunk => {
    buf = Buffer.concat([buf, chunk]);
    for (;;) {
      const colon = buf.indexOf(0x3a); // ':'
      if (colon < 0) return;
      const len = Number(buf.subarray(0, colon).toString('ascii'));
      const start = colon + 1;
      const end = start + len;
      if (buf.length < end + 1) return; // need payload + trailing comma
      const payload = buf.subarray(start, end);
      buf = buf.subarray(end + 1);
      onMessage(Uint8Array.from(payload));
    }
  };
}

export async function makeWorker({ meteringLimit = 0, name = 'w', parserBufferSize } = {}) {
  const args = [name];
  if (meteringLimit) args.push('-l', `${meteringLimit}`);
  if (parserBufferSize) args.push('-s', `${parserBufferSize}`);
  const child = spawn(WORKER, args, {
    stdio: ['ignore', 'inherit', 'inherit', 'pipe', 'pipe', 'ignore', 'ignore', 'ignore', 'ignore'],
  });
  const toXsnap = child.stdio[3];
  const fromXsnap = child.stdio[4];

  let exitInfo = null;
  const exited = new Promise(resolve => {
    child.once('exit', (code, signal) => {
      exitInfo = { code, signal };
      resolve(exitInfo);
    });
  });

  let pending = null; // {resolve}
  const reader = makeReader(msg => {
    if (!pending) return;
    const p = pending;
    if (msg[0] === OK) {
      const sep = msg.indexOf(OK_SEPARATOR, 1);
      const reply = msg.subarray(sep < 0 ? 1 : sep + 1);
      pending = null;
      p.resolve({ ok: true, reply: dec.decode(reply) });
    } else if (msg[0] === ERROR) {
      pending = null;
      p.resolve({ ok: false, error: dec.decode(msg.subarray(1)) });
    } else if (msg[0] === QUERY) {
      // No command handler installed; ignore (our scripts don't issueCommand).
    } else {
      pending = null;
      p.resolve({ ok: false, error: `unknown msg <<${dec.decode(msg)}>>` });
    }
  });
  fromXsnap.on('data', reader);

  async function evaluate(code) {
    if (exitInfo) return { ok: false, exited: exitInfo };
    const done = new Promise(resolve => {
      pending = { resolve };
    });
    toXsnap.write(Buffer.from(frame(enc.encode(`e${code}`))));
    // Race the reply against an unexpected worker exit (the overflow path).
    const res = await Promise.race([
      done,
      exited.then(info => ({ ok: false, exited: info })),
    ]);
    return res;
  }

  function close() {
    try { child.kill(); } catch {}
  }

  return { evaluate, close, exited, get exitInfo() { return exitInfo; } };
}

// Classify a worker result.
export function classify(res) {
  if (res.exited) {
    const c = res.exited.code;
    if (c === 12) return 'STACK_OVERFLOW';
    if (c === 11) return 'OOM';
    if (c === 17) return 'TOO_MUCH_COMPUTATION';
    return `EXIT_${c}_sig_${res.exited.signal}`;
  }
  if (res.ok) return 'OK';
  return 'JS_ERROR';
}
