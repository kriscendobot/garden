---
title: Permits tables (%URL%, %SharedURL%, URLSearchParams)
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: The ✓/✗/★ disposition taxonomy is from SES's permits-pass convention. The only difference between %URL% and %SharedURL% is that the latter strips createObjectURL + revokeObjectURL. URLSearchParams.prototype accessors (size, has, get, etc.) are pure operations on own-data; the iterators get the ★ disposition because their return-value prototype needs separate handling (next section).
---

> Abstract: SES's permits-pass models constructors as ordinary objects with an explicit permitted-property set; anything not listed is removed. Three tables. **`%URL%` (start compartment, bound to `globalThis.URL`)**: `prototype` ✓ (same identity as `%SharedURL%.prototype`); `parse` static ✓ (pure parsing); `canParse` static ✓ (pure predicate); `createObjectURL` ✓ (ambient blob-registry authority; start compartment may legitimately need); `revokeObjectURL` ✓ (companion). **`%SharedURL%` (every shared compartment)**: same as %URL% but `createObjectURL` ✗ and `revokeObjectURL` ✗ (not safe to share). When `urlBlobMethods: 'remove'` is set, the start compartment uses the `%SharedURL%` row instead. **Shared `prototype` permit** lists the standard accessors (`href`, `origin`, `protocol`, `username`, `password`, `host`, `hostname`, `port`, `pathname`, `search`, `searchParams`, `hash`) + standard methods (`toString`, `toJSON`) — all pure and powerless after constructor taming. **`URLSearchParams`**: `prototype` ✓; `prototype.{append, delete, get, getAll, has, set, sort, toString, size}` ✓ (pure operations on own-data structure); `prototype.{forEach, entries, keys, values, [Symbol.iterator]}` ★ (pure but return an instance of `%URLSearchParamsIteratorPrototype%` — see iterator-prototype-sampling).

### Permits table

The permits entry models `%URL%`, `%SharedURL%`, and `%URLSearchParams%` as ordinary constructors with an explicit set of permitted properties. Anything not listed is removed by SES's whitelisting pass.

Columns mark which properties are kept (✓), removed (✗), or require special treatment (★).

#### `%URL%` (start compartment, bound to `globalThis.URL`)

| Property | Disposition | Rationale |
|---|---|---|
| `prototype` | ✓ | Required for instances; the same identity as `%SharedURL%.prototype`. |
| `parse` (static) | ✓ | Pure parsing returning a URL or `null`. |
| `canParse` (static) | ✓ | Pure predicate. |
| `createObjectURL` | ✓ | Ambient blob-registry authority; the start compartment may legitimately need it. |
| `revokeObjectURL` | ✓ | Companion to `createObjectURL`. |

#### `%SharedURL%` (every shared compartment, bound to `globalThis.URL`)

| Property | Disposition | Rationale |
|---|---|---|
| `prototype` | ✓ | Required for instances; the same identity as `%URL%.prototype`. |
| `parse` (static) | ✓ | Pure parsing returning a URL or `null`. |
| `canParse` (static) | ✓ | Pure predicate. |
| `createObjectURL` | ✗ | Ambient blob-registry authority; not safe to share. |
| `revokeObjectURL` | ✗ | Companion to `createObjectURL`. |

When the lockdown opt-in `urlBlobMethods: 'remove'` is set, the start compartment's `URL` uses the `%SharedURL%` permits row instead.

The shared `prototype` permit lists the standard accessors (`href`, `origin`, `protocol`, `username`, `password`, `host`, `hostname`, `port`, `pathname`, `search`, `searchParams`, `hash`) and the standard methods (`toString`, `toJSON`). All are pure and powerless after the constructors are tamed.

#### `URLSearchParams`

| Property | Disposition | Rationale |
|---|---|---|
| `prototype` | ✓ | Required for instances. |
| `prototype.append`, `delete`, `get`, `getAll`, `has`, `set`, `sort`, `toString`, `size` | ✓ | Pure operations on an own-data structure. |
| `prototype.forEach`, `entries`, `keys`, `values`, `[Symbol.iterator]` | ★ | Pure, but each returns an instance of `%URLSearchParamsIteratorPrototype%`; see the iterator-prototype-sampling section. |

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
