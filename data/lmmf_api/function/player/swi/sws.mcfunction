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

#切换步行速度应用开关
execute unless data storage lmmf_api:player swi.walkSpeed run data modify storage lmmf_api:player swi.walkSpeed set value true
execute if data storage lmmf_api:player swi.walkSpeed run data remove storage lmmf_api:player swi.walkSpeed
return 1
