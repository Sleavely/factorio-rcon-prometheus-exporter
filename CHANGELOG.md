# Changelog

## [2.2.2](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v2.2.1...v2.2.2) (2025-07-07)


### Bug Fixes

* **factorio_available_items:** by default, dont export metric when players are online ([8c7ae6b](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/8c7ae6b22478a14b74043286068a8a51fe8e3be4))

## [2.2.1](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v2.2.0...v2.2.1) (2025-07-07)


### Bug Fixes

* **factorio_science_production_total:** account for infinite research levels ([8fb2b23](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/8fb2b23e37ea72071cadde356f28a8123e8f0665))

## [2.2.0](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v2.1.0...v2.2.0) (2025-07-06)


### Features

* factorio_available_items metric ([0e987d3](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/0e987d3e17a5d3ec25ba753c6f166fcb26da0bed))
* factorio_science_production_total metric ([1c0a434](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/1c0a434cd1d1a410d0574edb9d4cb3122868e614))

## [2.1.0](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v2.0.1...v2.1.0) (2025-06-25)


### Features

* add surface_type label to surface specific metrics ([f8fe59d](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/f8fe59d613cd326cc096964ff4f8b80550e59ce1))

## [2.0.1](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v2.0.0...v2.0.1) (2025-06-24)


### Bug Fixes

* use display names of surfaces in the labels ([adc107f](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/adc107fe1b511f682f233175877d5875622c6668))

## [2.0.0](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.1.0...v2.0.0) (2025-06-16)


### ⚠ BREAKING CHANGES

* rename metrics according to prometheus naming conventions

### Features

* factorio_electricity_accumulated_total, tracks batteries ([2812cc6](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/2812cc647fb2a1ab98359f01859d8fc5a101e116))
* factorio_kills_consumption_total and factorio_kills_production_total for all forces ([6fd734c](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/6fd734c535bf15d79a78529ce342881a5f214e72))


### Code Refactoring

* rename metrics according to prometheus naming conventions ([1a7d902](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/1a7d902942d32e7499b05220ef3f461558c43b60))

## [1.1.0](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.0.3...v1.1.0) (2025-06-08)


### Features

* fluid production statistics ([94a03f6](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/94a03f6a5fb6ab393175225cd57087bc2207cd0c))
* HELP and TYPE annotations. group by metric ([33da38f](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/33da38f5502fe7b5b479fbd8f63c4b735b489aca))


### Bug Fixes

* **http:** default to bind port 9772 ([1d0a4dd](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/1d0a4dd23904734fb55045a0e31aa449ef889d11))

## [1.0.3](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.0.2...v1.0.3) (2025-06-06)


### Bug Fixes

* set content headers for prometheus ([6514442](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/6514442e3b03df6c443377ba02e7abbcbda7335d))

## [1.0.2](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.0.1...v1.0.2) (2025-06-06)


### Bug Fixes

* include Lua scripts in build ([bb05a04](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/bb05a04c041c8d8b7fe83b2689980ba521c8e4b8))

## [1.0.1](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.0.0...v1.0.1) (2025-06-06)


### Miscellaneous Chores

* release 1.0.1 ([3b03e73](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/3b03e7310a449c5d37a7a2d451710a88e6f6380c))

## [1.0.0](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/compare/v1.0.0...v1.0.0) (2025-06-06)


### ⚠ BREAKING CHANGES

* Initial release

### Features

* Initial release ([3de6b8c](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/3de6b8c35cc5b55063d3f004c9db91a1c57938e8))


### Miscellaneous Chores

* release 1.0.0 ([d82b10d](https://github.com/Sleavely/factorio-rcon-prometheus-exporter/commit/d82b10d6bc1d8c1c0e40af37f6e5bfae4c672c9f))
