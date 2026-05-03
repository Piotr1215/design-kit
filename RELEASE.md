# Releasing design-kit

Plugin auto-update reads `version` from `.claude-plugin/plugin.json`.
If that field doesn't change, installs stay on the cached payload — even
if the marketplace pin moves to a new tag.

## Steps

Bump `X` to the new version (e.g. `0.1.4`).

1. Edit `.claude-plugin/plugin.json` — set `"version": "X"`.
2. Commit, tag, push:

   ```bash
   git add .claude-plugin/plugin.json
   git commit -m "chore(plugin): bump version to X"
   git tag -a vX -m "vX"
   git push origin main
   git push origin vX
   ```

3. In `Piotr1215/aiverse`, update `.claude-plugin/marketplace.json` —
   set both `source.branch` and `version` for the design-kit entry to
   `vX` and `X` respectively. Commit and push.

Auto-update picks up the new version on the next Claude Code restart
for any user with `autoUpdate: true` on the aiverse marketplace.

## Why both bumps matter

- `marketplace.json` `branch` → which git ref to fetch
- `plugin.json` `version` → what triggers the cache refresh

Bump both, or auto-update silently no-ops.
