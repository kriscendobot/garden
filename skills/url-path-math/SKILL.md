---
created: 2026-08-06
updated: 2026-08-06
author: gardener
---

# Skill: URL path math

## The rule

In Endo JavaScript modules, prefer `new URL(...)` for path math rooted at a
module URL instead of importing Node's `path` module. URL-relative resolution is
portable and keeps the value in the URL domain until an API actually requires a
native filename.

For example, write:

```js
const workerUrl = new URL('./worker.js', import.meta.url);
const directoryPath = fileURLToPath(new URL('.', import.meta.url));
```

not:

```js
import path from 'node:path';

const workerPath = path.resolve(path.dirname(fileURLToPath(import.meta.url)), 'worker.js');
const directoryPath = path.dirname(fileURLToPath(import.meta.url));
```

Use a trailing-slash directory URL as the base for descendants:

```js
const assetsUrl = new URL('./assets/', import.meta.url);
const iconUrl = new URL('icon.svg', assetsUrl);
```

Convert with `fileURLToPath` only at the boundary where a Node API needs a
native path string. Do not convert to a string merely to do more path math.

## Scope and exceptions

This rule applies to Endo JavaScript and TypeScript code where the path is
relative to `import.meta.url` or another file URL. It does not forbid `node:path`
when the value starts as a native path string, such as a command-line argument,
an environment variable, or a filesystem result, or when the required operation
has no URL equivalent. The question is whether URL resolution serves the
operation, not whether a file happens to be involved.

Do not rewrite unrelated existing path code. Apply the rule when authoring or
editing the path calculation.

## Enforcement tiers

1. **Guidance.** This skill is indexed in `roles/COMMON.md` § House style and
   carried by the builder when authoring Endo code.
2. **Jury.** The [purist](../../roles/jurors/purist/AGENT.md) code-panel seat
   checks new `node:path` imports and `path.resolve` / `path.dirname` uses for
   URL-relative work that should remain URL math. Its panel-hints probe fires the
   seat on these added shapes.

This is intentionally a review rule, not a blocking pre-push gate. Determining
whether a native path already exists or a URL form serves a particular API needs
the surrounding code's context.

## Motivating incident

kriskowal's review on `endojs/endo-but-for-bots` PR #124, discussion
`r3548837460` (2026-08-06), requested that the prevailing Endo convention be
recorded and added to the reviewer burden. The precipitating code derived a
directory with `path.dirname(fileURLToPath(import.meta.url))`; the direct URL
form is `fileURLToPath(new URL('.', import.meta.url))`.
