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

#模块清单:列出所有已注册模块及其版本
tellraw @s [{"text":"[LMMF_API] ","color":"dark_aqua"},{"text":"已加载模块:","color":"white"}]
execute if data storage lmmf version run tellraw @s [{"text":"  - lmmf ","color":"green"},{"text":"v","color":"gray"},{"nbt":"version","storage":"lmmf","interpret":false},{"text":" (内核 ","color":"gray"},{"nbt":"core_version","storage":"lmmf","interpret":false},{"text":")","color":"gray"}]
execute if data storage lmmf_terra version run tellraw @s [{"text":"  - lmmf_terra ","color":"green"},{"text":"v","color":"gray"},{"nbt":"version","storage":"lmmf_terra","interpret":false},{"text":" (内核 ","color":"gray"},{"nbt":"core_version","storage":"lmmf_terra","interpret":false},{"text":")","color":"gray"}]
execute if data storage lmmf_api version run tellraw @s [{"text":"  - lmmf_api ","color":"green"},{"text":"v","color":"gray"},{"nbt":"version","storage":"lmmf_api","interpret":false},{"text":" (内核 ","color":"gray"},{"nbt":"core_version","storage":"lmmf_api","interpret":false},{"text":")","color":"gray"}]

return 1
