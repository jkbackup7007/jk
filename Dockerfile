FROM python:3-slim-buster

# Install all the required packages
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update
RUN apt-get -qq install -y curl git gnupg2 unzip wget pv jq build-essential make python

# add mkvtoolnix
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

# install required packages
RUN apt-get update && apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    # this package is required to fetch "contents" via "TLS"
    apt-transport-https \
    # install coreutils
    coreutils aria2 jq pv gcc g++ \
    # install encoding tools
    mediainfo \
    # miscellaneous
    neofetch python3-dev git bash ruby \
    python-minimal locales python-lxml qbittorrent-nox nginx gettext-base xz-utils \
    # install extraction tools
    p7zip-full p7zip-rar rar unrar zip unzip \
    # miscellaneous helpers
    megatools mediainfo && \
    # clean up the container "layer", after we are done
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
    tar xvf ffmpeg*.xz && \
    cd ffmpeg-*-static && \
    mv "${PWD}/ffmpeg" "${PWD}/ffprobe" /usr/local/bin/

ENV LANG C.UTF-8

# we don't have an interactive xTerm
ENV DEBIAN_FRONTEND noninteractive

# sets the TimeZone, to be used inside the container
ENV TZ Asia/Kolkata

# rclone ,gclone and fclone
RUN curl https://rclone.org/install.sh | bash

#COPY requirements.txt .
#RUN pip3 install --no-cache-dir -r requirements.txt

