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

# 事件检测器: 每 tick 运行 (挂到 #lmmf_api:tick)
# 入服检测: 已入服标记为 0 的在线玩家触发入服事件, 随后打标
execute as @a if score @s lmmf_api_seen matches 0 run function lmmf_api:event/player_join
execute as @a run scoreboard players set @s lmmf_api_seen 1
# 昼夜检测
function lmmf_api:event/detect_day_night
# 维度切换检测
function lmmf_api:event/detect_dimension

return 1
