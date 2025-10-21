# Project Aurora Controller

Hybrid first-/third-person character controller prototype built in Godot 4.5 with an anime presentation focus.

## Current Status
- Modular `PlayerController`, `ThirdPersonCamera`, and unified debug overlay scenes wired into `main.tscn`.
- Walk / run / sprint tiers implemented with grounded tier locking and input toggles (`Z` for walk, `X` for sprint).
- Debug overlay (`T`) shows locomotion state, current tier, grounded flag, position readout, and includes a reset button when the mouse cursor is visible.
- Documentation updated in `docs/agent_info.md` outlining the Bethesda-style controller roadmap.

## Next Steps
- Add stamina hooks and terrain-based speed modifiers.
- Build dedicated slope and stair test scenes for traction tuning.
- Plan animation controller integration and secondary motion pipeline.
