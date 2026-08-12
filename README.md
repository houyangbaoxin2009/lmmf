# LMMF (Let's Make Minecraft Fun)

LMMF 是一个 Minecraft Java 版数据包项目，核心是 **lmmf_api**：一个「便于开发的框架」前置库。它把「模块注册、生命周期管理、玩家属性读写、调度、事件、通用工具」这些数据包开发中反复要写的东西收拢成一套约定，第三方数据包只需遵循模块契约即可接入，不用再自己造轮子。

`lmmf` 与 `lmmf_terra` 是它的两个官方模块，分别承载核心内容与世界生成，同时也是「如何写一个模块」的现成范例。

## 架构

数据包通过原版 `minecraft:load` 与 `minecraft:tick` 标签挂载框架：

```
minecraft:load → lmmf_api:load
                 ├─ lmmf_api:init      → ver + player/ver（写框架自身版本）
                 ├─ lmmf_api:event/init（事件系统 objective 初始化）
                 ├─ #lmmf_api:ver      → lmmf:ver + lmmf_terra:ver（各模块写版本）
                 ├─ #lmmf_api:load     → lmmf:load + lmmf_terra:load（加载模块）
                 ├─ check              → 版本兼容校验
                 └─ say 加载完成
minecraft:tick → lmmf_api:tick → #lmmf_api:tick
                 ├─ schedule/tick（调度器时钟，每 tick +1）
                 └─ event/detect（事件自动检测）
```

`lmmf_api:load` 是唯一入口：先写自身版本，再调用所有模块的 `ver` 与 `load`，最后用 `check` 校验模块声明的 api 依赖版本。`minecraft:tick` 每 tick 调用 `lmmf_api:tick`，由 `#lmmf_api:tick` 标签驱动调度器时钟与事件检测。

### 命名空间

| 命名空间 | 职责 |
|---|---|
| `lmmf_api` | 框架本体（前置库）：模块注册、Player API、调度器、事件系统、工具 API |
| `lmmf` | 官方模块：核心内容 |
| `lmmf_terra` | 官方模块：世界生成 |
| `minecraft` | 原版覆盖：`load`/`tick` 标签挂载点、配方、世界预设 |

## 模块契约（接入 lmmf_api）

每个模块必须有三个函数，构成完整生命周期：

| 函数 | 职责 | 示例 |
|---|---|---|
| `ver` | 写常规版本 + 内核版本 + api 依赖版本 | `function lmmf:ver` |
| `load` | 模块加载逻辑（初始化 objective、storage 等） | `function lmmf:load` |
| `unload` | 模块卸载清理（与 load 对称，删掉自己创建的一切） | `function lmmf:unload` |

`lmmf:ver` 完整示例：

```mcfunction
#常规版本代号
scoreboard objectives add lmmf_var dummy
scoreboard players set lmmfapi lmmf_var 1
data modify storage lmmf version set value 1
#内核版本代号
scoreboard objectives add lmmf_cver dummy
scoreboard players set lmmfapi lmmf_cver 1
data modify storage lmmf core_version set value 1
#api 依赖版本
data modify storage lmmf api_version set value 1
#成功
return 1
```

每个 `.mcfunction` 文件头部都带有 Apache 2.0 许可头（`# Copyright (c) 2026 FranJ2` + License 原文），新模块同样建议带上。

## 接入步骤（第三方模块）

三步完成接入：

**1. 提供 ver/load/unload 三件套**

在你自己命名空间的 `function/` 下创建三个函数。`ver` 写版本（含 `api_version`），`load` 做初始化，`unload` 做对称清理。写 storage 时使用自己的命名空间（如 `storage mymod version`），不要碰框架的 `storage lmmf_api`。

**2. 追加到 lmmf_api 的注册表标签**

把三个函数分别追加进 `#lmmf_api:ver`、`#lmmf_api:load`、`#lmmf_api:unload` 标签。以 `ver` 为例（`data/lmmf_api/tags/function/ver.json`）：

```json
{
    "replace": false,
    "values": [
        "mymod:ver"
    ]
}
```

> 警告：`replace` 必须为 `false`。设为 `true` 会抹掉框架已注册的所有模块，导致其他模块失效。

**3. 数据包命名排序保证 lmmf_api 先加载**

- 模块数据包不要覆盖 `minecraft:load` / `minecraft:tick` 标签（确需追加时用 `replace: false`）。
- 建议给数据包命名排序（如 `00_lmmf_api`、`01_mymod`），保证 lmmf_api 优先加载、避免文件冲突时覆盖框架本体。

**注意事项**

- 命名空间隔离：storage、scoreboard objective 一律用自己的前缀，禁止写进 `lmmf_api` / `minecraft` 命名空间。
- 卸载对称性：`unload` 必须删除 `load` 创建的所有 objective 与 storage 数据。
- 不要修改 lmmf_api 本体：需要新能力请通过标签注册或向项目提需求，改动框架会让所有模块的版本校验失效。

