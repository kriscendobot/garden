---
title: Operational-transform code-change representation
source: packages/workshop-shared/src/code-change.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/code-change.ts
source_line_range: "1-115"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the CodeChange wire representation — base-free revisioned edits over committed code, why per-gadget entries are lists not objects, and this module as the single owner of the OT invariants
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [local-first-sync, change-propagation, content-addressed-storage]
status: current
---

Abstract: `code-change.ts` is the operational-transform representation of a Cloudflare OS chat's uncommitted code. A chat's uncommitted state is a sequence of `CodeChange`s applied on top of committed gadget code (see `ChatCodeBase`): every producer — human keystrokes, agent tool edits, update-from-mainline merges — expresses its change against the chat content as of some revision, and the server serializes them into one revisioned stream per chat. A change carries *no base content*, only "a change relative to revision N", which is what lets it compose with git-backed storage (the base is always some commit's tree plus earlier changes). This module is the single owner of the code-change invariants — the wire types, application, composition, transformation, diffing, validation, and priority convention all live here and nowhere else — with the text-OT core (`@codemirror/state`'s ChangeSet) and diff generation (`fast-diff`) kept private so the invariants stay in one place. A `CodeChange` lists each touched gadget's files as `[path, FileChange]` *entries* rather than a path-keyed object, because a path may legitimately be `__proto__` or `constructor` and Cap'n Web deletes prototype-shadowing keys from every deserialized object — a path-keyed map would silently lose those files in transit.

## Base-free revisioned changes

A chat's uncommitted state is a sequence of `CodeChange`s applied on top of committed gadget code. Every producer — human keystrokes, agent tool edits, update-from-mainline merges — expresses its change against the chat content as of some revision, and the server serializes them into one revisioned stream per chat. A change carries no base content, only "a change relative to revision N", which is what lets it compose with git-backed storage: the base is always some commit's tree plus earlier changes.

## Single owner of the invariants

This module is the single owner of the code-change invariants: the wire types, application, composition, transformation, diffing, ingestion validation, and priority convention all live here and nowhere else. The text-OT core is `@codemirror/state`'s ChangeSet (the substrate of `@codemirror/collab`), and change generation uses `fast-diff`; both are private to this module — not because they might be swapped out, but so the invariants stay in one place. The wire carries the module's own plain-JSON types (structurally ChangeSet's compact JSON form), keeping the RPC contract self-describing.

## The wire types

- `TextChange` is ChangeSet's compact JSON form: a sequence of sections covering the *entire* original text — a bare number retains that many UTF-16 code units, and `[deletedLength, ...insertedLines]` replaces `deletedLength` units with the given lines (joined by `\n`; a one-element array is a pure deletion). Because sections tile the whole text, the change carries its exact before- and after-lengths by construction.
- `FileChange` is exactly one of three variants: `{edit}` transforms the existing text (invalid if the file is absent or its length doesn't match the change's before-length); `{set}` creates or wholesale-replaces content (valid against any state, including absent); `{remove}` deletes the file (valid against any state, so a no-op delete keeps `remove` composable and transformable without knowing the base).
- `CodeChange` maps each touched gadget to a list of `[path, FileChange]` entries. Outer keys are gadget ids in canonical decimal form (an invariant the schema validator enforces, not one the type states); an empty object is the identity change; a present gadget entry must be a non-empty list with no duplicate paths. Plain JSON, treated as immutable everywhere — functions share subtrees between inputs and outputs rather than copying.

## Why lists, not path-keyed objects

The per-gadget entries are deliberately a list rather than a path-keyed object: paths may be any non-empty string, including names that collide with `Object.prototype` members (git content can legitimately contain a file named `__proto__` or `constructor`), and such names must never be object keys on the wire — Cap'n Web deletes prototype-shadowing keys (and `toJSON`) from every object it deserializes, so a path-keyed map would silently lose those files in RPC transit. Gadget ids are safe as keys precisely because the canonical-decimal rule excludes every such name. Changes produced by this module list entries in sorted path order, but consumers must not require that of received changes — entry order has no meaning; only duplicates are illegal.

Source: [packages/workshop-shared/src/code-change.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-shared/src/code-change.ts) at commit `1ef6020a`.
