---
title: kindOf vs passStyleOf
source: packages/patterns/docs/marshal-vs-patterns-level.md
source_repo: endojs/endo
source_commit: 4c2d33c799f2
source_date: 2025-05-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, marshal, pass-style]
status: current
---

> Abstract: The relationship at the patterns layer: kindOf adds finer-grained classification on top of passStyleOf (e.g., a copyArray with all-numeric elements has kind 'copyArray' but a more specific kindOf-derived shape). Patterns uses kindOf for matching; marshal uses passStyleOf for transport.

## `kindOf` *vs* `passStyleOf`

Only the `passStyleOf` level is assumed for universal interoperability, but `kindOf(p) === passStyleOf(p)` for every non-Tagged Passable value. For a Tagged Passable `p`, `kindOf` may or may not recognize the value as encoding an instance of one of its known higher-level data types. If it is not recognized, then `kindOf(p) === undefined` but the Passable remains valid and must be accurately transmissable by all participants (for example, Alice might send a Tagged that she recognizes to Bob, who does not recognize it but sends it on to Carol who does).

For a Tagged Passable `p` to be recognized, it must carry both a known tag string identifying its kind _and_ a payload that satisfies all constraints associated with that kind. In such cases, `kindOf(p)` returns the tag string.

|              | `kindOf(p)`      | `passStyleOf(p)` | meaning                        |
|--------------|------------------|------------------|--------------------------------|
| non-Tagged   | `passStyleOf(p)` | see above        |                                |
| Containers   |                  |                  |                                |
|              | `"copySet"`      | `"tagged"`       | Set of unique Keys             |
|              | `"copyBag"`      | `"tagged"`       | [Multiset](https://en.wikipedia.org/wiki/Multiset) of Keys (each Key having an associated positive integer count) |
|              | `"copyMap"`      | `"tagged"`       | Dictionary of (Key,Passable) pairs |
| Matchers     | `"match:..."`    | `"tagged"`       | Non-literal Patterns           |
| Guards (TBD) | `"guard:..."`    | `"tagged"`       | Non-Pattern Guards             |
| Just Tagged  | `undefined`      | `"tagged"`       | Not understood to have a kind  |

Source: [packages/patterns/docs/marshal-vs-patterns-level.md](https://github.com/endojs/endo/blob/4c2d33c799f2/packages/patterns/docs/marshal-vs-patterns-level.md) at commit `4c2d33c7`.
