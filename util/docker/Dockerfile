FROM ubuntu:xenial

# install required packages
RUN apt-get clean
RUN apt-get update \
    && apt-get install -y  git \
    net-tools \
    aptitude \
    build-essential \
    python-setuptools \
    python-dev \
    python-pip \
    python3-tk \
    python3-pip \
    python3-gdal \
    python3-lxml \
    python3-pygraphviz \
    python3-numpy \
    python3-scipy \
    software-properties-common \
    ansible \
    curl \
    vim \
    iptables \
    iputils-ping \
    sudo \
    graphviz

# install containernet (using its Ansible playbook)
COPY . /containernet
WORKDIR /containernet/ansible
RUN ansible-playbook -i "localhost," -c local --skip-tags "notindocker" install.yml
WORKDIR /containernet
RUN python setup.py develop

# Hotfix: https://github.com/pytest-dev/pytest/issues/4770
RUN pip2 install "more-itertools<=5.0.0"
RUN pip3 install --upgrade docker==2.0.2 pytest==4.6.4 python-iptables ipykernel jupyter ptpython pyyaml matplotlib==3.0.3 networkx
RUN PYTHON=`which python3` make install
RUN python3 setup.py install
RUN python3 setup.py develop

# tell containernet that it runs in a container
ENV CONTAINERNET_NESTED 1

# disable auto-logout on shells
ENV TMOUT 0
RUN echo "export TMOUT=0" >> /root/.bashrc
RUN echo "export TMOUT=0" >> /etc/profile

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python3 -c "import matplotlib.pyplot"
# Jupyter starting script
COPY jupyter.sh /usr/local/bin/jupyter.sh
COPY examples/test.ipynb /containernet/examples/test.ipynb
RUN chmod +x /usr/local/bin/jupyter.sh

# Important: This entrypoint is required to start the OVS service
ENTRYPOINT ["util/docker/entrypoint.sh"]
# CMD ["jupyter", "notebook", "--ip='*'", "--NotebookApp.token=''", "--NotebookApp.password=''", "--allow-root", "--no-browser"]
# CMD ["python", "examples/containernet_example.py"]
CMD ["/usr/local/bin/jupyter.sh"]
