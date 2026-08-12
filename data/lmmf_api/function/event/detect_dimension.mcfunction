# ----------------------------------------------------------------------------
# Copyright (c) 2026 FranJ2
#
# This file is part of the lmmf project.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

# 维度检测: 玩家维度变化触发事件
# 仅检测已入服玩家 (lmmf_api_seen=1), 避免首次进服误触发
# 先比对记录分数, 不一致则触发, 随后统一更新记录
execute as @a if score @s lmmf_api_seen matches 1 at @s if dimension minecraft:overworld unless score @s lmmf_api_dim matches 0 run function lmmf_api:event/dimension_change
execute as @a if score @s lmmf_api_seen matches 1 at @s if dimension minecraft:the_nether unless score @s lmmf_api_dim matches 1 run function lmmf_api:event/dimension_change
execute as @a if score @s lmmf_api_seen matches 1 at @s if dimension minecraft:the_end unless score @s lmmf_api_dim matches 2 run function lmmf_api:event/dimension_change
execute as @a at @s if dimension minecraft:overworld run scoreboard players set @s lmmf_api_dim 0
execute as @a at @s if dimension minecraft:the_nether run scoreboard players set @s lmmf_api_dim 1
execute as @a at @s if dimension minecraft:the_end run scoreboard players set @s lmmf_api_dim 2

return 1
