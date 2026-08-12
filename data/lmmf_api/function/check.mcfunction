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

#版本校验:比较各模块声明的 api 依赖版本与 lmmf_api 当前版本
scoreboard objectives add lmmf_api_check dummy
execute if data storage lmmf api_version run execute store result score #api_lmmf lmmf_api_check run data get storage lmmf api_version
execute if data storage lmmf_terra api_version run execute store result score #api_terra lmmf_api_check run data get storage lmmf_terra api_version

execute if score #api_lmmf lmmf_api_check > #api_version lmmf_api_check run tellraw @a [{"text":"[LMMF_API] ","color":"red"},{"text":"模块 lmmf 要求 api 版本 ","color":"yellow"},{"score":{"name":"#api_lmmf","objective":"lmmf_api_check"}},{"text":", 但当前版本为 ","color":"yellow"},{"score":{"name":"#api_version","objective":"lmmf_api_check"}}]
execute if score #api_terra lmmf_api_check > #api_version lmmf_api_check run tellraw @a [{"text":"[LMMF_API] ","color":"red"},{"text":"模块 lmmf_terra 要求 api 版本 ","color":"yellow"},{"score":{"name":"#api_terra","objective":"lmmf_api_check"}},{"text":", 但当前版本为 ","color":"yellow"},{"score":{"name":"#api_version","objective":"lmmf_api_check"}}]
scoreboard players reset #api_lmmf lmmf_api_check
scoreboard players reset #api_terra lmmf_api_check

return 1
