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

# 昼夜检测: 时间跨阈值触发, 状态记录防重复
# 白天 1000..11999, 夜晚 13000..22999, 其余为过渡窗口(状态保持)
# #lmmf_is_day: 0=夜晚, 1=白天 (仅在昼夜交替时触发一次事件)
execute store result score #lmmf_time lmmf_api_event run time query daytime
execute if score #lmmf_time lmmf_api_event matches 1000..11999 if score #lmmf_is_day lmmf_api_event matches 0 run function lmmf_api:event/day
execute if score #lmmf_time lmmf_api_event matches 1000..11999 run scoreboard players set #lmmf_is_day lmmf_api_event 1
execute if score #lmmf_time lmmf_api_event matches 13000..22999 if score #lmmf_is_day lmmf_api_event matches 1 run function lmmf_api:event/night
execute if score #lmmf_time lmmf_api_event matches 13000..22999 run scoreboard players set #lmmf_is_day lmmf_api_event 0

return 1
