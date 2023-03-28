FROM ubuntu:latest

ENV TZ=Asial/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV USER user

RUN apt update
RUN apt upgrade -y
RUN apt install -y openssh-server sudo nano python3 python3-pip git nodejs 

RUN npm install -g n
RUN n latest
RUN npm install -g npm@latest

RUN mkdir /var/run/sshd


RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/$USER --gecos "User"  $USER
RUN echo $USER:$USER | chpasswd
RUN usermod -aG sudo $USER

RUN mkdir -p /home/$USER/.ssh
RUN touch /home/$USER/.ssh/authorized_keys
RUN chown -R $USER:$USER /home/$USER/.ssh
RUN chmod 700 /home/$USER/.ssh
RUN chmod 600 /home/$USER/.ssh/authorized_keys

RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config


EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

# docker run -v ./:/home/user/ -d -p 3000:22 --name sangjun-server highjun10170/ubuntu-ssh:1.0.0
