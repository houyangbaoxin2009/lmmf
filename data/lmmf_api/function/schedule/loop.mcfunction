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

# 循环执行 (宏: ticks 间隔刻数, function 目标函数)
# 用法: function lmmf_api:schedule/loop {ticks:100, function:"ns:path"}
# 约定: 目标函数末尾需再次调用 function lmmf_api:schedule/loop {ticks:N, function:"ns:path"} 续期, 形成循环
schedule function $(function) $(ticks)t

return 1
