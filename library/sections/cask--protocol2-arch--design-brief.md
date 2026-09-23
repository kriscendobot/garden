---
title: CASK Protocol v2 design brief (the prompt that produced protocol2.md)
source: doc/design/protocol2-arch.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: superseded
notes: |
  The design brief that requested protocol2.md, which was itself never
  implemented. Retained as the genesis record of three ideas: fixed-offset
  command-first framing, TTL-as-relay-deadline translation, and the
  dual-purpose trace-identifier-plus-priority field that became "cohort".
---

## Abstract

`protocol2-arch.md` is the short design brief (a prompt) that asked for `PROTOCOL2.md` to be proposed. It is not a specification but a statement of requirements, and it is historically interesting as the genesis of three ideas. First, fixed-width framing: every packet carries up to 1024 bytes divided between data and up to 32 block hashes, with every field offset and width fixed but the data portion variable, so the block must come last and the discriminating 4-byte command must come first. Second, a TTL-as-deadline relay translation: a relay translates a time-to-live to a deadline when enqueuing and back to a TTL when dequeuing, and the brief asks for an appropriate integer width and time scale given the expected queue delay of a UDP-level forwarding relay. Third, the dual-purpose field that became **cohort**: every block carries a 64-bit integer serving as both a Dapper-style trace identifier and a priority, where the most significant bits may classify traffic by priority at the application layer and the remaining bits are expected to be evenly, randomly distributed so that packets sharing a trace tend to succeed or fail together when a saturated relay drops packets. The brief asks for a name capturing both properties; the answer in `protocol2.md` is "cohort", and the same fail-together-by-trace property is the load-bearing idea behind the shipped 256-bit (TrafficClass, Trace) priority key.

## The brief (verbatim intent)

> Please propose a next iteration of the protocol, PROTOCOL2.md, where:
>
> Every packet contains up to 1024 bytes divided between data and up to 32 block hashes. Every field offset and width should be fixed, but the data portion of a packet can vary in length; therefore the block must come last and the discriminating command (four bytes) that dictates the remaining packet shape must come first.
>
> Propose an appropriate integer width and time scale for a time-to-live value that a relay would translate to a deadline when enqueued and back to a time-to-live when dequeued, taking into account the expected duration of queue delay for a UDP-level forwarding relay.
>
> Every block must contain a 64-bit integer that serves as both a trace identifier for Dapper-style tracing and a priority. The most significant bits may be set or masked at the application layer to classify traffic by priority, and all remaining bits are expected to be evenly, randomly distributed, such that packets that share a trace will tend to succeed or fail together if a relay is saturated and drops packets. Propose a suitable name for the field that captures both of these properties.

The "fail together if a relay is saturated" requirement is the same statistical-independence-then-grouping reasoning that the cask README's why-1KB-blocks and priority/load-shedding sections carry forward (`cask--readme--why-1kb-blocks`, `cask--readme--priority-load-shedding`), and the dual trace+priority field is realized as the shipped TrafficClass/Priority model rather than as v2's per-packet cohort.

Source: [doc/design/protocol2-arch.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol2-arch.md) at commit `cdb975d8`.
