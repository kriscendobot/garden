scripts/jobs/orchestrate.sh
Detecting a stalled orchestration is currently an agent's job, and it is slow and unreliable. The watcher classifies each child as tada / todo / doin / plan / vanished (see the state resolver around line 101) and treats anything not-tada and not-vanished as legitimately in flight, with no liveness bound. A child that keeps being claimed, dying, and being requeued therefore reads as "moving" forever: `xs2rust-endor-s1-daemon-integration` churned on a host with an expired token while the serial run waited, and the only thing tracking it was an LLM gardener watchdog job accumulating a "two consecutive ticks" judgment across ticks — a classification with a clear deterministic definition that does not need a model, and that costs a `claude -p` invocation per tick to reach a conclusion the board's own metadata already supports.

Give the watcher a deterministic liveness bound per child and let the existing `on-child-failure` policy handle it. A child is stalled when its requeue count (`<!-- garden-reaped: N -->`) has risen across ticks with no completion, or when its time in flight exceeds a multiple of its `handler-timeout` (S1 carried 10800; three hours expired at 00:13:45Z with the orchestration none the wiser), or when it has been promoted-and-requeued more than a small bound. On crossing it, treat the child as failed and run the same path a vanished child takes: halt the serial run and surface it (policy=halt), or continue (policy=continue) — with a stall-specific reason in the notice so the maintainer sees "child N stalled after K requeues on host H" rather than a generic failure. This is the responsibility to move off the agent: the watchdog job should be reading a conclusion the watcher already reached, not deriving it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T01:22:40Z
