###############################################################################
# Copyright (c) 2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Require UtilityLib.rb path.
require File.expand_path('../../lib/utilitylib.rb', __FILE__)

# Method to create a manifest for bgp neighbor with attributes:
# @param name [String] Name of the bgp neighbor.
# @param tests [Hash] a hash that contains the supported attributes
# @result none [None] Returns no object.
def create_aaaauthelogin_manifest(tests, name)
  tests[name][:manifest] = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
  node default {
    cisco_aaa_authentication_login { '#{name}':\n
    #{prop_hash_to_manifest(tests[name][:manifest_props])}
  }\n      }\n EOF"
end
