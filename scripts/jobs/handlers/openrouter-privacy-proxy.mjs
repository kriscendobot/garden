#!/usr/bin/env node
// Fail-closed loopback adapter for Codex's OpenRouter provider. Codex custom
// providers can set a base URL and headers, but cannot add OpenRouter's provider
// preferences to each JSON body. This adapter owns that last hop and overwrites
// both privacy controls on every body-bearing request before forwarding it.

import fs from 'node:fs';
import http from 'node:http';
import https from 'node:https';

const [upstreamText, readyFile] = process.argv.slice(2);
if (!upstreamText || !readyFile) {
  process.stderr.write('usage: openrouter-privacy-proxy.mjs <upstream-base-url> <ready-file>\n');
  process.exit(2);
}

const upstream = new URL(upstreamText);
const loopbackHttp =
  upstream.protocol === 'http:' &&
  (upstream.hostname === '127.0.0.1' || upstream.hostname === '::1' || upstream.hostname === 'localhost');
if (upstream.protocol !== 'https:' && !(process.env.GARDEN_TEST === '1' && loopbackHttp)) {
  process.stderr.write('OpenRouter privacy proxy requires an HTTPS upstream\n');
  process.exit(2);
}

const upstreamBasePath = upstream.pathname.replace(/\/$/, '');
const transport = upstream.protocol === 'https:' ? https : http;

const server = http.createServer((request, response) => {
  const chunks = [];
  request.on('data', chunk => chunks.push(chunk));
  request.on('error', () => response.destroy());
  request.on('end', () => {
    const original = Buffer.concat(chunks);
    let body = original;

    if (original.length > 0) {
      const encoding = request.headers['content-encoding'];
      if (encoding && encoding !== 'identity') {
        response.writeHead(415, { 'content-type': 'text/plain' });
        response.end('encoded request bodies are not accepted');
        return;
      }
      let payload;
      try {
        payload = JSON.parse(original.toString('utf8'));
      } catch {
        response.writeHead(400, { 'content-type': 'text/plain' });
        response.end('request body must be JSON');
        return;
      }
      if (payload === null || Array.isArray(payload) || typeof payload !== 'object') {
        response.writeHead(400, { 'content-type': 'text/plain' });
        response.end('request body must be a JSON object');
        return;
      }
      const preferences =
        payload.provider !== null && !Array.isArray(payload.provider) && typeof payload.provider === 'object'
          ? payload.provider
          : {};
      payload.provider = {
        ...preferences,
        data_collection: 'deny',
        zdr: true,
      };
      body = Buffer.from(JSON.stringify(payload));
    }

    // Never honor an absolute-form request target from a loopback client: the
    // bearer header must be able to reach only the configured OpenRouter origin.
    const incoming = new URL(request.url ?? '/', 'http://127.0.0.1');
    if (
      incoming.pathname !== upstreamBasePath &&
      !incoming.pathname.startsWith(`${upstreamBasePath}/`)
    ) {
      response.writeHead(404, { 'content-type': 'text/plain' });
      response.end('request path is outside the OpenRouter API base');
      return;
    }
    const target = new URL(upstream.origin);
    target.pathname = incoming.pathname;
    target.search = incoming.search;
    const headers = { ...request.headers };
    delete headers.host;
    delete headers.connection;
    delete headers['content-length'];
    delete headers['transfer-encoding'];
    if (body.length > 0) {
      headers['content-length'] = String(body.length);
      headers['content-type'] = 'application/json';
    }

    const outbound = transport.request(
      target,
      { method: request.method, headers },
      upstreamResponse => {
        response.writeHead(upstreamResponse.statusCode ?? 502, upstreamResponse.headers);
        upstreamResponse.pipe(response);
      },
    );
    outbound.on('error', () => {
      if (!response.headersSent) {
        response.writeHead(502, { 'content-type': 'text/plain' });
      }
      response.end('OpenRouter upstream unavailable');
    });
    if (body.length > 0) outbound.write(body);
    outbound.end();
  });
});

server.on('error', error => {
  process.stderr.write(`OpenRouter privacy proxy failed: ${error.message}\n`);
  process.exit(1);
});

server.listen(0, '127.0.0.1', () => {
  const address = server.address();
  if (address === null || typeof address === 'string') process.exit(1);
  fs.writeFileSync(readyFile, `http://127.0.0.1:${address.port}${upstreamBasePath}\n`, {
    mode: 0o600,
  });
});

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, () => server.close(() => process.exit(0)));
}
