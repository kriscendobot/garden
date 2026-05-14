---
title: Confining Node.js-style applications
source: docs/get-started.md
source_repo: endojs/endo
source_commit: 5fefef59b558ba6fb07aad42e3d089e49f81341a
source_date: 2025-12-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [getting-started, hardened-javascript, compartments, capability-security]
status: current
---

> Abstract: Walk-through of taking a normal Node.js application and confining it inside a Compartment, addressing how to provide bounded access to filesystem, network, and process resources via explicit endowments. Bridges the conceptual lockdown/Compartment material to a recognizable real-world target.

## Confining Node.js-style applications

Endo provides both high-level and low-level tools for creating and executing
bundles out of Node.js packages and their transitive dependencies.
The low-level tools give you more flexibility for storage and creating
new bundle formats.

In this example, we will use the high-level tools to create
and then execute a bundle in compartments.

First, create a plugin to bundle up. This is `hello.js`.

```js
console.log("Hello, World!");
```

```
npm install @endo/bundle-source
npm exec bundle-source hello.js > hello.json
```

You have now created a bundle called `hello.json` that, incidentally, is a JSON
envelope around a base64 encoded Zip file.

```
jq -r .endoZipBase64 hello.json | base64 -d > hello.zip
unzip -d hello hello.zip
```

The interior of the Zip file is a `compartment-map.json` that describes the
internal linkage of the bundle and then a file for each pre-compiled module.

```
Archive:  hello.zip
 extracting: hello/compartment-map.json
 extracting: hello/my-first-endo-v1.0.0/hello.js
```

> The pre-compiled module format is a regrettable aberration we look forward to
> removing when we the proposal for `Compartment` if the JavaScript standards
> committee sees fit to advance [our proposal](https://github.com/endojs/proposal-module-global) into the
> language.
> We have already made tremendous progress advancing other components of
> HardenedJS like `Object.freeze`, and `ModuleSource`.

To use the bundle, we need the corresponding Endo runtime.

```
npm install @endo/import-bundle
```

So, now we can run the bundle in compartments with another small program.

```js
import 'ses';
import helloBundle from './hello.json' with { type: 'json' };
import { importBundle } from '@endo/import-bundle';

lockdown();

await importBundle(helloBundle, {
  endowments: { console },
});
```


Source: [docs/get-started.md](https://github.com/endojs/endo/blob/5fefef59b558ba6fb07aad42e3d089e49f81341a/docs/get-started.md) at commit `5fefef59`.
