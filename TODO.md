# TODO

Active tasks for this dotfiles repository.

## Bash Startup Optimization

Optimize bash startup time by implementing lazy-loading and conditional initialization.

- [x] **Lazy-load NVM** (HIGH) - Save ~200-500ms per shell startup
- [x] **Optimize SSH Agent** (MEDIUM) - Save ~50-100ms per shell startup
- [x] **Conditional Loading** (MEDIUM) - Save ~20-50ms per shell startup
- [x] **Add Profiling** (LOW) - Diagnostic tool for measuring startup time
- [x] **Cache starship/zoxide init** (MEDIUM) - Save ~20-40ms per shell startup

Results: **293ms → 66ms** (~77% improvement)

📋 **Implementation Details:** [docs/bash-startup-optimization.md](docs/bash-startup-optimization.md)

---

## VSCode Configuration

Reset and rebuild VSCode configuration following the dotfiles philosophy.

- [ ] **Backup current VSCode settings** (Phase 1) - Archive existing configuration
- [ ] **Wipe VSCode user config** (Phase 2) - Clean slate for rebuild
- [ ] **Rebuild minimal baseline** (Phase 3) - Start with essential settings only
- [ ] **Install extensions from zero** (Phase 4) - Core extensions only
- [ ] **Add necessary extension settings** (Phase 5) - Configure only what's needed
- [ ] **Decide dotfiles vs sync** (Phase 6) - Determine what belongs where
- [ ] **Check workspace-level config** (Phase 7) - Audit project-specific settings

📋 **Implementation Details:** [vscode/VSCODE-RESET-PLAN.md](vscode/VSCODE-RESET-PLAN.md)

---

## Task Status Legend

- ⬜ Not started
- 🔄 In progress
- ✅ Complete

---

## Notes

- Update task status by changing the checkbox: `[ ]` → `[x]`
- Detailed implementation plans are linked in each section
- Follow the execution order specified in each plan
- Run validation checks before committing changes