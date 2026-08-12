# lmmf_api 示例模块模板

这是一个完整的示例模块，展示如何接入 lmmf_api 框架。

> **注意**：此目录是模板，不是可加载的数据包。请勿把 `docs/example/` 放入存档的 `datapacks/` 目录。

## 接入步骤

1. 把 `example_mod` 的命名空间改成你自己的（如 `mypack`）
2. 复制 `data/` 目录到你的数据包
3. 把 `data/lmmf_api/tags/function/*.json` 合并进你数据包的同名文件（追加你的函数，replace 必须为 false）

## 模块契约

每个模块必须有三个函数：

- `ver`：写版本 + 内核版本 + api 依赖版本
- `load`：模块加载逻辑
- `unload`：模块卸载清理

这三个函数分别追加到 `#lmmf_api:ver`、`#lmmf_api:load`、`#lmmf_api:unload` 标签（`replace: false`），由 lmmf_api 框架统一调度。

## 事件

lmmf_api 提供 `#lmmf_api:on_*` 事件标签。本示例在 `#lmmf_api:on_player_join` 中注册了 `on_join`，演示：

- 入服事件（玩家 `@s` 入服时执行）
- lmmf_api 工具宏：`function lmmf_api:util/item/give {item_id:..., item_count:...}`

## 目录结构

```
docs/example/
├── pack.mcmeta
├── README.md
└── data/
    ├── example_mod/
    │   └── function/
    │       ├── ver.mcfunction       # 模块版本函数（写版本/内核版本/api 依赖版本）
    │       ├── load.mcfunction      # 模块加载函数
    │       ├── unload.mcfunction    # 模块卸载清理函数
    │       ├── on_join.mcfunction   # 入服事件处理（欢迎消息 + 给礼物）
    │       └── give_gift.mcfunction # 调用 lmmf_api 工具宏给物品
    └── lmmf_api/
        └── tags/function/
            ├── ver.json             # 追加 example_mod:ver（replace:false）
            ├── load.json            # 追加 example_mod:load（replace:false）
            ├── unload.json          # 追加 example_mod:unload（replace:false）
            └── on_player_join.json  # 追加 example_mod:on_join（replace:false）
```

## 示例效果

玩家入服时收到一条绿色 `[欢迎] 欢迎来到服务器!` 消息，并获得 1 个苹果。
