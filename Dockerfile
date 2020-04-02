# Ansible, Azure & Fission require ubuntu
FROM ubuntu

# Install common prereqs for packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    tar \
    python3-pip

# Install terraform cli for managing IaC
RUN curl -Lo terraform.zip https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip && \
    unzip terraform.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/

# Install kubectl cli for managing k8s clusters
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/  

# Install helm cli for managing packages to install in k8s
RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz && \
    tar -zxvf helm.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/
    # && \
    # helm init --client-only

# Install fission cli for managing FaaS in k8s
RUN curl -Lo fission https://github.com/fission/fission/releases/download/1.4.1/fission-cli-linux && \
    chmod +x fission && \
    mv fission /usr/local/bin/ 

# Install aws cli for working with amazon cloud
RUN pip3 install --no-cache-dir --upgrade awscli==1.16.248
RUN curl -Lo aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/local/bin/
        
# Install gcloud cli for working with google cloud
RUN curl -Lo gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-264.0.0-linux-x86_64.tar.gz && \
    tar -zxvf gcloud.tar.gz && \
    ./google-cloud-sdk/install.sh && \
    ln -s /google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
    
# Install az cli for working with azure cloud
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install the ansible cli for managing vm configurations
RUN apt install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

# Install the packer cli for packaging images
RUN curl -Lo packer.zip https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip && \
    unzip packer.zip && \
    chmod +x packer && \
    mv packer /usr/local/bin/

# Install common scripting toolss
RUN apt-get install -y jq && \
    pip3 install --no-cache-dir --upgrade yq

# Install Istio CLI
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.1 sh -
RUN cp istio-*/bin/istioctl /usr/local/bin/
    
VOLUME [ "/project" ]
WORKDIR /project
ENTRYPOINT [ "/project/entrypoint" ]
CMD [ "bash" ]

COPY entrypoint /project/entrypoint