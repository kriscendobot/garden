---
title: §readPowers-pattern via @endo/compartment-mapper
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

```js
const readPowers = makeReadPowers({ fs, url, crypto });
```

§Three-named-host-modules-bundled-as-powers (fs + url + crypto). §The-powers-shape-is-the-cross-cutting-API-surface: every function that needs to read files takes powers as a parameter.

```js
const powers = /** @type {typeof readPowers & SharedPowers} */ ({
  ...readPowers,
  ...grantedPowers,
});
```

§Spread-default-powers-then-spread-granted-powers — §later-spread-wins-on-collision. §The-caller-can-override-individual-powers (e.g., a custom fs implementation for testing or a sandboxed fs).

§Borrowable-pattern: §read-powers-as-a-bundled-capability-shape + §caller-can-override-individual-powers. §Sibling to cycles 196 endoclaw, 200 worker-rust-xs, 218 familiar-chat-weblet-hosting — all designs use §capability-shapes-as-the-parameter-passing-discipline.
