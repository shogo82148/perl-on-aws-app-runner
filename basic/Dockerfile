FROM perl:5.34.0

WORKDIR /usr/src/myapp
COPY cpanfile .
RUN cpanm --notest --installdeps .
COPY app.psgi .

CMD [ "plackup", "app.psgi" ]
