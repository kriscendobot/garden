model: gpt-5.6-terra
role: fixer
Fix official Kimi Code 0.29.1 compatibility in scripts/jobs/handlers/mystic-kimi.sh. Live CLI evidence: combining --prompt with --yolo exits 1 with `Cannot combine --prompt with --yolo.` Prompt mode is already noninteractive. Remove --yolo from fresh and resume invocations; add a fake-CLI regression rejecting both --prompt+--auto and --prompt+--yolo; run Mystic, worker-spine, completion, and routing tests; push main2 directly and report deploy readiness. Do not consume live credentials or requeue canaries.
