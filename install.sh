#!/usr/bin/env bash
set -euo pipefail

# Design-Kit Installation Script
# Installs command templates and helper scripts to ~/.claude/

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Design-Kit Installer"
echo "  Test-Driven Parallel Development Framework"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "❌ ERROR: git is not installed. Please install git first."
    exit 1
fi

echo "📦 Installing Design-Kit..."
echo ""

# Create directories if needed
echo "  → Creating directories in ~/.claude/"
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/design-kit

# Copy command templates (always overwrite for updates)
echo "  → Installing command templates..."
cp -f templates/commands/*.md ~/.claude/commands/
echo "     ✓ /norm-plan"
echo "     ✓ /norm-research"
echo "     ✓ /norm-integrate"
echo "     ✓ /norm-tasks"
echo "     ✓ /norm-task"

# Copy scripts to design-kit directory
echo "  → Installing helper scripts..."
cp -f scripts/auto-connect-design.sh ~/.claude/design-kit/
cp -f scripts/list-tasks.sh ~/.claude/design-kit/
cp -f scripts/show-task.sh ~/.claude/design-kit/
chmod +x ~/.claude/design-kit/*.sh
echo "     ✓ auto-connect-design.sh"
echo "     ✓ list-tasks.sh"
echo "     ✓ show-task.sh"

# Clean up legacy branch-based init.sh from older installs (now dead — superseded by auto-connect-design.sh --init <slug>)
if [[ -f ~/.claude/design-kit/init.sh ]]; then
    rm -f ~/.claude/design-kit/init.sh
    echo "     ✓ removed legacy init.sh (use 'auto-connect-design.sh --init <slug>' instead)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Design-Kit Successfully Installed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Available Commands:"
echo "  /norm-plan      - Create master plan with phases"
echo "  /norm-research  - Generate Phase 1 parallel proof tasks"
echo "  /norm-integrate - Generate Phase 2 integration tasks"
echo "  /norm-tasks     - List all tasks with paths and status"
echo "  /norm-task [ID] - View/work on specific task (e.g., /norm-task A)"
echo ""
echo "💡 Quick Start:"
echo "  1. Navigate to a repo that participates in your project"
echo "  2. Start planning: /norm-plan \"Your project description\""
echo "     (writes plan to ~/.claude/specs/<slug>/, drops a per-repo pointer)"
echo "  3. To bind a second repo to the same project:"
echo "     ~/.claude/design-kit/auto-connect-design.sh --init <slug>"
echo ""
echo "🎯 Core Philosophy:"
echo "  • Test-driven: Run 100+ tests before writing docs"
echo "  • Parallel execution: Independent component validation"
echo "  • Contract-based: Black-box integration via CONTRACT.md"
echo ""
echo "📚 Documentation:"
echo "  README: https://github.com/Piotr1215/design-kit"
echo "  Philosophy: design-driven.md"
echo ""
echo "🚀 Happy building with Design-Kit!"
echo ""