---
title: gtor — the reactivity taxonomy (producer/consumer dual × singular/plural × spatial/temporal; broadcast vs unicast; pressure)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation, streams, reactive-bindings]
status: current
---

> Abstract: gtor's organizing taxonomy of reactive primitives. The load-bearing claim: **the duality of a getter and a setter — a producer and a consumer, a writer and a reader — exists in every reactive primitive.** Primitives then partition along two further axes: **singular vs plural** (a single value vs a collection of values) and **spatial vs temporal** (a value available now vs a value that arrives over time). The 3×2×2 grid names twelve interfaces: a *value* is singular+spatial, an *array* is plural+spatial, a *promise* (getter) / *resolver* (setter) is singular+temporal, and a *stream* (with its *reader* getter and *writer* setter) is plural+temporal — a stream is "an array rotated 90 degrees from the space axis onto the time axis." A second cut is **broadcast vs unicast**: promises and publish/subscribe are broadcast (any number of independent consumers, no consumer can interfere with another, hence no cancellation); streams and tasks are unicast (one cooperative consumer, information flows both ways, hence cancelable and back-pressured). This grid is the frame every concrete change-propagation package in the corpus fills in.

## The dual exists in every primitive

A **value** is singular and spatial; broken in two it is a **getter** and a **setter**, with data flowing one direction from setter to getter. gtor's central observation is that this dual — getter/setter, producer/consumer, writer/reader — recurs in *every* reactive primitive. (Erik Meijer's Lang.NEXT 2014 keynote on reactive duals is cited as the parallel.)

- Singular vs **plural**: an array (or any collection) holds multiple values; an **iterator** is a plural getter and a **generator** the plural setter.
- Spatial vs **temporal**: reactivity is about time. A **promise** is a getter for a single value from the past or future; its setter is a **resolver** (collectively a **deferred**). A **stream** is the temporal analogue of an array — its producer side is a **writer** (an asynchronous generator), its consumer side a **reader** (an asynchronous iterator).

| Interface  | Role   | Cardinality | Axis     |
| ---------- | ------ | --------    | -------- |
| Value      | Value  | Singular    | Spatial  |
| Getter     | Getter | Singular    | Spatial  |
| Setter     | Setter | Singular    | Spatial  |
| Array      | Value  | Plural      | Spatial  |
| Iterator   | Getter | Plural      | Spatial  |
| Generator  | Setter | Plural      | Spatial  |
| Deferred   | Value  | Singular    | Temporal |
| Promise    | Getter | Singular    | Temporal |
| Resolver   | Setter | Singular    | Temporal |
| Stream     | Value  | Plural      | Temporal |
| Reader     | Getter | Plural      | Temporal |
| Writer     | Setter | Plural      | Temporal |

## Broadcast vs unicast

Promises are **broadcast**: any number of producers may race to resolve and any number of consumers may subscribe; each producer's and consumer's experience is indistinguishable from any other's, and one consumer cannot prevent another from making progress. Information flows one direction. *Because* no consumer can interfere with another, a promise cannot abort the work behind it — "a promise represents a result, not the work leading to that result." A **task** has the same shape but is **unicast** and therefore cancelable: one subscriber (forkable), and if all subscribers unsubscribe the task can abort its work.

A **stream** is unicast like a task: the consumer expects to see *every* value, the order matters, and every value is significant. Streams are a cooperation — "data flows forward, acknowledgements flow backward, and either the consumer or producer can terminate the flow." This bidirectional acknowledgement is **pressure**: a vacuum on the producer side stalls the consumer; pressure (filled vacuum) on the consumer side is **back-pressure** that stalls the producer. Pressure exists to guarantee every value transits setter to getter.

In contrast, **publishers and subscribers are broadcast**. Information flows one direction, and there is no guarantee of continuity: "the publisher does not wait for a subscriber and the subscriber receives whatever values were published during the period of their subscription," whereas a stream would buffer every value until the consumer arrives. This is the structural reason a publish/subscribe topic and a stream behave differently for a late subscriber.

## Time-series data: order may not matter

With *time-series data* — values that change over time but carry the same meaning — order and completeness may be unimportant. "If you were bombarded with weather forecasts, you could discard every report except the one you most recently received." Time-series data comes in two varieties: **discrete** values should be **pushed**; **continuous** values should be **pulled/polled**. The current temperature is a continuous behavior; animation frames and morse code are discrete signals. This split is developed in the [signals-and-behaviors section](gtor--readme--signals-and-behaviors.md) and is the root of the changes-vs-latest duality.

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Concepts).
