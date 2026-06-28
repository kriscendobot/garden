Add a deterministic PDF→text path to `scripts/jobs/fetch-source.sh` so paper-PDF ingestion no longer requires an agent to hand-extract text. Today the script saves PDF bytes but stops there; in the 2026-06-28 `combex-capdesk-polaris` cycle the scholar had to manually run `pypdf` on HPL-2004-221 to get ingestible text, the one hand-rolled step in an otherwise scripted flow. Detect a PDF response (by `Content-Type: application/pdf` or the `%PDF` magic on the fetched bytes) and, when found, emit an adjacent extracted-text artifact via `pypdf` (which is present in the sandbox; `pdftotext` is not — so use `python3 -c` with `pypdf`, not poppler). Keep the raw PDF bytes alongside the text (the script already keeps bytes off stdout). Update the script's header recipe and the scholar's `roles/scholar/AGENT.md` § PDF/source acquisition (which already cites this script) so paper ingestion points at the script's text path instead of a prose pypdf recipe. Land in an isolated worktree off `origin/main2` per the garden-infra-jobs norm.

---
claim:
  host: endolinbot
  gardener: 10
  claimed_at: 2026-06-28T01:51:11Z
