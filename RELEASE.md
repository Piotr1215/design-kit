# Releasing design-kit

The aiverse marketplace tracks design-kit's `main` branch. Pushing to
main ships the change to all users on their next marketplace refresh.

## Steps

1. Bump `version` in `.claude-plugin/plugin.json` (e.g. `0.1.3` → `0.1.4`).
2. Commit and push to `main`:

   ```bash
   git add .claude-plugin/plugin.json <other-changed-files>
   git commit -m "<conventional message>"
   git push origin main
   ```

That's it. No tags, no marketplace edit, no aiverse PR.

## Why bump `plugin.json` version

Auto-update detects new payloads by comparing the cached plugin
manifest's `version` against the resolved one. If you don't bump it,
users on the prior version see no delta and stay on stale code even
after the marketplace catalog refreshes.

If you only changed docs or comments and don't care if users pick up
the change immediately, you can skip the bump — the next real release
will sweep it along with the SHA delta.

## Auto-update isn't always automatic

`autoUpdate: true` on the marketplace doesn't reliably fire on every
Claude Code restart. If users want the change immediately, they can
force a refresh:

```
/plugin marketplace update aiverse
```

This is a Claude Code limitation, not a design-kit concern.
