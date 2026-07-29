---
title: Mismatch between Content-Type and file extension on the web — overview
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/content-type-vs-file-extension.md
source_content_sha256: 517bae82cc71751c9f0b557df479b01ee1cac0d720dbc2c468e324d496011d29
source_commit: 9015a79a2c28
source_authors: [Sven Sauleau]
source_date: 2020-06-26
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
notes: "The argument half of the document; the measurements it rests on are the sibling section `analysis-cloudflare-content-type-measurements`. This is the companion the import-attributes README cites for its 'widespread mismatch' claim — see tc39-module-harmony--import-attributes--synopsis-and-motivation."
---

Abstract: The two-paragraph argument that makes import attributes a *security* proposal rather than an ergonomic one, in the words of the document the README cites for it. The claim is that a file extension is not a type, and it is made in two steps. In **Node.js and tooling** the extension-to-type association looks obvious (`.js` → `application/javascript`), but Node and webpack "allow to arbitrarily redirect module resolution," so even there the assumption is "already not guaranteed" (the document cites `tc39/proposal-import-conditions#4`). On **the web** the type is not the extension at all: the server sends a `Content-Type` header and that is what tells the client how to interpret the resource, so a "misconfigured (or malicious)" server can serve a `.css` URL as JavaScript and have it evaluated. The conclusion is the proposal's motivation in one line: the syntax exists so "the developer [can] assert that their ressources will be interpreted correctly" — the assertion is about the *type the client will act on*, which is the header, not the suffix the developer wrote.

## Mismatch between Content-Type and file extension on the web

> For Node.js or tooling we can make the association between the type of a file and its extension. For example, it might sound obvious that a file ending with `.js` would correspond to a `application/javascript` file.
>
> Interestingly, Node.js or webpack does allow to arbitrarily redirect module resolution. Our previous assumption is already not guaranteed. See [#4](https://github.com/tc39/proposal-import-conditions/issues/4).
>
> Moreover, on the web the server needs to send a `Content-Type` header to the client, so that the client can know how to interpret the ressource being transfered.
>
> The web server could be misconfigured (or malicious) and send a wrong `Content-Type` header to the client. For example, a file with the extension `.css` could end up being a JavaScript file and be evaluated by the client.
>
> This proposal will allow the developer to assert that their ressources will be interpreted correctly.

Two distinct failure modes are folded into one document. The Node/webpack one is *resolution redirection* — the specifier a developer wrote is not necessarily the file that is loaded — so the extension in the source text is not evidence about the bytes. The web one is *the extension is not authoritative in the first place* — the `Content-Type` header is, and it is under the server's control rather than the importing developer's. Only the second is a security boundary, and it is the one the proposal's `with { type: "json" }` marker guards: a marker in the importing module's own source text is the one piece of type information a remote server cannot alter.

Source: [content-type-vs-file-extension.md](https://github.com/tc39/proposal-import-attributes/blob/master/content-type-vs-file-extension.md) at content sha256 `517bae82`, file commit `9015a79a`. Stage 4; retrieved 2026-07-29.