## 生命周期

| 命令 | 效果 |
|---|---|
| `/function lmmf_api:load` | 加载所有注册模块（写版本 → 事件初始化 → 加载 → 版本校验） |
| `/function lmmf_api:unload` | 卸载所有模块，并清理框架自身状态 |
| `/function lmmf_api:reload` | 重载（先 unload 再 load） |
| `/function lmmf_api:list` | 查看模块清单与版本 |
| `/function lmmf_api:help` | 帮助：文档链接与常用调用速查 |

## Player API

Player API 提供 13 个玩家属性，每个属性都有 get / run / swi 三个函数：

- **get**：把玩家 NBT 读到 `storage lmmf_api:player`（只读，随时可安全调用）
- **run**：把 storage 中的值写回玩家实体（改玩家数据）
- **swi**：切换某个属性的应用开关（storage 里 `swi.<key>` 标记的存在与否）

| 属性 | get 函数 | run 函数 | swi 函数 | storage 键 |
|---|---|---|---|---|
| 饥饿值 | `lmmf_api:player/get/food_level` | `run/rfl` | `swi/sfl` | `foodLevel` |
| 食物饱和度 | `get/food_saturation_level` | `run/rfsl` | `swi/sfsl` | `foodSaturationLevel` |
| 食物消耗度 | `get/food_exhaustion_level` | `run/rfel` | `swi/sfel` | `foodExhaustionLevel` |
| 食物计时器 | `get/food_tick_timer` | `run/rftt` | `swi/sftt` | `foodTickTimer` |
| 生命值 | `lmmf_api:player/get/health` | `run/rh` | `swi/sh` | `health` |
| 经验等级 | `get/xp_level` | `run/rxl` | `swi/sxl` | `xpLevel` |
| 经验进度 | `get/xp_progress` | `run/rxp` | `swi/sxp` | `xpProgress` |
| 总经验 | `get/xp_total` | `run/rxt` | `swi/sxt` | `xpTotal` |
| 位置 | `get/pos` | `run/rp` | `swi/sp` | `pos` |
| 朝向 | `get/rotation` | `run/rr` | `swi/sr` | `rotation` |
| 状态效果 | `get/effects` | `run/re` | `swi/se` | `effects` |
| 步行速度 | `get/walk_speed` | `run/rws` | `swi/sws` | `walkSpeed` |
| 飞行速度 | `get/fly_speed` | `run/rfs2` | `swi/sfs2` | `flySpeed` |

所有函数都以执行者 `@s` 为目标，调用前先 `execute as <玩家> run ...`。get 之后可按需修改 storage 中的值，再 run 写回。

饥饿值三件套示例：

```mcfunction
# get：读玩家饥饿值到 storage，并输出当前值
data modify storage lmmf_api:player foodLevel set from entity @s foodLevel
execute run data get entity @s foodLevel

# run：把 storage 中的饥饿值应用到玩家
execute if data storage lmmf_api:player foodLevel run data modify entity @s foodLevel set from storage lmmf_api:player foodLevel
return 1

# swi：切换饥饿值应用开关
execute unless data storage lmmf_api:player swi.foodLevel run data modify storage lmmf_api:player swi.foodLevel set value true
execute if data storage lmmf_api:player swi.foodLevel run data remove storage lmmf_api:player swi.foodLevel
return 1
```

## 调度器

| 函数 | 说明 |
|---|---|
| `lmmf_api:schedule/delay` | 延迟执行（宏：`ticks` 延迟刻数，`function` 目标函数） |
| `lmmf_api:schedule/loop` | 循环执行（宏同上；约定目标函数末尾再次调用 loop 续期，形成循环） |
| `lmmf_api:schedule/tick` | 框架时钟：每 tick 给 `storage lmmf_api:schedule timer` 加 1，挂载在 `#lmmf_api:tick` |

调用示例：

```mcfunction
# 100 刻后执行 my_func
function lmmf_api:schedule/delay {ticks:100, function:"example:my_func"}

# 每 20 刻（1 秒）循环执行 my_loop
function lmmf_api:schedule/loop {ticks:20, function:"example:my_loop"}
```

循环约定：`my_loop` 的末尾需要再次调用 `function lmmf_api:schedule/loop {ticks:20, function:"example:my_loop"}` 为自己续期，否则循环在当次执行后停止。

## 事件系统

| 事件 | 触发方式 | 注册标签 |
|---|---|---|
| 玩家入服 | 自动检测 | `#lmmf_api:on_player_join` |
| 玩家死亡 | 手动 | `#lmmf_api:on_player_death` |
| 白天 | 自动检测 | `#lmmf_api:on_day` |
| 夜晚 | 自动检测 | `#lmmf_api:on_night` |
| 维度切换 | 自动检测 | `#lmmf_api:on_dimension_change` |

自动检测由挂在 `#lmmf_api:tick` 上的 `lmmf_api:event/detect` 完成：

