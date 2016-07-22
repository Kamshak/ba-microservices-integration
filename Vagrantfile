$script = <<SCRIPT
  # Packages
  apt-get update
  apt-get install -y python-pip python python-dev curl git build-essential

  #Docker
  if [ -z $(which docker) ]; then \
    curl -sSL https://get.docker.com/ | sh
  fi
  sudo usermod -aG docker vagrant

  #Kubernetes

  # Prepare Docker Copyright 2015 Google Inc. Licensed unter Apache License, Version 2.0 (https://raw.githubusercontent.com/cheld/dashboard/0de08eca9451be1a94adfc8b33d7d1970bfecf77/build/setup-docker.sh)
  # check sudo and enable mount propagation

  DOCKER_CONF=$(systemctl cat docker | head -1 | awk '{print $2}')
  sed -i.bak 's/^\(MountFlags=\).*/\1shared/' $DOCKER_CONF
  systemctl daemon-reload
  systemctl restart docker

  mkdir -p /var/lib/kubelet
  mount --bind /var/lib/kubelet /var/lib/kubelet
  mount --make-shared /var/lib/kubelet

  # End Google Inc. Code

  export K8S_VERSION=$(curl -sS https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  export ARCH=amd64
  docker run -d \
      --volume=/:/rootfs:rw \
      --volume=/sys:/sys:rw \
      --volume=/var/lib/docker/:/var/lib/docker:rw \
      --volume=/var/lib/kubelet:/var/lib/kubelet:rw,shared  \
      --volume=/var/run:/var/run:rw \
      --net=host \
      --pid=host \
      --privileged \
      -d \
      gcr.io/google_containers/hyperkube-${ARCH}:${K8S_VERSION} \
      /hyperkube kubelet \
          --hostname-override=127.0.0.1 \
          --api-servers=http://localhost:8080 \
          --config=/etc/kubernetes/manifests \
          --cluster-dns=10.0.0.10 \
          --cluster-domain=cluster.local \
          --allow-privileged=true --v=2

  # Jinja CLI
  if [ -z $(which jinja2) ]; then \
    git clone https://github.com/Kamshak/jinja2-cli.git
    pushd jinja2-cli
    python setup.py install
    popd
    pip install toml
  fi

  if [ -z $(which kubectl) ]; then \
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
  fi

  # AWS Cli
  sudo pip install awscli

  sudo su vagrant
  kubectl config set-cluster localcluster --server=http://localhost:8080
  kubectl config set-context localcluster --cluster=localcluster
  kubectl config use-context localcluster

  # Node/gulp required for E2E Tests
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  apt-get install -y nodejs build-essential
  npm install -g npm@latest
  npm install -g gulp

  cd vagrant
  sudo -u vagrant -H bash -c 'git submodule update --init --recursive'
  sudo -u vagrant -H bash -c 'cd /vagrant/deployment-tool && npm install --no-bin-links'

  sudo -u vagrant -H bash -c "grep -q -F 'export AWS_REGION=eu-west-1' /home/vagrant/.bashrc || echo 'export AWS_REGION=eu-west-1' >> /home/vagrant/.bashrc"
  sudo -u vagrant -H bash -c "grep -q -F 'export AWS_REGISTRY_URL=277555456074.dkr.ecr.eu-west-1.amazonaws.com' /home/vagrant/.bashrc || echo 'export AWS_REGISTRY_URL=277555456074.dkr.ecr.eu-west-1.amazonaws.com' >> /home/vagrant/.bashrc"

  echo "Done with setup. Configure AWS CLI using aws config and execute update_service_endpoints"
  echo "Next run ./replace_templates.sh | node deployment-tool/index.js"
SCRIPT

Vagrant.configure("2") do |config|
  # Settings for the VM
  config.vm.box = "geerlingguy/ubuntu1604"
  config.vm.network :private_network, ip: "192.168.10.13"

  config.vm.provider :virtualbox do |virtualbox|
    # allocate 1024 mb RAM
    virtualbox.customize ["modifyvm", :id, "--memory", "1024"]
    # allocate max 50% CPU
    virtualbox.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  # Local Kubernetes Environment
  config.vm.provision "shell", privileged:true, inline: $script

  # To tunnel kubernetes: vagrant ssh -- -L 8080:localhost:8080
end
