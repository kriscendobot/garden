<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-26T06:26:20Z -->

# PLAN: @endo/stream `flatMapReader` — 1-to-many reader transform (flatten a stream of arrays)

Maintainer request (ref endo-but-for-bots **#486** comment `4774483802`): add a **`flatMapReader`**
to **`@endo/stream`**, **analogous to `Array.prototype.flatMap`**, for **converting a stream of
arrays into a stream of array elements** (and, generally, a 1-to-many reader transform). Deferred
plan; when promoted, design + implement on `endojs/endo-but-for-bots` (bot fork of endojs/endo;
`@endo/stream` lives at `packages/stream`). Wear the **designer** then **builder** role. Bot repo,
bot identity.

## Motivation (the gap)

From #486: the existing **`mapReader` is 1-to-1**, but real cases are **1-to-many** — e.g.
`parseStreamJsonLines` (a chunk → many newline-delimited records) and the general
"stream-of-arrays → stream-of-elements" flatten. There is currently no 1-to-many reader primitive,
so these are written ad hoc. `flatMapReader` is the missing analog of `Array.flatMap`.

## What to build

- **`flatMapReader(reader, fn)`**: map each element of a `Reader<T>` via `fn: (T) => Iterable<U>`
  (array / iterable / sub-reader) and **flatten** the results into a single `Reader<U>`. The
  motivating identity case is `fn = x => x`, turning a **`Reader<T[]>` into a `Reader<T>`** (flatten
  a stream of arrays). Mirror the shape/placement/naming of the existing `mapReader` sibling.
- **Preserve back-pressure** (the crux): `@endo/stream` readers are async and back-pressured. Emit
  the inner array/iterable's elements **one at a time**, pulling the next source element only when
  the current group is exhausted — never buffer the whole upstream. Correctly propagate
  **return/throw/termination** through the flattening, and handle empty groups (advance to the next
  source element).
- Consider whether `fn` may return an **async iterable / sub-Reader** (not just a sync array), and
  whether a separate name (`flatMapReader` vs a `flattenReader` identity helper) reads best —
  decide in the design.

## Deliverable

Design note (placement + signature + back-pressure semantics + how it subsumes
`parseStreamJsonLines`-style 1-to-many cases), then the implementation in `@endo/stream` with
**types**, **tests** (flatten arrays, empty groups, termination/throw propagation, back-pressure /
lazy pull), **README/docs**, and a **changeset**. Open it as a PR on `endojs/endo-but-for-bots`
with the standard summary comment. Note it as the building block to refactor the #486 follow-ups
(`parseStreamJsonLines`, the line-accumulator).

## Definition of done

`flatMapReader` designed + implemented in `@endo/stream` (back-pressure-preserving 1-to-many,
flattens a stream of arrays), with types, tests, docs, and a changeset, on a PR against
`endojs/endo-but-for-bots`. Report the PR number and the signature, and confirm it subsumes the
1-to-many cases #486 deferred.
