---
title: Asset References — rejected alternatives (string, Symbol, `import.meta.resolve`, `module` syntax) and possible additions
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-asset-references/master/README.md
source_content_sha256: d40d635e77e9c8b21f811167e89e0339f06b7da6db76fc758d50e8173091f843
source_authors: [Sebastian Markbåge]
source_date: 2021-01-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The design space the proposal rejected, and the two additions it holds open. Four alternatives are argued down: an earlier `module Foo from "foo"` spelling (dropped because it conflates asset references with nested modules and still leaves non-module assets unserved, which is exactly the boundary the module-expressions and module-declarations proposals later took over); returning a **string** canonical path the way `require.resolve` does (leaks environment implementation details, cannot be canonicalized synchronously everywhere, invites manual path manipulation with "a number of security related bugs that can give access to arbitrary paths", and has no lifetime, so a temporary memory representation can never be collected, the flaw `URL.createObjectURL()` already suffers); a **Symbol** (avoids most of the string problems but has unclear garbage-collection semantics and forecloses ever adding instance fields or prototype methods); and `import.meta` passing or a host `import.meta.resolve`, which give no access to the host's actual resolution algorithm, are host-namespace-defined rather than portable, and do not encourage declaring the dependency statically where a bundler can see it. The additions held open are a bare `asset "foo";` resource hint with no binding, and a dynamic `import.resolve("./foo" + fileExtension)` form for genuinely dynamic URLs, with the static form kept primary because it guarantees bundlers and security scanners a static string.

## Possible additions

**Resource hint.** The identifier could be allowed to be excluded:

```js
asset "foo";
```

This is a no-op at runtime, but gives tooling such as static bundlers a hint that a resource will be needed even though it is acquired or initialized by other means.

**Dynamic asset resolution.** The static form should stay primary, mirroring the import statement, because it "provides bundlers and security scanners with a standard syntactic form that is guaranteed to receive a static string" and is easily explainable, unlike the non-standard semi-static requirements bundlers invent on top of dynamic import today. It also lets browsers and web-packaging tools preload further dependencies from an earlier hint. For genuinely dynamic URLs, an additional form could be added:

```js
let assetReference = import.resolve("./foo" + fileExtension);
```

## Alternative solutions

### `module` syntax

An earlier version of the proposal used the `module` contextual keyword instead, limited to asset references:

```js
module Foo from "foo";
```

That spelling would have offered some compatibility with the idea of nested modules (`module "foo" { … }`, `module Foo { }`, `module { Foo } from "foo"`). The proposal's own verdict: "It might be bad to conflate these problems and still leaves the a gap to support assets other than modules." The nested-module direction was later carried by the module expressions and module declarations proposals instead.

### String instead of an `AssetReference` object

Returning a fully resolved canonical path string, as `require.resolve` traditionally did, is rejected on four counts:

- It leaks too much about the environment's implementation details. Not every environment resolves to a URL path: webpack uses a generated ID, Node.js uses a file path that itself differs between Unix and Windows.
- Not every environment can synchronously resolve a canonical URL (Node.js needs to search the file system), so the return value cannot be guaranteed canonical at that point.
- "A string invites manual manipulation of the string path. This risks a number of security related bugs that can give access to arbitrary paths."
- A string has no lifetime associated with it. If the asset has a temporary memory representation, there is no way to clean it up on garbage collection, since the string can always be recreated. This is the problem `URL.createObjectURL()` suffers from.

### Symbol instead of an `AssetReference` object

A Symbol avoids most of the string problems and would have to be a new Symbol to avoid synchronous canonicalization. It is rejected because it "suffers from some unclear garbage collection semantics" (Symbols should not need garbage-collection semantics) and because it forecloses ever putting instance fields, properties, or prototype methods on these objects, which does not seem idiomatic to JavaScript.

### `import.meta`

Relative resolution is already possible today by passing `import.meta` to a library function where the host exposes a `url` field:

```js
import {load} from "library";
load(import.meta, "../relative/path");
```

This is insufficient because there is no access to the host loader's actual resolution algorithm. An earlier idea was to expose `resolve` on `import.meta` in host environments (`let Foo = import.meta.resolve("foo");`), but that namespace is host-defined and there is no portable way to express the dependency. Neither form encourages defining the dependency in a static way a bundler can use.

### Backup syntax

If the grammar does not allow the contextual keyword `asset`, `import asset Foo from "foo";` could be used instead, described as "a worst case scenario": people go to great lengths, including custom loaders and pseudo-syntax, to avoid unnecessarily long syntax for something as frequent as importing, which can end up undermining the feature's value as divergent pseudo-syntax emerges.

Source: [proposal-asset-references/README.md](https://github.com/tc39/proposal-asset-references/blob/master/README.md) at content sha256 `d40d635e`. Stage 1 (2018-11); retrieved 2026-07-29.
