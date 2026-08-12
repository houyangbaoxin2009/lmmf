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

# 调度器时钟: 每 tick 递增计数 (storage lmmf_api:schedule -> timer)
# 首次运行自动初始化 (data get 失败返回 0, store result 写入 1)
execute store result storage lmmf_api:schedule timer int 1 run data get storage lmmf_api:schedule timer

return 1
