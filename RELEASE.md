# Releasing design-kit

> [!IMPORTANT]
> **This repository is archived.** Releases now happen in the
> [aiverse marketplace](https://github.com/Piotr1215/aiverse).
> Do not bump versions or push commits here — they will not ship.

## Where to release

design-kit lives bundled at `Piotr1215/aiverse/plugins/design-kit/`.
The aiverse marketplace tracks its own `main` branch.

## Steps (perform in `Piotr1215/aiverse`)

1. Edit files under `plugins/design-kit/`.
2. Bump `plugins/design-kit/.claude-plugin/plugin.json` `version`.
3. Bump `.claude-plugin/marketplace.json` `version` for the design-kit
   entry — must match the value in `plugin.json`.
4. `npm run validate` (verifies schema, catches drift).
5. `git commit && git push origin main`.

That's it. No tags, no cross-repo coordination.

## Why both files need to bump

`plugin.json` is the manifest the plugin ships with.
`marketplace.json` is the catalog clients compare against for cache
invalidation. If they drift, auto-update silently no-ops because the
manifest version comparison shows no delta. Both bump in lockstep, in
the same commit, every time.

## Why this repo was archived

The previous external-source pattern (`source: {github, repo, branch:main}`
in aiverse with code living in this repo) created a cross-repo
version-drift class of bug — the marketplace.json `version` field had
to be manually kept in sync with this repo's `plugin.json`, and when
they drifted, auto-update broke for users with no clear signal why.

Bundling design-kit into aiverse matches what every other public plugin
marketplace does (anthropics/skills, anthropics/claude-code,
loft-sh/ai-skills) and makes drift impossible: plugin code and
marketplace catalog land in the same commit on the same repo.