- **玩家入服**：扫描 `lmmf_api_seen = 0` 的在线玩家触发一次，随后打标（`@s` 为入服玩家）。
- **白天 / 夜晚**：按游戏时间跨阈值触发一次（白天 1000..11999，夜晚 13000..22999），状态防重复。
- **维度切换**：比对玩家实际维度与记录分数，变化时触发（执行上下文为切换维度的玩家）。

手动触发对应的事件函数即可：`function lmmf_api:event/player_join`、`function lmmf_api:event/player_death`、`function lmmf_api:event/day`、`function lmmf_api:event/night`、`function lmmf_api:event/dimension_change`。

注册处理函数：把函数追加进事件标签。以玩家入服为例（`data/lmmf_api/tags/function/on_player_join.json`）：

```json
{
    "replace": false,
    "values": [
        "mymod:on_join"
    ]
}
```

`replace: false` 同样强制，确保不会清掉其他模块注册的处理函数。

## 工具 API（util）

所有工具宏都以执行者 `@s` 为目标，用宏参数调用：

| 函数 | 宏参数 | 说明 |
|---|---|---|
| `lmmf_api:util/msg` | 无（读 storage） | 把 `storage lmmf_api:util message` 发给执行者 |
| `lmmf_api:util/msg_all` | 无（读 storage） | 把 `storage lmmf_api:util message` 广播给所有玩家 |
| `lmmf_api:util/random` | `max` | 生成随机整数存入 `storage lmmf_api:util random` |
| `lmmf_api:util/item/give` | `item_id`, `item_count` | 给执行者物品 |
| `lmmf_api:util/item/take` | `item_id`, `item_count` | 从执行者拿走物品 |
| `lmmf_api:util/particle/show` | `particle` | 在执行者位置播放粒子 |
| `lmmf_api:util/sound/play` | `sound` | 给执行者播放音效 |
| `lmmf_api:util/bossbar/create` | `id`, `title` | 创建 bossbar |
| `lmmf_api:util/bossbar/remove` | `id` | 移除 bossbar |
| `lmmf_api:util/bossbar/set` | `id`, `value`, `max` | 设置 bossbar 数值与最大值 |
| `lmmf_api:util/region/in_box` | `x1,y1,z1,x2,y2,z2` | 检测执行者是否在方盒内，结果 byte 存 `storage lmmf_api:util region_result` |
| `lmmf_api:util/region/in_sphere` | `cx,cy,cz,radius` | 检测执行者是否在球体内，结果存 `storage lmmf_api:util region_result` |

调用示例：

```mcfunction
# 给玩家一个苹果
function lmmf_api:util/item/give {item_id:"minecraft:apple",item_count:1}

# 播放升级音效
function lmmf_api:util/sound/play {sound:"minecraft:entity.player.levelup"}

# 生成 0..100 的随机数，结果在 storage lmmf_api:util random
function lmmf_api:util/random {max:100}

# 发消息：先写 storage，再调用 msg
data modify storage lmmf_api:util message set value [{"text":"你好","color":"green"}]
function lmmf_api:util/msg

# 广播消息
data modify storage lmmf_api:util message set value [{"text":"全服公告","color":"yellow"}]
function lmmf_api:util/msg_all

# 区域检测：执行者在球内时 region_result 为 1，否则 0
function lmmf_api:util/region/in_sphere {cx:0,cy:64,cz:0,radius:20}
execute if data storage lmmf_api:util {region_result:1b} run say 我在区域内
```

## 版本机制

每个模块维护三个版本号，写入自己的 storage 命名空间：

- **常规版本** `version`：模块发布代号。
- **内核版本** `core_version`：内部实现代号。
- **api 依赖版本** `api_version`：模块要求的 lmmf_api 版本。

lmmf_api 加载时执行 `lmmf_api:check`：读取各模块声明的 `api_version`，与 lmmf_api 自身的 `version` 比对。若模块要求的新于当前框架，会向所有玩家发出红色告警（说明「模块 X 要求 api 版本 Y，但当前版本为 Z」）。版本冲突时请升级 lmmf_api，而不是降级模块。

查看当前各模块版本：`/function lmmf_api:list`。

## 示例模块

`docs/example/` 是一份完整的示例模块模板（命名空间 `example_mod`），包含：

- `ver` / `load` / `unload` 三件套
- 事件处理 `on_join`（入服时发欢迎消息 + 给一个苹果）
- 三个注册表标签与 `on_player_join` 事件标签的 `replace: false` 追加写法
- 工具宏调用范例（`util/item/give`）

说明文档见 `docs/example/README.md`。注意该目录是模板，不是可加载的数据包，请勿把 `docs/example/` 放进存档的 `datapacks/` 目录。

## 开发

- **数据包格式**：`min_format` 88，`max_format` 200（对应 1.20.5 及以后版本）。
- **许可**：Apache License 2.0，每个文件带许可头。
- **更新日志**：见 `CHANGELOG.md`。
