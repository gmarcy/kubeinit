#!/bin/bash
set -ex

#############################################################################
#                                                                           #
# Copyright kubeinit contributors.                                          #
#                                                                           #
# Licensed under the Apache License, Version 2.0 (the "License"); you may   #
# not use this file except in compliance with the License. You may obtain   #
# a copy of the License at:                                                 #
#                                                                           #
# http://www.apache.org/licenses/LICENSE-2.0                                #
#                                                                           #
# Unless required by applicable law or agreed to in writing, software       #
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT #
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the  #
# License for the specific language governing permissions and limitations   #
# under the License.                                                        #
#                                                                           #
#############################################################################

rm -rf ./releases
mkdir -p ./releases

# Build and install the collection
rm -rf ~/.ansible/collections/ansible_collections/kubeinit/ansible
ansible-galaxy collection build -v --force --output-path releases/
ansible-galaxy collection install --force --force-with-deps releases/kubeinit-ansible-`cat galaxy.yml | shyaml get-value version`.tar.gz
cp galaxy.yml ~/.ansible/collections/ansible_collections/kubeinit/ansible/
cd ~/.ansible/collections/ansible_collections/kubeinit/ansible

export HOME=$(eval echo ~$USER)

ansible-test sanity \
    --skip-test ansible-doc \
    --skip-test validate-modules \
    --skip-test pylint \
    --skip-test shebang \
    --skip-test pep8 \
    -v --python 3.12
