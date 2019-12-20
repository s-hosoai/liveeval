FROM elixir:1.9.4-alpine

RUN mkdir /home/eval/
WORKDIR /home/eval/
COPY client.exs /home/eval/client.exs
CMD elixir --name client@host.docker.internal --cookie eval client.exs