FROM ruby:2-alpine

WORKDIR /app

RUN apk add --no-cache build-base git --virtual build-packages \
  && git clone --depth 1 https://github.com/taku910/mecab.git \
  && cd mecab/mecab \
	&& ./configure --enable-utf8-only --with-charset=utf8 \
	&& make \
	&& make install \
	&& cd ../mecab-ipadic \
	&& ./configure --with-charset=utf8 \
	&& make \
	&& make install \
	&& cd ../.. \
	&& git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
	&& xz -dkv mecab-ipadic-neologd/seed/mecab-user-dict-seed.*.csv.xz \
	&& /usr/local/libexec/mecab/mecab-dict-index -d /usr/local/lib/mecab/dic/ipadic -u /usr/local/lib/mecab/dic/neologd.dic -f utf-8 -t utf-8 mecab-ipadic-neologd/seed/mecab-user-dict-seed.*.csv \
	&& rm -fr mecab mecab-ipadic-neologd \
	&& apk del build-packages \
	&& echo "userdic = /usr/local/lib/mecab/dic/neologd.dic" >> /usr/local/etc/mecabrc
