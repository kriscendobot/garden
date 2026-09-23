---
id: data-lock
aliases: ["data-lock", "datalock", "data lock", "E deadlock analog", "unresolvable circular promise", "circular promise resolution"]
topics: [eventual-send, e-language]
---

# data-lock

E's closest analog to deadlock: an **unresolvable circular promise definition** in
which a promise can never resolve because its resolution depends, directly or
through a cycle, on itself. The canonical example is the Liar Paradox encoded as
`def liar := liar <- not()` — the `not()` message stalls forever waiting for the
very object that the message itself is meant to produce, so `liar` stays a
permanent unresolved promise. The decisive difference from a threaded deadlock is
that **nothing blocks**: no thread is stuck, the vat keeps processing other turns,
and the machine stays live. Only that one data value is forever undecided. Data-lock
is therefore the flip side of E's deadlock-freedom — because eventual-send never
blocks a vat, a genuinely circular *data* dependency surfaces as a never-settling
promise rather than as a hung process. This is the model Endo inherits: a
`HandledPromise` whose settlement depends on itself simply never settles; it does
not wedge the event loop.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights--elang-concurrency-epimenides--reference-states-and-data-lock](../sections/erights--elang-concurrency-epimenides--reference-states-and-data-lock.md) | **Canonical origin.** The Epimenides / Liar Paradox chapter: synchronous self-negation fails (eventual reference, "not synchronously callable"); the eventually-send form returns a `<Promise>` that can never resolve because it waits on itself; named *data-lock*, "the closest E comes to conventional deadlock," with the point that it hangs nothing. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining--body](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining--body.md) | Names *datalock* alongside explicit-promise and broken-reference contagion as companion mechanisms of the eventual-send / promise model. |

## See also

- [[eventual-send]] — the non-blocking send operation whose never-blocking property is exactly what turns a circular data dependency into a never-resolving promise instead of a hung thread.
- [[promise-pipelining]] — the sibling property of the same eventual-send substrate; the promise-pipelining sources also name datalock.

## Common confusions

- **"Data-lock is a bug that hangs the program."** No. Data-lock leaves one promise permanently unresolved but blocks nothing else — the vat keeps running other turns. It is the benign, non-blocking analog of deadlock, not a process hang.
- **"Data-lock is the same as a broken reference."** No. A broken reference will never deliver (a rejected/severed promise); a data-locked promise is neither resolved nor broken — it is forever *pending*.
