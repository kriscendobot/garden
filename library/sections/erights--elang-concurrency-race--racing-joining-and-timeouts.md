---
title: "Concurrency Races: racing, joining, and timeouts"
source_kind: web
source_url: http://erights.org/elang/concurrency/race.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/race.html
source_fetched_via: mirror
source_content_sha256: 145978130f9dc5fc7258434389c816dbaea129bbf9ebc888bcaee296d4b678e6
source_authors: [Mark S. Miller, Terry Stanley]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [eventual-send, e-language]
status: current
notes: >
  Primary erights.org tutorial chapter (Concurrency in E, child of the concurrency
  hub). The historical primary source for the promise-combining abstractions E
  builds on top of the eventually-operator: race (first-to-resolve), asynchAnd
  (asynchronous join / conjunction), and timeBomb + timeouts. Reachable via the
  erights.org GitHub Pages mirror. source_date is an era approximation matching the
  sibling concurrency chapters.
---

## Abstract

The E tutorial's **Concurrency Races** chapter: the historical primary source for
the promise-combining abstractions E layers on top of the eventually-operator
`<-`, all built on the once-only resolution of a promise. It defines **`race`**
(given a list of promises, return a promise for the first to resolve — "the race
is won by whoever first resolves the returned promise, since promises are resolved
only once"), the **`once`** use-once forwarder (returns an object that forwards no
more than one message to its target, then throws "used up"), **`asynchAnd`** (the
asynchronous **join**: given a list of promises for booleans, return a promise for
their conjunction that resolves to `true` only when all resolve `true`, and
resolves to `false` or broken as soon as any does, without waiting for the rest),
and **`timeBomb`** (a promise that becomes broken after a fixed delay). Combining
`timeBomb` with `race` or a join gives **timeouts**: `race(bob <- gimmeInteger(),
timeBomb(5000))` guarantees a resolved answer within five seconds even if Bob is
wedged. These are the E-tutorial ancestors of Endo's promise-combinator patterns
(`Promise.race`, all-settled joins, and timeout-via-race). Use this to ground
claims about how E does fork/join, first-wins racing, and timeouts purely with
non-blocking sends and once-only promise resolution.

## Walkthrough

**`race` — first-to-resolve wins.** Given a list of promises, `race` returns a
single promise that takes the value of whichever input resolves first. The
once-only resolution rule is what makes the race well-defined: a resolver resolves
its promise at most once, so the first `resolveRace` wins and later ones are
no-ops.

```e
def race(promises) :rcvr {
    def [result, resolver] := Ref.promise()
    for prom in promises {
        when (prom) -> {
            resolver.resolveRace(prom)
        } catch problem {
            resolver.smash(problem)
        }
    }
    return result
}
```

In the transcript, `c := race([a, b])` stays unresolved until the first input
resolves; resolving `a` to `3` resolves `c` to `3`, and a later resolution of `b`
to `4` leaves `c` unchanged at `3`.

**`once` — a use-once forwarder.** `once(func)` returns a forwarder that passes at
most one `run` message through to `func`; a second call throws `"used up"`. The
two-argument form `once(verb, target)` generalizes to forward at most one `verb`
message. The chapter's worked example: `def printOnce := once(println)` prints on
the first call and fails on the second. The implementation is notable for the care
it takes with E's **Miranda methods** (the default methods every object answers:
`__getAllegedType`, `__respondsTo`, `__printOn`, `__reactToLostClient`, and the
sealed-dispatch/when-more-resolved protectors): the forwarder selectively
overrides some and forwards others so the use-once wrapper stays a faithful proxy.
(The chapter flags that `once` "no longer belongs in this chapter" — a
housekeeping note that it drifted here historically.)

**`asynchAnd` — the asynchronous join.** A recurring question is "E can fork off
multiple activities with `<-`, but how can it **join** — wait until several have
completed?" The answer is a joining abstraction plus a `when`-`catch` on its
result. `asynchAnd` takes a list of promises for booleans and returns a promise
for their conjunction:

```e
def asynchAnd(bools :List[vow[boolean]]) :vow[boolean] {
    def [result, resolver] := Ref.promise()
    var countDown := bools.size()
    for bool in bools {
        when (bool) -> {
            if (bool) {
                if ((countDown -= 1) <= 0) {
                    resolver.resolve(true)
                } else {
                    resolver.gettingCloser()
                }
            } else {
                resolver.resolveRace(false)
            }
        } catch problem {
            resolver.smash(problem)
        }
    }
    return result
}
```

It short-circuits: the result resolves to `true` only when the count-down reaches
zero (all inputs true), and resolves to `false` (via `resolveRace`, so the first
false wins) or broken (via `smash`) as soon as any input is false or broken,
without waiting for the remaining answers.

**`timeBomb` and timeouts.** `timeBomb(millis)` returns a promise that becomes
**broken** after the given delay, built on the timer service:

```e
def timeBomb(millis) :any {
    return timer.whenPast(timer.now() + millis, fn {
        Ref.broken("time's up")
    })
}
```

Racing a real request against a `timeBomb` is how E expresses a **timeout**: the
combined promise resolves either to the real answer or to the broken "time's up"
promise, whichever comes first.

```e
def answer := race(bob <- gimmeInteger(), timeBomb(5000))
```

Alice gets a resolved `answer` within about five seconds even if Bob never
replies. No thread blocks anywhere: the timeout is just another promise in the
race.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| `race(promises)` | `Promise.race([...])` (first settled wins) |
| `asynchAnd(bools)` | a short-circuiting `Promise.all`-style join over boolean vows |
| `timeBomb(millis)` | a delay-then-reject promise (timeout sentinel) |
| `race(req, timeBomb(...))` | timeout-via-race: `Promise.race([request, rejectAfter(ms)])` |
| `vow[boolean]` | a promise (`HandledPromise`) for a boolean |
| `Ref.promise()` → `[result, resolver]` | `makePromiseKit()` → `{ promise, resolve, reject }` |
| `resolver.smash(problem)` | `reject(problem)` |

## See also

- [erights--elang-concurrency-index--event-loop-concurrency-map](erights--elang-concurrency-index--event-loop-concurrency-map.md): the concurrency hub that lists this chapter.
- [erights--elang-intro-quicke--promises-when-catch-and-far-references](erights--elang-intro-quicke--promises-when-catch-and-far-references.md): the `when`-`catch` resolution construct these abstractions are built on.
- [erights--elang-concurrency-epimenides--reference-states-and-data-lock](erights--elang-concurrency-epimenides--reference-states-and-data-lock.md): the sibling chapter on the near/eventual/broken reference states whose "broken" state `timeBomb` produces.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining--body](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining--body.md): the formalization of promises and non-blocking sends these tutorial combinators sit on.

Source: [elang/concurrency/race.html](https://erights.org/elang/concurrency/race.html), fetched 2026-06-28 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/concurrency/race.html](https://erights.github.io/erights-org-website/elang/concurrency/race.html)), content SHA-256 `145978130f9d`.
