#!/usr/bin/env bash
set -x

# cp startup files into place
cp /opt/conf/profile.d/*.sh /etc/profile.d/

declare -a components

cd /opt
components=('ant' 'nutch')
for component in "${components[@]}"
do
  source <(grep = <(grep -A5 "\[$component\]" /opt/conf/components.ini))
  download_file=$(basename "${download_url}")
  echo "${component} : ${version} : ${download_file} ${install_dir} ${download_url}"

  # skip if symlink exists
  if [ -L "${component}" ]; then
    echo "${component} already installed"
    continue
  fi

  # download file 
  if [ ! -f "${download_file}" ]; then
    wget -q "${download_url}"
  else 
    echo "${download_file} already downloaded"
  fi

  # check download file checksum
  if [ "$(sha512sum < ${download_file})" != "$sha512sum  -" ]; then
    echo "ERROR: sha512sum ${download_file} incorrect"
    exit 1
  fi

  # extract, link, delete download file  
  install_dir=$(tar -tzf "${download_file}" | head -1 | cut -f1 -d"/")
  tar -xzf "${download_file}"
  if [ -d "${install_dir}" ]; then
    ln -sf $install_dir $component
    rm "${download_file}"
  fi

done