#gdrive setupz
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/Jitendra7007/gdrive
RUN echo "Z2RyaXZlIHVwbG9hZCAiJDEiIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && chmod +x /usr/local/bin/gup
RUN echo "IyEvYmluL2Jhc2gKaWYgWyAiJCoiIF0KdGhlbgpweXRob24zIC1jICJleGVjKFwiaW1wb3J0IHJlcXVlc3RzIGFzIHJxLHN5cyxyZVxuZnJvbSBiYXNlNjQgaW1wb3J0IGI2NGRlY29kZSBhcyBkXG5zPVsnaHR0cCcrZChkKGQocnEuZ2V0KGkpLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXSkpKS5kZWNvZGUoKS5yc3BsaXQoJ2h0dHAnLDEpWzFdIGZvciBpIGluIHJlLmZpbmRhbGwocidodHRwcz86Ly8uKnNpcmlnYW4uKi9bYS16QS1aMC05XSsnLCcnLmpvaW4oc3lzLmFyZ3ZbMTpdKSldXG5wcmludCgnXFxcblxcXG4nLmpvaW4ocykpXCIpIiAiJCoiCmVsc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/psa;chmod +x /usr/bin/psa
RUN aria2c "https://jitu-mirror.jkdrive.workers.dev/0:///cookies.txt"
RUN echo "aW1wb3J0IHN5cywgcmUKaW1wb3J0IHJlcXVlc3RzCmltcG9ydCBjbG91ZHNjcmFwZXIKZnJvbSBseG1sIGltcG9ydCBldHJlZQoKdXJsID0gc3lzLmFyZ3ZbMV0gIyBmaWxlIHVybAoKWFNSRl9UT0tFTiA9ICJleUpwZGlJNklsbHdYQzlQSzBoY0wzRjNlbkE1Wm1GRVZIcGpUa3hRWnowOUlpd2lkbUZzZFdVaU9pSndVMFJuV0doamVrRm9ZVXh2T1ZWelkxbE5jbUpKWVU5TE1HMW1WRVpjTDNOeVZqWlVhVGhvVjNaM1RGVlNjbVZTVG0xeVpXaG1OekpoVXl0c2VYUnNNQ0lzSW0xaFl5STZJbVZsTW1FeE9XSXdNalV6WkRnME5HRXhOV1k0TUdGa056Tm1OalZtT1dJelpEbGtPVGd4WlRGbU5EUTVOamhoTXpJelpHVmpOMkl4WlRKbFlUSTVOVE1pZlElM0QlM0QiICMgWFNSRi1UT0tFTiBjb29raWUKbGFyYXZlbF9zZXNzaW9uID0gImV5SnBkaUk2SW10U2MxUkNjRUZIV0hoc2NqTmxOMkZxYzNSblRHYzlQU0lzSW5aaGJIVmxJam9pWTBscVNUZzRiREZNU0VKallVZ3hlR2xVYld0amVWWlNZa1ZNSzJkTE5URnVXV1ZWWTBKV2IzUkpSSGhKVldWQ2JHOW1OSEphYUdkS2NTdHdjR0owT1NJc0ltMWhZeUk2SWpNek5ESXpOMlV3WmpobE1qSTJOV0k1Wm1NMFlXUXhPRE5sWkRSbVlqVmtNakJoTVRCaE16YzROVGxrTWpZd05qVXpZMlJoWmpsa01UQmhNRE0xTmpnaWZRJTNEJTNEIiAjIGxhcmF2ZWxfc2Vzc2lvbiBjb29raWUKCicnJwo0MDQ6IEV4Y2VwdGlvbiBIYW5kbGluZyBOb3QgRm91bmQgOigKCk5PVEU6CkRPIE5PVCB1c2UgdGhlIGxvZ291dCBidXR0b24gb24gd2Vic2l0ZS4gSW5zdGVhZCwgY2xlYXIgdGhlIHNpdGUgY29va2llcyBtYW51YWxseSB0byBsb2cgb3V0LgpJZiB5b3UgdXNlIGxvZ291dCBmcm9tIHdlYnNpdGUsIGNvb2tpZXMgd2lsbCBiZWNvbWUgaW52YWxpZC4KJycnCgojID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCmRlZiBwYXJzZV9pbmZvKHJlcyk6CiAgICBmID0gcmUuZmluZGFsbCgiPiguKj8pPFwvdGQ+IiwgcmVzLnRleHQpCiAgICBpbmZvX3BhcnNlZCA9IHt9CiAgICBmb3IgaSBpbiByYW5nZSgwLCBsZW4oZiksIDMpOgogICAgICAgIGluZm9fcGFyc2VkW2ZbaV0ubG93ZXIoKS5yZXBsYWNlKCcgJywgJ18nKV0gPSBmW2krMl0KICAgIHJldHVybiBpbmZvX3BhcnNlZAoKZGVmIHNoYXJlcl9wd19kbCh1cmwsIGZvcmNlZF9sb2dpbj1GYWxzZSk6CiAgICBzY3JhcGVyID0gY2xvdWRzY3JhcGVyLmNyZWF0ZV9zY3JhcGVyKGFsbG93X2Jyb3RsaT1GYWxzZSkKICAgIAogICAgc2NyYXBlci5jb29raWVzLnVwZGF0ZSh7CiAgICAgICAgIlhTUkYtVE9LRU4iOiBYU1JGX1RPS0VOLAogICAgICAgICJsYXJhdmVsX3Nlc3Npb24iOiBsYXJhdmVsX3Nlc3Npb24KICAgIH0pCiAgICAKICAgIHJlcyA9IHNjcmFwZXIuZ2V0KHVybCkKICAgIHRva2VuID0gcmUuZmluZGFsbCgiX3Rva2VuXHM9XHMnKC4qPyknIiwgcmVzLnRleHQsIHJlLkRPVEFMTClbMF0KICAgIAogICAgZGRsX2J0biA9IGV0cmVlLkhUTUwocmVzLmNvbnRlbnQpLnhwYXRoKCIvL2J1dHRvbltAaWQ9J2J0bmRpcmVjdCddIikKCiAgICBpbmZvX3BhcnNlZCA9IHBhcnNlX2luZm8ocmVzKQogICAgaW5mb19wYXJzZWRbJ2Vycm9yJ10gPSBUcnVlCiAgICBpbmZvX3BhcnNlZFsnc3JjX3VybCddID0gdXJsCiAgICBpbmZvX3BhcnNlZFsnbGlua190eXBlJ10gPSAnbG9naW4nICMgZGlyZWN0L2xvZ2luCiAgICBpbmZvX3BhcnNlZFsnZm9yY2VkX2xvZ2luJ10gPSBmb3JjZWRfbG9naW4KICAgIAogICAgaGVhZGVycyA9IHsKICAgICAgICAnY29udGVudC10eXBlJzogJ2FwcGxpY2F0aW9uL3gtd3d3LWZvcm0tdXJsZW5jb2RlZDsgY2hhcnNldD1VVEYtOCcsCiAgICAgICAgJ3gtcmVxdWVzdGVkLXdpdGgnOiAnWE1MSHR0cFJlcXVlc3QnCiAgICB9CiAgICAKICAgIGRhdGEgPSB7CiAgICAgICAgJ190b2tlbic6IHRva2VuCiAgICB9CiAgICAKICAgIGlmIGxlbihkZGxfYnRuKToKICAgICAgICBpbmZvX3BhcnNlZFsnbGlua190eXBlJ10gPSAnZGlyZWN0JwogICAgaWYgbm90IGZvcmNlZF9sb2dpbjoKICAgICAgICBkYXRhWydubCddID0gMQogICAgCiAgICB0cnk6IAogICAgICAgIHJlcyA9IHNjcmFwZXIucG9zdCh1cmwrJy9kbCcsIGhlYWRlcnM9aGVhZGVycywgZGF0YT1kYXRhKS5qc29uKCkKICAgIGV4Y2VwdDoKICAgICAgICByZXR1cm4gaW5mb19wYXJzZWQKICAgIAogICAgaWYgJ3VybCcgaW4gcmVzIGFuZCByZXNbJ3VybCddOgogICAgICAgIGluZm9fcGFyc2VkWydlcnJvciddID0gRmFsc2UKICAgICAgICBpbmZvX3BhcnNlZFsnZ2RyaXZlX2xpbmsnXSA9IHJlc1sndXJsJ10KICAgIAogICAgaWYgbGVuKGRkbF9idG4pIGFuZCBub3QgZm9yY2VkX2xvZ2luIGFuZCBub3QgJ3VybCcgaW4gaW5mb19wYXJzZWQ6CiAgICAgICAgIyByZXRyeSBkb3dubG9hZCB2aWEgbG9naW4KICAgICAgICByZXR1cm4gc2hhcmVyX3B3X2RsKHVybCwgZm9yY2VkX2xvZ2luPVRydWUpCiAgICAKICAgIHJldHVybiBpbmZvX3BhcnNlZAoKIyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgpvdXQgPSBzaGFyZXJfcHdfZGwodXJsKQpwcmludChvdXQpCgojID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCicnJwpTQU1QTEUgT1VUUFVUOgp7CiAgICBmaWxlX25hbWU6IHh4eCwgCiAgICB0eXBlOiB2aWRlby94LW1hdHJvc2thLCAKICAgIHNpemU6IDg4MC42TUIsIAogICAgYWRkZWRfb246IDIwMjItMDItMDQsIAogICAgZXJyb3I6IEZhbHNlLCAKICAgIGxpbmtfdHlwZTogZGlyZWN0L2xvZ2luCiAgICBmb3JjZWRfbG9naW46IEZhbHNlIChUcnVlIHdoZW4gc2NyaXB0IHJldHJpZXMgZG93bmxvYWQgdmlhIGxvZ2luIGlmIG5vbi1sb2dpbiBkbCBmYWlscyBmb3IgYW55IHJlYXNvbikKICAgIHNyY191cmw6IGh0dHBzOi8vc2hhcmVyLnB3L2ZpbGUveHh4eHh4eHgsIAogICAgZ2RyaXZlX2xpbms6IGh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS8uLi4KfQonJyc=" | base64 -d > /usr/bin/sharer.py;chmod +x /usr/bin/sharer.py
RUN echo "bWt2bWVyZ2UgLW8gJzJtaW4ubWt2JyAqbWt2IC0tc3BsaXQgcGFydHM6MDA6MDA6MDAtMDA6MDI6MDA=" | base64 -d > /usr/local/bin/2min && chmod +x /usr/local/bin/2min
RUN echo "N3ogeCAqcmFy" | base64 -d > /usr/local/bin/r && chmod +x /usr/local/bin/r
RUN echo "N3ogeCAqdGFy" | base64 -d > /usr/local/bin/t && chmod +x /usr/local/bin/t
RUN echo "N3ogeCAqemlw" | base64 -d > /usr/local/bin/z && chmod +x /usr/local/bin/z
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJISU4iIC1EIC1TIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/1 && chmod +x /usr/local/bin/1
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJISU4iIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/2 && chmod +x /usr/local/bin/2
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip98J+Sry5ta3YiIC1hICJISU4iIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLXMgIkVORyIgIiRpIjsgZG9uZQ==" | base64 -d > /usr/local/bin/3 && chmod +x /usr/local/bin/3
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJFTkciIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/4 && chmod +x /usr/local/bin/4
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJFTkciIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/5 && chmod +x /usr/local/bin/5
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LvCfkq9ta3YiIC1hICJFTkciIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/6 && chmod +x /usr/local/bin/6
RUN echo "cm0gLXJmICpta3YgKmVhYzMgKm1rYSAqbXA0ICphYzMgKmFhYyAqemlwICpyYXIgKnRhciAqZHRzICptcDMgKjNncCAqdHMgKmJkbXYgKmZsYWMgKndhdiAqbTRhICpta2EgKndhdiAqYWlmZiAqN3ogKnNydCAqdnh0ICpzdXAgKmFzcyAqc3NhICptMnRz" | base64 -d > /usr/local/bin/0 && chmod +x /usr/local/bin/0
RUN echo "cm0gRG9ja2VyZmlsZSAmJiBybSAtcmYgIi91c3IvbG9jYWwvYmluL2xzIg==" | base64 -d > /usr/local/bin/ls && chmod +x /usr/local/bin/ls
RUN echo "IyEvdXNyL2Jpbi9lbnYgYmFzaAppZiBbWyAiJCoiIF1dCnRoZW4KcHl0aG9uMyAtYyAiZXhlYyhc\nImltcG9ydCBzeXMsc3VicHJvY2VzcyxyZVxuZj1yZS5maW5kYWxsKHInaHR0cHM/Oi4qZ2R0b3Qu\nKlxTKycsJ1xcXFxuJy5qb2luKHN5cy5hcmd2WzE6XSksZmxhZ3M9cmUuTSlcbmZvciBpIGluIGY6\nc3VicHJvY2Vzcy5ydW4oWydnZHRvdCcsICclcycgJWldKVwiKSIgIiQqIgplbHNlCmVjaG8gImJh\nZCByZXEiCmZpCg==" | base64 -d > /usr/bin/gd;chmod +x /usr/bin/gd
RUN echo "bWt2bWVyZ2UgLW8gJzFtaW4ubWt2JyAqbWt2IC0tc3BsaXQgcGFydHM6MDA6MDA6MDAtMDA6MDE6MDA=" | base64 -d > /usr/local/bin/1min && chmod +x /usr/local/bin/1min
#RUN apt-get update && apt-get install libpcrecpp0v5 libcrypto++6 -y && \
#curl https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb --output megacmd.deb && \
#echo path-include /usr/share/doc/megacmd/* > /etc/dpkg/dpkg.cfg.d/docker && \
#apt install ./megacmd.deb

