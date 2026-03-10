# Changelog

## 0.0.1 (2026-03-10)


### Features

* **os-image:** bake config and publish qcow2-only release assets ([#14](https://github.com/crescendo-ops/vm-vyos/issues/14)) ([b6310c6](https://github.com/crescendo-ops/vm-vyos/commit/b6310c6866b618d75032e16d1fb5473b5b52cc82))
* **repo:** initial split from home-infra (vyos) ([60787ef](https://github.com/crescendo-ops/vm-vyos/commit/60787ef32e3adc1f4df315a43ab1da1e71ee8e39))


### Bug Fixes

* **ci:** bump vyos commit pin workflow ([#10](https://github.com/crescendo-ops/vm-vyos/issues/10)) ([e99b2cd](https://github.com/crescendo-ops/vm-vyos/commit/e99b2cd6fa3a56ad43761a920848b34b766f8831))
* **ci:** simplify vyos release asset publish step ([#6](https://github.com/crescendo-ops/vm-vyos/issues/6)) ([fb55800](https://github.com/crescendo-ops/vm-vyos/commit/fb5580092e74ef80a0dc28b29b06c5e4f6150e04))
* **release-assets:** skip unreadable and duplicate upload files ([#5](https://github.com/crescendo-ops/vm-vyos/issues/5)) ([2defc52](https://github.com/crescendo-ops/vm-vyos/commit/2defc52b90424303f90e737d56bd74db1ecd2274))
* **vyos-router:** rename vyos build git ref variable ([#7](https://github.com/crescendo-ops/vm-vyos/issues/7)) ([43388cf](https://github.com/crescendo-ops/vm-vyos/commit/43388cf5bacaac810c7b71323a7f254256f4a6fa))


### Dependencies

* **vyos:** bump vyos-1x to 124304285eef ([#12](https://github.com/crescendo-ops/vm-vyos/issues/12)) ([ee08acc](https://github.com/crescendo-ops/vm-vyos/commit/ee08accb290898b305bebae0c105522ee6225078))
* **vyos:** downgrade vyos-1x commit pin ([bddac52](https://github.com/crescendo-ops/vm-vyos/commit/bddac5260506575c4ed6d11fe59dd6dcc5b2cbf1))


### Documentation

* **agents:** align PR typing and commit subject rules ([#16](https://github.com/crescendo-ops/vm-vyos/issues/16)) ([e8fdc1d](https://github.com/crescendo-ops/vm-vyos/commit/e8fdc1d35d35ec7fd42df5dae561c9b1e6837436))


### Miscellaneous Chores

* **release:** include all commit types in release notes ([#13](https://github.com/crescendo-ops/vm-vyos/issues/13)) ([31a8e85](https://github.com/crescendo-ops/vm-vyos/commit/31a8e85cb49bc2ae935bb53972a4b13cb9b39bf7))
* **terraform:** remove legacy vyos-router files and update ignores ([#17](https://github.com/crescendo-ops/vm-vyos/issues/17)) ([718a4cf](https://github.com/crescendo-ops/vm-vyos/commit/718a4cf44387dbb4788cede70c4fd85dbeef4ee7))
* **vm-deploy:** centralize VyOS config artifacts under config ([#15](https://github.com/crescendo-ops/vm-vyos/issues/15)) ([30cae13](https://github.com/crescendo-ops/vm-vyos/commit/30cae13896854d047db270806b69d9ac78b62e67))


### Build System

* **os-image:** migrate build layout and release asset paths ([#8](https://github.com/crescendo-ops/vm-vyos/issues/8)) ([67911c5](https://github.com/crescendo-ops/vm-vyos/commit/67911c50986642efcd176c9060f0f398332aa1a0))


### Continuous Integration

* **release:** port host-chopin release pipeline updates ([#4](https://github.com/crescendo-ops/vm-vyos/issues/4)) ([f2a65cb](https://github.com/crescendo-ops/vm-vyos/commit/f2a65cb4d03bd18ac28328616c114c0ccbd21772))
* **vyos:** automate weekly deps-based vyos pin upgrades ([#9](https://github.com/crescendo-ops/vm-vyos/issues/9)) ([3d9797c](https://github.com/crescendo-ops/vm-vyos/commit/3d9797cd1a7c06e8eb336c2e47424292fb943821))
* **vyos:** port host-chopin workflows and release flow ([#2](https://github.com/crescendo-ops/vm-vyos/issues/2)) ([7c90506](https://github.com/crescendo-ops/vm-vyos/commit/7c90506cfab574426251fe67074fe761b1855166))
