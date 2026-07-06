---
title: Querying — selection and the fact/artifact/typed-value conversions
source: typescript/dialog-experimental/src/session.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "235-265, 412-502"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: The read path — select by a the/of/is FactsSelector, and the toArtifact/fromArtifact + entity-encoding + typed-value tagging that bridge @dialog-db/query facts to the wasm artifact store
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

Abstract: The low-level read path of a JS session is `select(selector)`, where `selector` is a `FactsSelector` with optional `the` / `of` / `is` filters — any subset can be a hole, matching the associative EAV access pattern. Because the WASM store speaks in `Artifact`s (raw `the`/`of`/`is` with encoded entity bytes and typed values) while `@dialog-db/query` speaks in `Fact`s/`Datum`s, `session.ts` carries the conversion glue: `toArtifact`/`fromArtifact`, an entity encoder that stringifies an IPLD link as `of:<cid>` bytes, and `toTyped` which tags each JavaScript scalar with its `ValueDataType`. (Most application code queries through higher-level predicates rather than `select` directly, but `select` is the primitive they compile down to.)

## Selection

```ts
static *select(self, selector: FactsSelector) {
  const connection = yield* this.connected(self)
  const matches = yield* Task.wait(connection.select({
    the: selector.the ? selector.the : undefined,
    of:  selector.of  ? toEntity(selector.of) : undefined,
    is:  selector.is  ? toTyped(selector.is)  : undefined,
  }))
  return yield* Task.wait(fromIterable(matches))
}
```

Any absent field is passed as `undefined` (a wildcard), so `select` is a partial-match query over the `{the, of, is}` triple space. Results stream from an async `ArtifactIterable` and are converted back into `Datum`s.

## Fact ↔ artifact conversion

```ts
const toArtifact = ({ the, of, is }: Fact): Artifact =>
  ({ the, of: toEntity(of), is: toTyped(is) })

const fromArtifact = ({ the, of, is }: Artifact): Datum =>
  ({ the: the as The, of: fromEntity(of), is: is.value,
     cause: Link.of({ the, of, is: is.value }) })
```

`fromArtifact` reconstructs the fourth field of the model — `cause`, the content hash of the `{the, of, is}` triple — by hashing the triple into an IPLD `Link`. That derived `cause` is what makes the fact self-identifying and content-addressed.

## Entity encoding

An entity (the `of` position) round-trips through a tagged UTF-8 encoding of its link:

```ts
const toEntity  = (link) => new TextEncoder().encode(`of:${Link.toJSON(link)['/']}`)
const fromEntity = (entity) => Link.fromJSON({ '/': new TextDecoder().decode(entity).slice(3) })
```

The `of:` prefix (3 bytes, dropped by `slice(3)` on decode) namespaces entity bytes in the store.

## Typed-value tagging

`toTyped` maps a JavaScript `Scalar` to a `{ type: ValueDataType, value }` pair the wasm store understands:

| JS value | `ValueDataType` |
|---|---|
| `boolean` | `Boolean` |
| integer `number` / `bigint` | `SignedInt` |
| finite non-integer `number` | `Float` |
| `string` | `String` |
| `Uint8Array` | `Bytes` |
| an IPLD `Link` | `Entity` (stores `value['/']`) |

A non-finite number is `unreachable(...)`; any other object type throws `TypeError('Object types are not supported')`. This is the value-type discipline that keeps the schema-on-read store's `is` position to a closed set of scalar shapes.

Source: [typescript/dialog-experimental/src/session.ts](https://github.com/dialog-db/dialog-db/blob/03c82744532976d72f74e7d8b2d0c35458d01310/typescript/dialog-experimental/src/session.ts) at commit `03c82744`.