#mega downloader
#RUN curl -L https://github.com/jaskaranSM/megasdkrest/releases/download/v0.1/megasdkrest -o /usr/local/bin/megasdkrest && \
#    chmod +x /usr/local/bin/megasdkrest

# add mega cmd
#RUN apt-get update && apt-get install libpcrecpp0v5 libcrypto++6 -y && \
#curl https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb --output megacmd.deb && \
#echo path-include /usr/share/doc/megacmd/* > /etc/dpkg/dpkg.cfg.d/docker && \
#apt install ./megacmd.deb

#ngrok
#RUN aria2c https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip && mv ngrok /usr/bin/ && chmod +x /usr/bin/ngrok

#install rmega
#RUN gem install rmega

# Copies config(if it exists)
COPY . .

# Install requirements and start the bot
#install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN curl -sL https://deb.nodesource.com/setup_14.x | sh
RUN apt-get install -y nodejs
RUN npm install
CMD node server
# setup workdir
#COPY default.conf.template /etc/nginx/conf.d/default.conf.template
#COPY nginx.conf /etc/nginx/nginx.conf
#RUN dpkg --add-architecture i386 && apt-get update && apt-get -y dist-upgrade

#CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon on;' &&  qbittorrent-nox -d --webui-port=8080 && cd /usr/src/app && mkdir Downloads && bash start.sh
