---
title: gtor — progress and estimated time to completion (a worked example of the discrete-signal vs continuous-behavior duality)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation]
status: current
---

> Abstract: gtor's `## Cases` worked example (`### Progress and estimated time to completion`), which makes the [[gtor--readme--signals-and-behaviors]] duality concrete on a familiar problem: copying values from a stream into an array of known length. From the count received so far and the start time you can compute **progress** (`index / length`) and average **throughput** (`index / elapsed`) — both *discrete* time series, **pushed** once per received value because they only change on an event; this is a **signal**. From progress you derive an **estimated time of completion** (`start + elapsed * length / index`). But to animate a progress bar smoothly you want a *continuous* value with no inherent resolution: sampling `(now - start) / (estimate - start)` at any instant yields a different value, so it is the **consumer's** responsibility to decide when to **pull/poll** it (the frame rate is the sensible polling frequency); this is a **behavior**. The same underlying quantity — how far along we are — is thus a signal when pushed on each discrete event and a behavior when polled continuously, the exact two-faces-of-one-value pattern that recurs as `@endo/pubsub`'s change-topic vs latest-topic.

This short section is filed under `change-propagation` because it is the cleanest worked illustration in gtor of why the same quantity is exposed as both a pushed **signal** and a polled **behavior** — the duality the rest of the cluster (`@endo/pubsub`'s `makeChangeTopic` vs `makeLatestTopic`, `@agoric/notifier`'s lossless vs lossy) instantiates. See [[changes-versus-latest]].

## §The discrete signal: progress and throughput, pushed per value

Copying a stream's values into an array of known `length`, knowing the `start` time and assuming a steady flow rate, **progress** is simply:

```js
var progress = index / length;
```

This is a **discrete** measurement you can **push** each time you receive another value; it is discrete because it does not change between events. Average **throughput** is likewise a discrete time series:

```js
var elapsed = now - start;
var throughput = index / elapsed;
```

From progress you can divine an **estimated time of completion** — the start time plus how long you expect the whole stream to take:

```js
var stop = start + elapsed / progress;
var stop = start + elapsed / (index / length);
var stop = start + elapsed * length / index;
```

## §The continuous behavior: smooth progress, pulled at the frame rate

A progress bar usually wants a **smooth animation** continuously changing, proceeding linearly from 0 at the start time to 1 at the stop time. Sampling this at any moment yields a different value:

> Values that lack an inherent resolution are *continuous*. It becomes the responsibility of the consumer to determine when to sample, **pull** or **poll** the value.

For a smooth animation of a continuous behavior, the **frame rate** is a sensible polling frequency. From the last known estimated time of completion you infer a continuous progress time series:

```js
var progress = (now - start) / (estimate - start);
```

So the discrete `index / length` (a **signal**, pushed per value) and the continuous `(now - start) / (estimate - start)` (a **behavior**, polled per frame) are two renderings of the same "how far along" quantity — the duality made operational.

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Cases / Progress and estimated time to completion, lines 1598–1654).
