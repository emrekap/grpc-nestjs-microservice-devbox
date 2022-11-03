

FROM amd64/node:18
ARG LOCAL_USER_HOME=/Users/emre
ARG DEV_USER=dev-user
ARG DEV_USER_UID=5000
ARG DEV_USER_GID=$DEV_USER_UID
ARG DEV_USER_HOME=/home/dev-user
ARG APP_ROOT_DIR=/grpc-monorepo

VOLUME ${APP_ROOT_DIR}

# Asking gatsby to stop sending usage analytics data.
ENV ZSH=${DEV_USER_HOME}/.oh-my-zsh
ENV ZSH_CUSTOM=${ZSH}/custom
ENV EDITOR=code

# Update apt-get and install low-level build dependencies
RUN apt-get update && apt-get install -y gnupg software-properties-common curl

# Create the user
RUN groupadd --gid $DEV_USER_GID $DEV_USER \
    && useradd --uid $DEV_USER_UID --gid $DEV_USER_GID -ms /bin/zsh --no-log-init $DEV_USER \
    && apt-get install -y sudo \
    && echo $DEV_USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$DEV_USER \
    && chmod 0440 /etc/sudoers.d/$DEV_USER

# Create dir for copy local ssh keys
RUN mkdir -p ${DEV_USER_HOME}/.ssh

RUN npm config set registry https://registry.npmjs.org/
RUN npm install -g npm@8.19.2 protoc


RUN apt-get install -y git-flow openssh-client zsh silversearcher-ag groff less


# Install Docker CE CLI
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Install Docker Compose
RUN export LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")') \
    && curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install scraping dependencies
RUN apt-get install -y --fix-missing libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libasound2 xvfb apache2

# Install zsh and plugins
RUN echo "Y" | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${DEV_USER_HOME}/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
RUN git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM}/plugins/k
RUN git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM}/plugins/zsh-history-substring-search

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${DEV_USER_HOME}/.fzf
RUN echo "y" | ${DEV_USER_HOME}/.fzf/install


RUN git clone https://github.com/b4b4r07/enhancd ${DEV_USER_HOME}/.enhancd

COPY ./.devcontainer/.zshrc ${DEV_USER_HOME}/.zshrc
COPY ./.devcontainer/.p10k.zsh ${DEV_USER_HOME}/.p10k.zsh
COPY ./.devcontainer/aws/awscliv2.zip ${DEV_USER_HOME}/awscliv2.zip
COPY ./.devcontainer/aws/config ${DEV_USER_HOME}/.aws/config
COPY ./.devcontainer/aws/credentials ${DEV_USER_HOME}/.aws/credentials
# COPY ~/.ssh ${DEV_USER_HOME}/.ssh
# COPY ${LOCAL_USER_HOME}/.ssh ${DEV_USER_HOME}/.ssh


WORKDIR ${DEV_USER_HOME}

RUN unzip ${DEV_USER_HOME}/awscliv2.zip && ./aws/install

RUN mkdir -p ${APP_ROOT_DIR}


RUN chown -R ${DEV_USER} /home/${DEV_USER} && \
	chown -R ${DEV_USER} /usr/local/lib/node_modules && \
	chown -R ${DEV_USER} ${APP_ROOT_DIR} && \
	chown -R ${DEV_USER} /home/${DEV_USER}/.ssh && \
	chown -R ${DEV_USER} /var/www/

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ${DEV_USER_HOME}/.ssh/config
# RUN git clone git@github.com:emrekap/grpc-nest-microservice-monorepo.git ${APP_ROOT_DIR}
# RUN --mount=type=secret,id=ssh_id,target=/root/.ssh/id_rsa  git clone git@bitbucket.org:User/repo.git
USER ${DEV_USER}