FROM paintedfox/ruby

RUN gem install github-pages

VOLUME  ["/data"]
WORKDIR /data

ENTRYPOINT ["jekyll"]

# jekyll's default port
EXPOSE 4000
