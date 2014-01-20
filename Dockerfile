FROM paintedfox/ruby

RUN gem install github-pages
RUN apt-get install -y python-pygments


VOLUME  ["/data"]
WORKDIR /data

ENTRYPOINT ["jekyll"]

# jekyll's default port
EXPOSE 4000
