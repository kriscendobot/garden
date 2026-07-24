Investigation complete. No code or state changes made.

Root cause: intended eligibility behavior. The only two claimable jobs were both `model: kimi-k3` canaries. Routing classifies that model as Moonshot-only, so all four declared Hermits correctly reject them. The live claim logs repeatedly show both local workers skipping each canary with `backend-fit`; side-effect-free reproduction confirmed only `mystic` is eligible.

Fleet state:

- Leader `endolin-garden2-5bcdff64`: 2 Hermits declared and both units active.
- Follower `endolin-garden-ece02cb4`: 2 Hermits declared.
- Total declared Hermit capacity: 4; total Mystic capacity: 0.
- Queue at inspection: 2 `todo`, 26 `doin`, 117 `plan`; both todo jobs were the incompatible Kimi canaries. There were no Hermit claims in current `doin`.
- Historical reputation records show Hermits have successfully completed local-provider work previously.

Separate health defect found: leader Ollama answers `/v1/models`, but reports no models (`data: null`; `ollama list` empty). A pre-existing PID 176 `ollama serve` owns port 11434, causing `garden-ollama.service` to restart-loop (54 restarts) while treating the merely reachable endpoint as healthy. Thus a future `qwen*` job would pass backend-fit but could not actually run.

Recommended follow-up: either enable a Mystic worker to consume or remove/rewrite the two Kimi canaries; then restore a supervised Ollama instance with `qwen3.6` pulled, and tighten local-provider readiness to require the configured routed model rather than only HTTP reachability. This is a real operational defect, but not the cause of the observed no-claim condition.

Self-improvement: nothing this time.
