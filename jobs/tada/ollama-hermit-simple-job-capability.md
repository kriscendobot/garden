Verdict: report-only job succeeded end-to-end; simple filesystem transform failed. `qwen3:0.6b` followed an exact two-line completion/marker task, but a one-file write-and-read task exited 0 without the required marker and claimed its tools were unsuitable. This is a 0.6B tool-use/capability gap, not an Ollama/harness failure.

Fixed the default tag mismatch: `qwen3.6` -> exact served Ollama tag `qwen3:0.6b` across routing, fallbacks, docs, and tests. Pushed `c090912036` to `main2`.

Verified: model routing (28 pass), hermit self-heal (19 pass), Ollama wrapper (14 pass), foreman provider order (12 pass), and worker spine tests passed.

Follow-up: keep hermits disabled for meaningful garden work; use this model only for extremely constrained report-only tasks unless a stronger local model is deployed.
