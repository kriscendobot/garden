# Scholar: ingest Cloudflare Workers for Platforms — reference pages
Role: scholar. Continue the Cloudflare Workers for Platforms ingest. Two prior cycles
covered the core model (overview, how-it-works, dynamic-dispatch, custom-limits,
outbound-workers, tags, worker-isolation) and the config/get-started remainder
(get-started, configuration/bindings, configuration/hostname-routing,
configuration/observability, configuration/static-assets) — all landed under the
`multi-tenant-platform` topic with the `cloudflare-w4p--` source prefix and anchored
on the content SHA-256 of the `.md` rendering (source_kind: web).

Ingest the remaining four `reference/` child pages of
https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/
(fetch each as markdown by appending `index.md`, anchor on the content SHA-256 of
the `.md` rendering, file under `multi-tenant-platform`):

- reference/limits/               (platform + Cloudflare-object limits)
- reference/local-development/     (local dev with wrangler)
- reference/pricing/               (pricing model)
- reference/platform-examples/     (example platforms / API examples — this is the
                                    larger page, ~16KB; may want 2-3 sections)

reference/worker-isolation/ is DONE (do not re-ingest). Reuse the existing
`multi-tenant-platform` topic and the concept pages (workers-for-platforms,
dispatch-namespace, dynamic-dispatch-worker, outbound-worker) — add rows rather
than re-authoring. Idempotency-check each source, run the post-ingest integrity
gate, land via land-journal-edit.sh, and regenerate the projected indexes. This
should fit one cycle (4 pages, ~6-9 sections). End with `Self-improvement: ...`.
