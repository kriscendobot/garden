---
title: Concurrent transform and the priority convention
source: packages/workshop-shared/src/code-change.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/code-change.ts
source_line_range: "18-23, 236-340"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: transformCodeChange and composeCodeChange — the server-order priority pairing, the ChangeSet transform law, and per-path rules for edit/set/remove
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [local-first-sync, change-propagation, data-structures]
status: current
---

Abstract: Cloudflare OS resolves concurrent code edits with a fixed priority convention, used identically on both sides of the wire: for two changes made concurrently against the same revision, the change the server ordered *earlier* comes first — its inserts precede the later change's at equal positions. This is exactly ChangeSet's documented transform law (`A.compose(B.map(A))` equals `B.compose(A.map(B, true))`), and `transformCodeChange(a, b)` bakes the pairing in — `a` is the earlier side, and nothing else may call the underlying `map`. The server rebases an incoming change over the changes already accepted since its claimed revision (each accepted change is `a`, the incoming change is `b`); a client holding unacknowledged local edits rebases them over each incoming broadcast (the broadcast is `a`, since the server accepted it first). Per-path, `set` and `remove` behave alike: edit-vs-edit is delegated to the text OT core; a `set`/`remove` opposite an `edit` survives unchanged and drops the edit (its base was wholesale-replaced); `set`/`remove` vs `set`/`remove` is last-writer-wins by server order. `composeCodeChange` folds two sequential changes into one, throwing only on impossible sequences (an edit after a remove) — a throw signals a caller bug, never bad client input.

## The priority convention

Fixed here and used identically on both sides of the wire: for two changes made concurrently against the same revision, *the change the server ordered earlier comes first* — its inserts precede the later change's at equal positions. This is exactly ChangeSet's documented transform law: `A.compose(B.map(A))` and `B.compose(A.map(B, true))` produce the same document. `transformCodeChange(a, b)` bakes the pairing in; nothing else may call the underlying `map`.

## Both sides of the wire use one function

`transformCodeChange(a, b)` transforms two concurrent changes (both made against the same content) across each other. `a` is the side the server ordered *earlier*, which fixes the priority: at equal positions, `a`'s inserts precede `b`'s. The result's `a` is the original `a` rebased to apply after the original `b`; the result's `b` is the original `b` rebased to apply after the original `a` — applying either pairing to the same base produces identical content.

- The **server** rebases an incoming change over the changes already accepted since the change's claimed revision (each accepted change is `a`, the incoming change is `b`).
- A **client** holding unacknowledged local edits rebases them over each incoming broadcast change (the broadcast change is `a` — the server accepted it first — and the client updates its display with the transformed `a` while keeping the transformed `b` as its new pending change).

## Per-path rules

`set` and `remove` behave alike, so these also cover delete-vs-edit and create-vs-create:

- edit vs edit: delegated to the text OT core under the documented pairing;
- `set`/`remove` vs an opposing `edit`: the `set`/`remove` survives unchanged and the `edit` is dropped, regardless of order — its base was wholesale-replaced, so there is nothing meaningful to rebase it onto;
- `set`/`remove` vs `set`/`remove`: last-writer-wins by server order — `b` survives, `a` is dropped from the rebased result (it must not clobber `b` when applied after it).

## Composition

`composeCodeChange(a, b)` composes two sequential changes into one with the same effect: `b` must apply to the content produced by `a`. It throws on changes that cannot be sequential (an `edit` after a `remove`, or edits whose lengths don't chain) — like `applyCodeChange`, a throw indicates a bug in the caller, not bad client input. When composing file changes, a later `set`/`remove` wholesale-supersedes whatever the earlier side did; a later `edit` of an earlier `set` folds into a new `set`; two edits compose through the text OT core. `makeCodeChange` builds results in deterministic order (gadgets ascending, entries by path), which the git-storage migration's conversion-determinism guarantee relies on.

Source: [packages/workshop-shared/src/code-change.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/code-change.ts) at commit `1ef6020a`.
