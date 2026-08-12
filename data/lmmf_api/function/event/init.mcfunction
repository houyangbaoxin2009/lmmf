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

# 事件系统初始化: 创建 objective
# lmmf_api_event: 昼夜状态/时间临时分数 (#lmmf_time, #lmmf_is_day)
# lmmf_api_online: 玩家在线标记 (预留)
# lmmf_api_seen: 玩家已入服标记 (0=未入服, 1=已入服)
# lmmf_api_dim: 玩家当前维度 (0=主世界, 1=下界, 2=末地)
scoreboard objectives add lmmf_api_event dummy
scoreboard objectives add lmmf_api_online dummy
scoreboard objectives add lmmf_api_seen dummy
scoreboard objectives add lmmf_api_dim dummy

return 1
