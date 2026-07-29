---
title: Import Attributes — synopsis and motivation (the MIME-confusion problem)
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/README.md
source_content_sha256: f9ee63b07ed212445afc977b380df504aacd38fa0e6eb3066d725f7cbf73b32f
source_authors: [Sven Sauleau, Daniel Ehrenberg, Myles Borins, Dan Clark, Nicolò Ribaudo]
source_date: 2023-03-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: What Import Attributes is and the security problem that produced it. The proposal (Stage 4, formerly *Import Assertions*, before that *Module Attributes*) adds inline key-value syntax after a module specifier so an import can carry information beyond the specifier itself, the first application being non-executable module types such as JSON. The motivation is not ergonomics but a **MIME-confusion** hazard: Ryosuke Niwa (Apple) and Anne van Kesteren (Mozilla) argued that importing a module type that cannot execute code needs a syntactic marker, so a server that unexpectedly answers with a different Content-Type cannot cause code to be executed where data was expected. The obvious alternative signal, the file extension, is ruled out by a deep web architectural principle: the suffix of a URL does not determine how the resource is interpreted, and in practice file extension and HTTP Content-Type mismatch widely. This is the section that explains *why* the attributes axis exists at all, which is the fact a minimal Compartments spec needs when it decides to keep attributes orthogonal to import phases.

## Synopsis

The Import Attributes proposal, formerly known as Import Assertions, adds an inline syntax for module import statements to pass on more information alongside the module specifier. The initial application for such attributes is to support additional types of modules in a common way across JavaScript environments, starting with [JSON modules](http://github.com/tc39/proposal-json-modules).

```js
import json from "./foo.json" with { type: "json" };
import("foo.json", { with: { type: "json" } });
```

The specification of JSON modules was originally part of this proposal. It was resolved during the July 2020 TC39 meeting to split JSON modules out into a separate Stage 3 proposal.

The proposal README carries its own caveat: the specification text in the proposal repository may be out of date, and [tc39/ecma262#3057](https://github.com/tc39/ecma262/pull/3057) is the latest version.

## Motivation: a syntactic marker against MIME confusion

Standards-track JSON ES modules were proposed to let JavaScript modules import JSON data files the way many nonstandard module systems already allowed. The idea got broad support from web developers and browsers and was merged into HTML, with a V8/Chromium implementation created by Microsoft.

Then, in [a webcomponents issue](https://github.com/w3c/webcomponents/issues/839), Ryosuke Niwa (Apple) and Anne van Kesteren (Mozilla) proposed that security would be improved if some syntactic marker were required when importing JSON modules and similar module types **which cannot execute code**. The threat is a responding server that unexpectedly provides a different MIME type, causing code to be unexpectedly executed. The solution was to indicate that a module was JSON, or in general not to be executed, somewhere **in addition to** the MIME type.

The same security concern blocks other proposed module types beyond JSON: [CSS modules](https://github.com/whatwg/html/pull/4898), and potentially [HTML modules](https://github.com/whatwg/html/pull/4505) if the HTML module proposal is restricted to not allow script.

## Why not the file extension

Some developers have the intuition that the file extension could determine the module type, as it does in many existing nonstandard module systems. The proposal rejects this on architectural grounds:

> it's a deep web architectural principle that the suffix of the URL (which you might think of as the "file extension" outside of the web) does not lead to semantics of how the page is interpreted.

In practice, on the web there is a widespread mismatch between file extension and the HTTP Content-Type header (the proposal keeps a companion document, `content-type-vs-file-extension.md`, on exactly this). Together these make it infeasible to depend on a suffix in the module specifier as the basis for the check.

Source: [proposal-import-attributes/README.md](https://github.com/tc39/proposal-import-attributes/blob/master/README.md) at content sha256 `f9ee63b0`. Stage 4; retrieved 2026-07-29.
