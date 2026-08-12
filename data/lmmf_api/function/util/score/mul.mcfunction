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

#乘法: storage lmmf_api:util.score.a * .b 结果存分数(宏: obj, player)
scoreboard objectives add lmmf_api_util dummy
execute store result score #lmmf_a lmmf_api_util run data get storage lmmf_api:util score.a
execute store result score #lmmf_b lmmf_api_util run data get storage lmmf_api:util score.b
scoreboard players operation $(player) $(obj) = #lmmf_a lmmf_api_util
scoreboard players operation $(player) $(obj) *= #lmmf_b lmmf_api_util
execute store result storage lmmf_api:util score.result int 1 run scoreboard players get $(player) $(obj)

return 1
