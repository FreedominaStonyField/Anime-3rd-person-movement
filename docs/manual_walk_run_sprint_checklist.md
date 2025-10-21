# Manual Review — Walk / Run / Sprint Locomotion

Use this checklist after tuning changes to confirm the movement tier system and debug tooling behave correctly.

## Setup
- [ ] Project launches into `main.tscn` without warnings or errors.
- [ ] Input map includes `move_walk` (Z), `move_sprint` (X), `debug_toggle_menu` (T).
- [ ] Debug overlay reset button hidden on start; metrics panel hidden.

## Locomotion Tiers
- [ ] Default run speed feels responsive; player stops promptly when input released.
- [ ] Holding `Z` forces walk tier at reduced speed and emits tier change in debug overlay.
- [ ] Holding `X` while moving engages sprint tier, increases speed, and reverts to run when released.
- [ ] Tier transitions do not cause jitter or unwanted acceleration spikes.
- [ ] Idle state reached when releasing input; no residual sliding.
- [ ] Airborne state triggers during jumps/falls and returns to ground state on landing.

## Debug & Telemetry
- [ ] Pressing `T` toggles the debug overlay metrics panel.
- [ ] Panel lists current state, tier, and grounded flag updating in real time.
- [ ] Metrics panel closes on `T` and remains hidden when mouse recaptured via click.
- [ ] Position readout updates every frame; reset button only appears when mouse is visible.

## Edge Cases
- [ ] Reset button respawns player and updates debug readouts immediately.
- [ ] Sprint + jump behaves as expected (no stuck sprint state on landing).
- [ ] Walk/sprint modifiers do not alter tier mid-air; landing with modifier held restores the correct tier.
- [ ] Rapid toggling between walk/run/sprint does not break camera alignment.

Record tuning notes (acceleration, deceleration, per-terrain adjustments) alongside this checklist for future passes.
